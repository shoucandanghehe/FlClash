//go:build android && cgo

package zerotier

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/constant"
)

const AdapterName = "ZeroTier"

// ZeroTierAdapter implements constant.ProxyAdapter for routing traffic through ZeroTier
type ZeroTierAdapter struct {
	*outbound.Base
	node *Node
}

// NewAdapter creates a new ZeroTier outbound adapter
func NewAdapter(node *Node) *ZeroTierAdapter {
	return &ZeroTierAdapter{
		Base: outbound.NewBase(outbound.BaseOption{
			Name: AdapterName,
			Type: constant.Direct, // Use Direct type as base
			UDP:  false,           // UDP not supported via libzt BSD sockets for now
		}),
		node: node,
	}
}

// DialContext connects to the target through the ZeroTier network
func (z *ZeroTierAdapter) DialContext(ctx context.Context, metadata *constant.Metadata) (constant.Conn, error) {
	address := metadata.RemoteAddress()
	if address == "" {
		return nil, fmt.Errorf("empty remote address")
	}

	conn, err := z.node.DialTCP(ctx, address)
	if err != nil {
		return nil, fmt.Errorf("zerotier dial %s: %w", address, err)
	}

	return outbound.NewConn(conn, z), nil
}

// SupportUDP returns false - UDP via libzt BSD sockets is not yet supported
func (z *ZeroTierAdapter) SupportUDP() bool {
	return false
}

// MarshalJSON implements json.Marshaler
func (z *ZeroTierAdapter) MarshalJSON() ([]byte, error) {
	return json.Marshal(map[string]interface{}{
		"type": z.Type().String(),
		"name": z.Name(),
		"udp":  z.SupportUDP(),
	})
}

// Unwrap returns nil as ZeroTier is a leaf adapter
func (z *ZeroTierAdapter) Unwrap(metadata *constant.Metadata, touch bool) constant.Proxy {
	return nil
}
