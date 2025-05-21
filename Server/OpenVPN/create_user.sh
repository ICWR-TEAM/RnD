#!/bin/bash

# === Konfigurasi ===
CLIENT_NAME="$1"
if [ -z "$CLIENT_NAME" ]; then
    echo "Usage: $0 <nama_client>"
    exit 1
fi

EASYRSA_DIR=~/openvpn-ca
CLIENT_CONFIG_DIR=~/client-configs
SERVER_IP=$(curl -s ifconfig.me)
PORT=1194
PROTO=udp
DEV=tun

# === 1. Masuk ke direktori Easy-RSA ===
cd $EASYRSA_DIR || { echo "Easy-RSA directory not found!"; exit 1; }

# === 2. Generate key dan CSR untuk client ===
./easyrsa gen-req $CLIENT_NAME nopass

# === 3. Sign request dengan CA ===
echo yes | ./easyrsa sign-req client $CLIENT_NAME

# === 4. Salin file yang diperlukan ===
mkdir -p $CLIENT_CONFIG_DIR/keys
cp pki/ca.crt pki/issued/$CLIENT_NAME.crt pki/private/$CLIENT_NAME.key ta.key $CLIENT_CONFIG_DIR/keys/

# === 5. Buat file .ovpn untuk client ===
cat > $CLIENT_CONFIG_DIR/$CLIENT_NAME.ovpn <<EOF
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
$(cat $CLIENT_CONFIG_DIR/keys/ca.crt)
</ca>

<cert>
$(cat $CLIENT_CONFIG_DIR/keys/$CLIENT_NAME.crt)
</cert>

<key>
$(cat $CLIENT_CONFIG_DIR/keys/$CLIENT_NAME.key)
</key>

<tls-auth>
$(cat $CLIENT_CONFIG_DIR/keys/ta.key)
</tls-auth>
EOF

echo -e "\n[+] Client baru '$CLIENT_NAME' berhasil dibuat!"
echo "[+] File .ovpn ada di: $CLIENT_CONFIG_DIR/$CLIENT_NAME.ovpn"
