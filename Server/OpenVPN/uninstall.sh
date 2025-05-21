#!/bin/bash

echo "[*] Stopping OpenVPN service..."
systemctl stop openvpn-server@server 2>/dev/null
systemctl disable openvpn-server@server 2>/dev/null

echo "[*] Removing OpenVPN packages..."
apt-get purge -y openvpn easy-rsa

echo "[*] Removing OpenVPN config files and keys..."
rm -rf /etc/openvpn
rm -rf ~/client-configs
rm -rf ~/openvpn-ca
rm -rf /etc/systemd/system/iptables-restore.service
rm -f /etc/sysctl.d/99-openvpn-forward.conf
rm -f /etc/iptables.rules

echo "[*] Flushing iptables rules (NAT)..."
iptables -t nat -F

echo "[*] Reloading systemctl daemon..."
systemctl daemon-reexec

echo "[*] Disabling iptables-restore service..."
systemctl disable iptables-restore 2>/dev/null

echo "[*] OpenVPN and related configuration cleaned up successfully!"
