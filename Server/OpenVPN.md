# Automatic Install & Create Client Config

```bash
#!/bin/bash

# === VARIABEL KONFIGURASI ===
SERVER_IP=$(curl -s ifconfig.me)
CLIENT_NAME="client"
VPN_SUBNET="10.8.0.0"
PORT=1194
PROTO=udp
DEV=tun

# === 1. Install OpenVPN & Easy-RSA ===
apt update && apt install openvpn easy-rsa -y

# === 2. Setup Easy-RSA ===
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
./easyrsa init-pki
echo | ./easyrsa build-ca nopass
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server
./easyrsa gen-dh
openvpn --genkey --secret ta.key
./easyrsa gen-req $CLIENT_NAME nopass
echo yes | ./easyrsa sign-req client $CLIENT_NAME

# === 3. Copy file ke /etc/openvpn ===
cp pki/ca.crt pki/private/server.key pki/issued/server.crt \
   pki/dh.pem ta.key /etc/openvpn/

# === 4. Buat config server ===
cat > /etc/openvpn/server.conf <<EOF
port $PORT
proto $PROTO
dev $DEV
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server $VPN_SUBNET 255.255.255.0
ifconfig-pool-persist ipp.txt
keepalive 10 120
tls-auth ta.key 0
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF

# === 5. Aktifkan IP Forwarding ===
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

# === 6. Setup Firewall ===
ufw allow $PORT/$PROTO
ufw allow OpenSSH
sed -i '/^DEFAULT_FORWARD_POLICY=/c\DEFAULT_FORWARD_POLICY="ACCEPT"' /etc/default/ufw
cat > /etc/ufw/before.rules <<EOF
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s $VPN_SUBNET/24 -o eth0 -j MASQUERADE
COMMIT
EOF
ufw disable && ufw enable

# === 7. Aktifkan OpenVPN ===
systemctl enable openvpn@server
systemctl start openvpn@server

# === 8. Buat file .ovpn untuk client ===
mkdir -p ~/client-configs/keys
cp pki/ca.crt pki/issued/$CLIENT_NAME.crt pki/private/$CLIENT_NAME.key ta.key ~/client-configs/keys/

cat > ~/client-configs/$CLIENT_NAME.ovpn <<EOF
client
dev $DEV
proto $PROTO
remote $SERVER_IP $PORT
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
key-direction 1
verb 3

<ca>
$(cat ~/client-configs/keys/ca.crt)
</ca>

<cert>
$(cat ~/client-configs/keys/$CLIENT_NAME.crt)
</cert>

<key>
$(cat ~/client-configs/keys/$CLIENT_NAME.key)
</key>

<tls-auth>
$(cat ~/client-configs/keys/ta.key)
</tls-auth>
EOF

echo -e "\n✅ Selesai! File client: ~/client-configs/$CLIENT_NAME.ovpn"

```
