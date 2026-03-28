//go:build android && cgo

package zerotier

/*
#cgo android,arm64 CFLAGS: -I${SRCDIR}/libzt/include
#cgo android,arm64 LDFLAGS: -L${SRCDIR}/libzt/lib/arm64-v8a -lzt -lstdc++ -lm
#cgo android,arm CFLAGS: -I${SRCDIR}/libzt/include
#cgo android,arm LDFLAGS: -L${SRCDIR}/libzt/lib/armeabi-v7a -lzt -lstdc++ -lm
#cgo android,amd64 CFLAGS: -I${SRCDIR}/libzt/include
#cgo android,amd64 LDFLAGS: -L${SRCDIR}/libzt/lib/x86_64 -lzt -lstdc++ -lm

#include <stdlib.h>
#include <string.h>
#include <ZeroTierSockets.h>

// Forward declaration for fd protection callback
extern void ztOnSocketCreate(int fd);
*/
import "C"

import (
	"context"
	"encoding/base64"
	"fmt"
	"net"
	"net/netip"
	"os"
	"path/filepath"
	"strconv"
	"sync"
	"time"
	"unsafe"
)

// ProtectFdFunc is set by the main package to protect socket fds from VPN routing loops
var ProtectFdFunc func(fd int)

//export ztOnSocketCreate
func ztOnSocketCreate(fd C.int) {
	if ProtectFdFunc != nil {
		ProtectFdFunc(int(fd))
	}
}

// Node manages a ZeroTier node instance via libzt
type Node struct {
	mu          sync.Mutex
	storagePath string
	networkID   uint64
	running     bool
	online      bool
	nodeID      uint64
	assignedIPs []netip.Prefix
	routes      []netip.Prefix
}

// NewNode creates a new ZeroTier node
func NewNode() *Node {
	return &Node{}
}

// Start initializes and starts the ZeroTier node
func (n *Node) Start(storagePath string, planetData []byte) error {
	n.mu.Lock()
	if n.running {
		n.mu.Unlock()
		return fmt.Errorf("node already running")
	}

	n.storagePath = storagePath

	// Ensure storage directory exists
	if err := os.MkdirAll(storagePath, 0755); err != nil {
		n.mu.Unlock()
		return fmt.Errorf("create storage dir: %w", err)
	}

	// Write custom planet file if provided
	if len(planetData) > 0 {
		planetPath := filepath.Join(storagePath, "planet")
		if err := os.WriteFile(planetPath, planetData, 0644); err != nil {
			n.mu.Unlock()
			return fmt.Errorf("write planet file: %w", err)
		}
	}

	// Initialize libzt from storage path
	cPath := C.CString(storagePath)
	defer C.free(unsafe.Pointer(cPath))

	ret := C.zts_init_from_storage(cPath)
	if ret != C.ZTS_ERR_OK {
		n.mu.Unlock()
		return fmt.Errorf("zts_init_from_storage failed: %d", ret)
	}

	// Start the node
	ret = C.zts_node_start()
	if ret != C.ZTS_ERR_OK {
		n.mu.Unlock()
		return fmt.Errorf("zts_node_start failed: %d", ret)
	}
	n.mu.Unlock()

	// Wait for node to come online without holding the lock (timeout 30s)
	online := false
	for i := 0; i < 300; i++ {
		if C.zts_node_is_online() == 1 {
			online = true
			break
		}
		time.Sleep(100 * time.Millisecond)
	}

	n.mu.Lock()
	if !online {
		C.zts_node_stop()
		n.mu.Unlock()
		return fmt.Errorf("node failed to come online within 30s")
	}

	n.online = true
	n.nodeID = uint64(C.zts_node_get_id())
	n.running = true
	n.mu.Unlock()
	return nil
}

// Stop shuts down the ZeroTier node
func (n *Node) Stop() error {
	n.mu.Lock()
	defer n.mu.Unlock()

	if !n.running {
		return nil
	}

	if n.networkID != 0 {
		C.zts_net_leave(C.uint64_t(n.networkID))
		n.networkID = 0
	}

	C.zts_node_stop()
	n.running = false
	n.online = false
	n.assignedIPs = nil
	n.routes = nil
	return nil
}

// JoinNetwork joins a ZeroTier network
func (n *Node) JoinNetwork(networkID uint64) error {
	n.mu.Lock()
	defer n.mu.Unlock()

	if !n.running {
		return fmt.Errorf("node not running")
	}

	ret := C.zts_net_join(C.uint64_t(networkID))
	if ret != C.ZTS_ERR_OK {
		return fmt.Errorf("zts_net_join failed: %d", ret)
	}
	n.networkID = networkID

	// Wait for network transport to be ready (timeout 30s)
	for i := 0; i < 300; i++ {
		if C.zts_net_transport_is_ready(C.uint64_t(networkID)) == 1 {
			break
		}
		time.Sleep(100 * time.Millisecond)
	}

	// Get assigned addresses
	n.updateAddresses()

	return nil
}

// LeaveNetwork leaves the current ZeroTier network
func (n *Node) LeaveNetwork() error {
	n.mu.Lock()
	defer n.mu.Unlock()

	if n.networkID == 0 {
		return nil
	}

	C.zts_net_leave(C.uint64_t(n.networkID))
	n.networkID = 0
	n.assignedIPs = nil
	n.routes = nil
	return nil
}

