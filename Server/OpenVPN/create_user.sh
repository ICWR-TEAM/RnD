#!/bin/bash

EASYRSA_DIR=~/openvpn-ca

function create_client() {
    local CLIENT_NAME="$1"

    if [ ! -d "$EASYRSA_DIR/pki" ]; then
        echo "[!] Direktori PKI tidak ditemukan. Jalankan dulu setup server."
        exit 1
    fi

    cd $EASYRSA_DIR

    echo "[*] Membuat sertifikat dan kunci untuk client: $CLIENT_NAME"
    ./easyrsa gen-req "$CLIENT_NAME" nopass
    echo yes | ./easyrsa sign-req client "$CLIENT_NAME"

    mkdir -p ~/client-configs/keys
    cp pki/ca.crt pki/issued/"$CLIENT_NAME".crt pki/private/"$CLIENT_NAME".key ~/client-configs/keys/

    # Buat file .ovpn sederhana tanpa tls-auth
    cat > ~/client-configs/"$CLIENT_NAME".ovpn <<EOF
client
dev tun
proto tcp
remote $(curl -s ifconfig.me) 1337
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA256
cipher AES-256-CBC
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
EOF

    echo "[+] Client $CLIENT_NAME berhasil dibuat."
    echo "[+] File config: ~/client-configs/$CLIENT_NAME.ovpn"
}

# Cek argumen -u
while getopts ":u:" opt; do
  case $opt in
    u)
      CLIENT_NAME="$OPTARG"
      ;;
    *)
      echo "Usage: $0 -u <client_name>"
      exit 1
      ;;
  esac
done

if [ -z "$CLIENT_NAME" ]; then
    echo "Usage: $0 -u <client_name>"
    exit 1
fi

create_client "$CLIENT_NAME"
