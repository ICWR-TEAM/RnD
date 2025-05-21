#!/bin/bash

# === PARSING ARGUMEN ===
while getopts ":u:" opt; do
  case $opt in
    u)
      CLIENT_NAME=$OPTARG
      ;;
    \?)
      echo "Opsi tidak dikenal: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Opsi -$OPTARG membutuhkan argumen." >&2
      exit 1
      ;;
  esac
done

if [ -z "$CLIENT_NAME" ]; then
    echo "Usage: $0 -u <client_name>"
    exit 1
fi

# === CEK DIREKTORI ===
cd ~/openvpn-ca || { echo "Folder ~/openvpn-ca tidak ditemukan!"; exit 1; }

# === Generate Certificate untuk Client ===
./easyrsa gen-req $CLIENT_NAME nopass
echo yes | ./easyrsa sign-req client $CLIENT_NAME

# === Copy file ke direktori client-configs ===
mkdir -p ~/client-configs/keys
cp pki/issued/$CLIENT_NAME.crt pki/private/$CLIENT_NAME.key ~/client-configs/keys/

# === Buat file .ovpn untuk client ===
cat > ~/client-configs/$CLIENT_NAME.ovpn <<EOF
client
dev tun
proto tcp
remote $(curl -s ifconfig.me) 1337
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

echo -e "\n[+] User '$CLIENT_NAME' berhasil dibuat!"
echo "[+] File tersedia di: ~/client-configs/$CLIENT_NAME.ovpn"