// updateAddresses fetches assigned IPs from the ZeroTier network
func (n *Node) updateAddresses() {
	n.assignedIPs = nil

	// Get IPv4 address
	var addr4 C.struct_sockaddr_storage
	if C.zts_addr_get(C.uint64_t(n.networkID), C.ZTS_AF_INET, (*C.struct_sockaddr_storage)(unsafe.Pointer(&addr4))) == C.ZTS_ERR_OK {
		sa4 := (*C.struct_sockaddr_in)(unsafe.Pointer(&addr4))
		ip := netip.AddrFrom4(*(*[4]byte)(unsafe.Pointer(&sa4.sin_addr)))
		// Default to /24 subnet for ZeroTier managed routes
		prefix := netip.PrefixFrom(ip, 24)
		n.assignedIPs = append(n.assignedIPs, prefix)
	}

	// Get IPv6 address
	var addr6 C.struct_sockaddr_storage
	if C.zts_addr_get(C.uint64_t(n.networkID), C.ZTS_AF_INET6, (*C.struct_sockaddr_storage)(unsafe.Pointer(&addr6))) == C.ZTS_ERR_OK {
		sa6 := (*C.struct_sockaddr_in6)(unsafe.Pointer(&addr6))
		ip := netip.AddrFrom16(*(*[16]byte)(unsafe.Pointer(&sa6.sin6_addr)))
		prefix := netip.PrefixFrom(ip, 64)
		n.assignedIPs = append(n.assignedIPs, prefix)
	}

	// Get managed routes from the network
	n.updateRoutes()
}

// updateRoutes fetches managed routes from the ZeroTier network controller
func (n *Node) updateRoutes() {
	n.routes = nil
	// libzt provides route info through zts_route_get_all or via the network config
	// For now, derive routes from assigned addresses
	for _, prefix := range n.assignedIPs {
		masked := prefix.Masked()
		n.routes = append(n.routes, masked)
	}
}

// GetAssignedAddresses returns assigned IP prefixes
func (n *Node) GetAssignedAddresses() []netip.Prefix {
	n.mu.Lock()
	defer n.mu.Unlock()
	result := make([]netip.Prefix, len(n.assignedIPs))
	copy(result, n.assignedIPs)
	return result
}

// GetRoutes returns all routes (subnet + managed routes)
func (n *Node) GetRoutes() []netip.Prefix {
	n.mu.Lock()
	defer n.mu.Unlock()
	result := make([]netip.Prefix, len(n.routes))
	copy(result, n.routes)
	return result
}

// GetNodeID returns the node's ZeroTier ID as hex string
func (n *Node) GetNodeID() string {
	n.mu.Lock()
	defer n.mu.Unlock()
	if n.nodeID == 0 {
		return ""
	}
	return fmt.Sprintf("%010x", n.nodeID)
}

// IsOnline returns whether the node is online
func (n *Node) IsOnline() bool {
	n.mu.Lock()
	defer n.mu.Unlock()
	return n.online && C.zts_node_is_online() == 1
}

// IsRunning returns whether the node is started
func (n *Node) IsRunning() bool {
	n.mu.Lock()
	defer n.mu.Unlock()
	return n.running
}

// DialTCP creates a TCP connection through the ZeroTier network
func (n *Node) DialTCP(ctx context.Context, address string) (net.Conn, error) {
	host, portStr, err := net.SplitHostPort(address)
	if err != nil {
		return nil, fmt.Errorf("invalid address: %w", err)
	}

	port, err := strconv.Atoi(portStr)
	if err != nil {
		return nil, fmt.Errorf("invalid port: %w", err)
	}

	ip := net.ParseIP(host)
	if ip == nil {
		return nil, fmt.Errorf("invalid IP: %s", host)
	}

	fd := C.zts_bsd_socket(C.ZTS_AF_INET, C.ZTS_SOCK_STREAM, 0)
	if fd < 0 {
		return nil, fmt.Errorf("zts_bsd_socket failed: %d", fd)
	}

	// Build sockaddr_in
	var sa C.struct_sockaddr_in
	sa.sin_family = C.ZTS_AF_INET
	sa.sin_port = C.htons(C.uint16_t(port))

	ip4 := ip.To4()
	if ip4 != nil {
		C.memcpy(unsafe.Pointer(&sa.sin_addr), unsafe.Pointer(&ip4[0]), 4)
	}

	// Run blocking connect in a goroutine so we can respect context cancellation
	type connectResult struct {
		err error
	}
	ch := make(chan connectResult, 1)
	go func() {
		ret := C.zts_bsd_connect(fd, (*C.struct_sockaddr)(unsafe.Pointer(&sa)), C.socklen_t(unsafe.Sizeof(sa)))
		if ret < 0 {
			ch <- connectResult{err: fmt.Errorf("zts_bsd_connect failed: %d", ret)}
		} else {
			ch <- connectResult{}
		}
	}()

	select {
	case <-ctx.Done():
		C.zts_bsd_close(fd)
		return nil, ctx.Err()
	case res := <-ch:
		if res.err != nil {
			C.zts_bsd_close(fd)
			return nil, res.err
		}
		return newZTConn(fd, address), nil
	}
}

// DialUDP creates a UDP connection through the ZeroTier network
func (n *Node) DialUDP(ctx context.Context, address string) (net.PacketConn, error) {
	fd := C.zts_bsd_socket(C.ZTS_AF_INET, C.ZTS_SOCK_DGRAM, 0)
	if fd < 0 {
		return nil, fmt.Errorf("zts_bsd_socket UDP failed: %d", fd)
	}

	return newZTPacketConn(fd, address), nil
}

// ParsePlanetData decodes base64 planet data
func ParsePlanetData(data string) ([]byte, error) {
	if data == "" {
		return nil, nil
	}
	return base64.StdEncoding.DecodeString(data)
}
