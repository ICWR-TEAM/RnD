#!/bin/bash

# === VARIABEL ===
SERVER_IP=$(curl -s ifconfig.me)
CLIENT_NAME="client"
VPN_SUBNET="10.8.0.0"
PORT=1337
PROTO=tcp
DEV=tun
EASYRSA_DIR=~/openvpn-ca

echo "[*] Membersihkan konfigurasi OpenVPN sebelumnya..."

# === 1. Hapus konfigurasi lama ===
systemctl stop openvpn-server@server 2>/dev/null
systemctl disable openvpn-server@server 2>/dev/null
rm -rf /etc/openvpn/server/*
rm -rf ~/client-configs
rm -rf $EASYRSA_DIR
rm -f /etc/sysctl.d/99-openvpn-forward.conf
rm -f /etc/iptables.rules
rm -f /etc/systemd/system/iptables-restore.service
iptables -t nat -F

echo "[+] Pembersihan selesai."

# === 2. Install Paket ===
echo "[*] Menginstal paket yang dibutuhkan..."
apt update && apt install -y openvpn easy-rsa curl iptables

# === 3. Setup Easy-RSA ===
echo "[*] Inisialisasi Easy-RSA dan PKI..."
mkdir -p $EASYRSA_DIR
ln -s /usr/share/easy-rsa/* $EASYRSA_DIR/
cd $EASYRSA_DIR
./easyrsa init-pki
echo | ./easyrsa build-ca nopass
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server
./easyrsa gen-dh
openvpn --genkey --secret ta.key
./easyrsa gen-req $CLIENT_NAME nopass
echo yes | ./easyrsa sign-req client $CLIENT_NAME

# === 4. Copy file ke direktori OpenVPN ===
echo "[*] Menyalin sertifikat dan kunci ke /etc/openvpn/server/"
mkdir -p /etc/openvpn/server
cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem ta.key /etc/openvpn/server/

# === 5. Buat file konfigurasi server ===
echo "[*] Membuat konfigurasi server..."
cat > /etc/openvpn/server/server.conf <<EOF
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
auth SHA256
data-ciphers AES-256-GCM:AES-128-GCM:AES-256-CBC
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log-append /var/log/openvpn.log
verb 3
EOF

# === 6. Aktifkan IP Forwarding ===
echo "[*] Mengaktifkan IP forwarding..."
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-openvpn-forward.conf
sysctl --system

# === 7. NAT agar client bisa akses internet ===
echo "[*] Menyiapkan NAT routing..."
IFACE=$(ip route get 1 | awk '{print $5; exit}')
iptables -t nat -A POSTROUTING -s $VPN_SUBNET/24 -o $IFACE -j MASQUERADE
iptables-save > /etc/iptables.rules

# === 8. Simpan aturan NAT agar survive reboot ===
cat > /etc/systemd/system/iptables-restore.service <<EOF
[Unit]
Description=Restore iptables rules
Before=network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore < /etc/iptables.rules
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl enable iptables-restore

# === 9. Aktifkan dan mulai layanan OpenVPN ===
echo "[*] Mengaktifkan OpenVPN..."
systemctl enable openvpn-server@server
systemctl start openvpn-server@server

# === 10. Buat file konfigurasi client (.ovpn) ===
echo "[*] Membuat file konfigurasi client..."
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
auth SHA256
data-ciphers AES-256-GCM:AES-128-GCM:AES-256-CBC
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

# === 11. Selesai ===
echo -e "\n[✅] OpenVPN berhasil di-setup!"
echo "[🔑] File client tersedia di: ~/client-configs/$CLIENT_NAME.ovpn"
