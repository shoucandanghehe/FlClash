//go:build android && cgo

package zerotier

import (
	"encoding/json"
	"fmt"
	"net/netip"
	"strconv"
	"sync"

	"github.com/metacubex/mihomo/adapter"
	RC "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/log"
	"github.com/metacubex/mihomo/rules/common"
	"github.com/metacubex/mihomo/tunnel"
)

// DefaultManager is the global ZeroTier manager instance
var DefaultManager = &Manager{}

// SendMessageFunc is set by the main package to send events to Flutter
var SendMessageFunc func(msgType string, data interface{})

// Manager manages the ZeroTier node lifecycle and Clash integration
type Manager struct {
	mu      sync.Mutex
	node    *Node
	adapter *ZeroTierAdapter
	config  ZeroTierConfig
	running bool
}

// Start initializes and starts the ZeroTier node with the given config
func (m *Manager) Start(cfg ZeroTierConfig, homeDir string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.running {
		return fmt.Errorf("zerotier already running")
	}

	m.config = cfg

	// Parse network ID
	networkID, err := strconv.ParseUint(cfg.NetworkID, 16, 64)
	if err != nil {
		return fmt.Errorf("invalid network ID: %w", err)
	}

	// Parse custom planet data
	planetData, err := ParsePlanetData(cfg.PlanetData)
	if err != nil {
		return fmt.Errorf("invalid planet data: %w", err)
	}

	// Create and start node
	storagePath := homeDir + "/zerotier"
	m.node = NewNode()

	log.Infoln("[ZeroTier] Starting node...")
	if err := m.node.Start(storagePath, planetData); err != nil {
		return fmt.Errorf("start node: %w", err)
	}

	log.Infoln("[ZeroTier] Node online, ID: %s", m.node.GetNodeID())

	// Join network
	log.Infoln("[ZeroTier] Joining network %s...", cfg.NetworkID)
	if err := m.node.JoinNetwork(networkID); err != nil {
		m.node.Stop()
		return fmt.Errorf("join network: %w", err)
	}

	// Create adapter
	m.adapter = NewAdapter(m.node)
	m.running = true

	// Log assigned IPs
	for _, prefix := range m.node.GetAssignedAddresses() {
		log.Infoln("[ZeroTier] Assigned: %s", prefix.String())
	}

	// Send status update to Flutter
	m.sendStatus()

	return nil
}

// Stop shuts down the ZeroTier node and cleans up
func (m *Manager) Stop() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if !m.running {
		return nil
	}

	log.Infoln("[ZeroTier] Stopping...")

	// Remove injected rules
	m.removeInjectedRules()

	// Remove adapter from proxy map
	delete(tunnel.Proxies(), AdapterName)

	// Stop node
	if m.node != nil {
		m.node.Stop()
	}

	m.node = nil
	m.adapter = nil
	m.running = false

	m.sendStatus()
	return nil
}

// InjectAdapter adds the ZeroTier adapter to Clash's proxy map
func (m *Manager) InjectAdapter() {
	m.mu.Lock()
	defer m.mu.Unlock()

	if !m.running || m.adapter == nil {
		return
	}

	proxy := adapter.NewProxy(m.adapter)
	tunnel.Proxies()[AdapterName] = proxy
	log.Infoln("[ZeroTier] Adapter injected into proxy map")
}

// InjectRules adds IP-CIDR rules for ZeroTier subnets and routes to the Clash rule chain
func (m *Manager) InjectRules() {
	m.mu.Lock()
	defer m.mu.Unlock()

	if !m.running || m.node == nil {
		return
	}

	// First remove any previously injected rules
	m.removeInjectedRules()

	// Collect all routes (assigned subnets + managed routes)
	allRoutes := m.node.GetRoutes()
	assignedAddrs := m.node.GetAssignedAddresses()

	// Merge: use assigned address subnets + managed routes
	prefixSet := make(map[string]netip.Prefix)
	for _, p := range assignedAddrs {
		masked := p.Masked()
		prefixSet[masked.String()] = masked
	}
	for _, p := range allRoutes {
		masked := p.Masked()
		prefixSet[masked.String()] = masked
	}

	// Create rules
	var newRules []RC.Rule
	for _, prefix := range prefixSet {
		rule, err := common.NewIPCIDR(prefix.String(), AdapterName, common.WithIPCIDRNoResolve(true))
		if err != nil {
			log.Warnln("[ZeroTier] Failed to create rule for %s: %v", prefix.String(), err)
			continue
		}
		newRules = append(newRules, rule)
		log.Infoln("[ZeroTier] Injected rule: IP-CIDR,%s,%s,no-resolve", prefix.String(), AdapterName)
	}

	if len(newRules) == 0 {
		return
	}

	// Prepend rules to the existing rule chain (highest priority)
	existingRules := tunnel.Rules()
	allRules := make([]RC.Rule, 0, len(newRules)+len(existingRules))
	allRules = append(allRules, newRules...)
	allRules = append(allRules, existingRules...)
	tunnel.UpdateRules(allRules, nil, nil)
}

// removeInjectedRules removes previously injected ZeroTier rules by matching adapter name
func (m *Manager) removeInjectedRules() {
	existingRules := tunnel.Rules()
	filtered := make([]RC.Rule, 0, len(existingRules))
	for _, r := range existingRules {
		if r.Adapter() != AdapterName {
			filtered = append(filtered, r)
		}
	}
	if len(filtered) != len(existingRules) {
		tunnel.UpdateRules(filtered, nil, nil)
	}
}

// IsRunning returns whether ZeroTier is currently active
func (m *Manager) IsRunning() bool {
	m.mu.Lock()
	defer m.mu.Unlock()
	return m.running
}

// GetStatus returns the current ZeroTier status
func (m *Manager) GetStatus() ZeroTierStatus {
	m.mu.Lock()
	defer m.mu.Unlock()
	return m.buildStatus()
}

// buildStatus builds the status struct. Caller must hold m.mu.
func (m *Manager) buildStatus() ZeroTierStatus {
	status := ZeroTierStatus{
		NetworkID: m.config.NetworkID,
	}

	if !m.running || m.node == nil {
		return status
	}

	status.Online = m.node.IsOnline()
	status.NodeID = m.node.GetNodeID()

	for _, prefix := range m.node.GetAssignedAddresses() {
		status.AssignedIPs = append(status.AssignedIPs, prefix.Addr().String())
		if status.Subnet == "" {
			status.Subnet = prefix.Masked().String()
		}
	}

	for _, route := range m.node.GetRoutes() {
		status.Routes = append(status.Routes, route.String())
	}

	return status
}

// sendStatus sends a status update to Flutter via the event system. Caller must hold m.mu.
func (m *Manager) sendStatus() {
	if SendMessageFunc == nil {
		return
	}
	SendMessageFunc("ztStatus", m.buildStatus())
}

// GetStatusJSON returns the status as a JSON string
func (m *Manager) GetStatusJSON() string {
	status := m.GetStatus()
	data, err := json.Marshal(status)
	if err != nil {
		return "{}"
	}
	return string(data)
}
