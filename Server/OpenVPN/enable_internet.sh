#!/bin/bash

WAN_IFACE=$(ip route | awk '/default/ {print $5}' | head -n1)
VPN_SUBNET="10.8.0.0/24"

if [ -z "$WAN_IFACE" ]; then
  echo "[-] Gagal mendeteksi interface internet default."
  exit 1
fi

echo "[*] Interface internet default terdeteksi: $WAN_IFACE"

echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/^#*net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

iptables -t nat -C POSTROUTING -s $VPN_SUBNET -o $WAN_IFACE -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s $VPN_SUBNET -o $WAN_IFACE -j MASQUERADE

apt install -y iptables-persistent
netfilter-persistent save

echo "[+] Internet routing via VPN is now enabled via $WAN_IFACE!"
