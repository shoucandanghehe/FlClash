//go:build !android

package zerotier

import "net/netip"

// Stub implementations for non-Android platforms.
// ZeroTier integration is Android-only.

var DefaultManager = &Manager{}
var SendMessageFunc func(msgType string, data interface{})
var ProtectFdFunc func(fd int)

type ZeroTierConfig struct {
	NetworkID  string `json:"networkId"`
	PlanetData string `json:"planetData"`
	Enabled    bool   `json:"enabled"`
}

type ZeroTierStatus struct {
	Online      bool     `json:"online"`
	NodeID      string   `json:"nodeId"`
	NetworkID   string   `json:"networkId"`
	AssignedIPs []string `json:"assignedIps"`
	Routes      []string `json:"routes"`
	Subnet      string   `json:"subnet"`
}

type Manager struct{}

func (m *Manager) Start(cfg ZeroTierConfig, homeDir string) error { return nil }
func (m *Manager) Stop() error                                    { return nil }
func (m *Manager) InjectAdapter()                                 {}
func (m *Manager) InjectRules()                                   {}
func (m *Manager) IsRunning() bool                                { return false }
func (m *Manager) GetStatus() ZeroTierStatus                      { return ZeroTierStatus{} }
func (m *Manager) GetStatusJSON() string                          { return "{}" }

func ParsePlanetData(data string) ([]byte, error) { return nil, nil }

// Unused stubs to satisfy references
type Node struct{}

func (n *Node) GetAssignedAddresses() []netip.Prefix { return nil }
func (n *Node) GetRoutes() []netip.Prefix            { return nil }
