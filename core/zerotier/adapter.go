//go:build android && cgo

package zerotier

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/component/dialer"
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
			Name:   AdapterName,
			Type:   constant.Direct, // Use Direct type as base
			UDP:    true,
		}),
		node: node,
	}
}

// DialContext connects to the target through the ZeroTier network
func (z *ZeroTierAdapter) DialContext(ctx context.Context, metadata *constant.Metadata, opts ...dialer.Option) (constant.Conn, error) {
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

// ListenPacketContext creates a UDP connection through the ZeroTier network
func (z *ZeroTierAdapter) ListenPacketContext(ctx context.Context, metadata *constant.Metadata, opts ...dialer.Option) (constant.PacketConn, error) {
	address := metadata.UDPAddr().String()

	pc, err := z.node.DialUDP(ctx, address)
	if err != nil {
		return nil, fmt.Errorf("zerotier UDP %s: %w", address, err)
	}

	return outbound.NewPacketConn(pc, z), nil
}

// SupportUDP returns true as ZeroTier supports UDP
func (z *ZeroTierAdapter) SupportUDP() bool {
	return true
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
