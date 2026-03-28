//go:build android && cgo

package zerotier

// ZeroTierConfig holds the configuration for ZeroTier integration
type ZeroTierConfig struct {
	Enabled    bool   `json:"enabled"`
	NetworkID  string `json:"networkId"`
	PlanetData string `json:"planetData"` // base64 encoded custom planet file
}

// ZeroTierStatus represents the current state of the ZeroTier node
type ZeroTierStatus struct {
	Online      bool     `json:"online"`
	NodeID      string   `json:"nodeId"`
	NetworkID   string   `json:"networkId"`
	AssignedIPs []string `json:"assignedIps"`
	Routes      []string `json:"routes"`
	Subnet      string   `json:"subnet"`
}
