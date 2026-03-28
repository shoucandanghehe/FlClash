//go:build android && cgo

package zerotier

/*
#include <ZeroTierSockets.h>
#include <string.h>
#include <arpa/inet.h>
*/
import "C"

import (
	"fmt"
	"io"
	"net"
	"strconv"
	"time"
	"unsafe"
)

// ztConn wraps a libzt TCP socket as a net.Conn
type ztConn struct {
	fd      C.int
	address string
}

func newZTConn(fd C.int, address string) *ztConn {
	return &ztConn{fd: fd, address: address}
}

func (c *ztConn) Read(b []byte) (int, error) {
	if len(b) == 0 {
		return 0, nil
	}
	n := C.zts_bsd_recv(c.fd, unsafe.Pointer(&b[0]), C.size_t(len(b)), 0)
	if n < 0 {
		return 0, fmt.Errorf("zts_bsd_recv failed: %d", n)
	}
	if n == 0 {
		return 0, io.EOF
	}
	return int(n), nil
}

func (c *ztConn) Write(b []byte) (int, error) {
	if len(b) == 0 {
		return 0, nil
	}
	n := C.zts_bsd_send(c.fd, unsafe.Pointer(&b[0]), C.size_t(len(b)), 0)
	if n < 0 {
		return 0, fmt.Errorf("zts_bsd_send failed: %d", n)
	}
	return int(n), nil
}

func (c *ztConn) Close() error {
	C.zts_bsd_close(c.fd)
	return nil
}

func (c *ztConn) LocalAddr() net.Addr {
	return &net.TCPAddr{}
}

func (c *ztConn) RemoteAddr() net.Addr {
	host, portStr, _ := net.SplitHostPort(c.address)
	port, _ := strconv.Atoi(portStr)
	return &net.TCPAddr{
		IP:   net.ParseIP(host),
		Port: port,
	}
}

func (c *ztConn) SetDeadline(t time.Time) error {
	_ = c.SetReadDeadline(t)
	_ = c.SetWriteDeadline(t)
	return nil
}

func (c *ztConn) SetReadDeadline(t time.Time) error {
	return setSocketTimeout(c.fd, C.ZTS_SO_RCVTIMEO, t)
}

func (c *ztConn) SetWriteDeadline(t time.Time) error {
	return setSocketTimeout(c.fd, C.ZTS_SO_SNDTIMEO, t)
}

// ztPacketConn wraps a libzt UDP socket as a net.PacketConn
type ztPacketConn struct {
	fd      C.int
	address string
}

func newZTPacketConn(fd C.int, address string) *ztPacketConn {
	return &ztPacketConn{fd: fd, address: address}
}

func (c *ztPacketConn) ReadFrom(b []byte) (int, net.Addr, error) {
	if len(b) == 0 {
		return 0, nil, nil
	}
	var sa C.struct_zts_sockaddr_in
	salen := C.zts_socklen_t(unsafe.Sizeof(sa))
	n := C.zts_bsd_recvfrom(c.fd, unsafe.Pointer(&b[0]), C.size_t(len(b)), 0,
		(*C.struct_zts_sockaddr)(unsafe.Pointer(&sa)), &salen)
	if n < 0 {
		return 0, nil, fmt.Errorf("zts_bsd_recvfrom failed: %d", n)
	}

	ip := make(net.IP, 4)
	C.memcpy(unsafe.Pointer(&ip[0]), unsafe.Pointer(&sa.sin_addr), 4)
	port := int(C.ntohs(sa.sin_port))
	addr := &net.UDPAddr{IP: ip, Port: port}

	return int(n), addr, nil
}

func (c *ztPacketConn) WriteTo(b []byte, addr net.Addr) (int, error) {
	udpAddr, ok := addr.(*net.UDPAddr)
	if !ok {
		return 0, fmt.Errorf("invalid addr type")
	}

	var sa C.struct_zts_sockaddr_in
	sa.sin_family = C.ZTS_AF_INET
	sa.sin_port = C.htons(C.uint16_t(udpAddr.Port))
	ip4 := udpAddr.IP.To4()
	if ip4 != nil {
		C.memcpy(unsafe.Pointer(&sa.sin_addr), unsafe.Pointer(&ip4[0]), 4)
	}

	if len(b) == 0 {
		return 0, nil
	}
	n := C.zts_bsd_sendto(c.fd, unsafe.Pointer(&b[0]), C.size_t(len(b)), 0,
		(*C.struct_zts_sockaddr)(unsafe.Pointer(&sa)), C.zts_socklen_t(unsafe.Sizeof(sa)))
	if n < 0 {
		return 0, fmt.Errorf("zts_bsd_sendto failed: %d", n)
	}
	return int(n), nil
}

func (c *ztPacketConn) Close() error {
	C.zts_bsd_close(c.fd)
	return nil
}

func (c *ztPacketConn) LocalAddr() net.Addr {
	return &net.UDPAddr{}
}

func (c *ztPacketConn) SetDeadline(t time.Time) error {
	_ = c.SetReadDeadline(t)
	_ = c.SetWriteDeadline(t)
	return nil
}

func (c *ztPacketConn) SetReadDeadline(t time.Time) error {
	return setSocketTimeout(c.fd, C.ZTS_SO_RCVTIMEO, t)
}

func (c *ztPacketConn) SetWriteDeadline(t time.Time) error {
	return setSocketTimeout(c.fd, C.ZTS_SO_SNDTIMEO, t)
}

// setSocketTimeout sets SO_RCVTIMEO or SO_SNDTIMEO on a libzt socket.
// A zero time.Time clears the timeout.
func setSocketTimeout(fd C.int, optname C.int, t time.Time) error {
	var tv C.struct_zts_timeval
	if !t.IsZero() {
		d := time.Until(t)
		if d < 0 {
			d = 0
		}
		sec := d / time.Second
		usec := (d % time.Second) / time.Microsecond
		tv.tv_sec = C.long(sec)
		tv.tv_usec = C.long(usec)
	}
	ret := C.zts_bsd_setsockopt(fd, C.ZTS_SOL_SOCKET, optname,
		unsafe.Pointer(&tv), C.zts_socklen_t(unsafe.Sizeof(tv)))
	if ret < 0 {
		return fmt.Errorf("setsockopt timeout failed: %d", ret)
	}
	return nil
}
