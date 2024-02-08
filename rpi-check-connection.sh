interface="eth0"

if ! ip addr show dev "$interface" | grep -q "inet "; then
    ip link set "$interface" down
    ip link set "$interface" up
fi

