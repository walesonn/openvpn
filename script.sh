#!/bin/bash

# DIR="$HOME/EasyRSA-3.0.8"
# LOCAL="/usr/local/etc/easy-rsa"

# if [ -d "$DIR" ]; then
#     echo "clean..."
#     rm -rf "$DIR"
# fi

# if [ -d "$LOCAL" ]; then
#     rm -rf "$LOCAL"
# fi

# cd /tmp \

# wget wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz \

# tar -xvf /tmp/EasyRSA-3.0.8.tgz \

# mv EasyRSA-3.0.8 ~/ \

# rm /tmp/EasyRSA* \

# echo "all configs lives here $LOCAL" \
# sleep 5 \
# mkdir -p "$LOCAL" \

# read -p "country Ex[BR]:" COUNTRY
# COUNTRY=${COUNTRY:-BR}
# read -p "province Ex[Minas Gerais]:" PROVINCE
# PROVINCE=${PROVINCE:-Minas Gerais}
# read -p "city: Ex[Piedade de Caratinga]" CITY
# CITY=${CITY:-Piedade de Caratinga}
# read -p "organization Ex[balaco]" ORG
# ORG=${ORG:-balaco}
# read -p "email [admin@localhost.com]:" EMAIL
# EMAIL=${EMAIL:-admin@localhost.com}
# read -p "organization social name Ex[balaco Inc.]" OU
# OU=${OU:-balaco Inc.}

# echo "set_var EASYRSA_PKI        \"$LOCAL\""      >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_COUNTRY \"$COUNTRY\""   >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_PROVINCE \"$PROVINCE\"" >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_CITY      \"$CITY\""    >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_ORG        \"$ORG\""    >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_EMAIL       \"$EMAIL\"" >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_OU           \"$OU\""   >> ~/EasyRSA-3.0.8/vars

# bash ~/EasyRSA-3.0.8/easyrsa init-pki \

# bash ~/EasyRSA-3.0.8/easyrsa build-ca \

# openssl x509 -in "$LOCAL/ca.crt" -text -noout \

# bash ~/EasyRSA-3.0.8/easyrsa gen-crl \

# openssl crl -noout -text -in "$LOCAL/crl.pem" \

# bash ~/EasyRSA-3.0.8/easyrsa build-server-full movpn-server \

# openssl x509 -noout -text -in "$LOCAL/issued/movpn-server.crt" \

# read -p "Name client [client1]:" CLIENT
# CLIENT=${CLIENT:-client1}

# bash ~/EasyRSA-3.0.8/easyrsa build-client-full "$CLIENT" \

# openssl x509 -noout -text -in "$LOCAL/issued/$CLIENT.crt" \

# mkdir -p /etc/openvpn/movpn \

# chmod 700 /etc/openvpn/movpn \

# mkdir ~/ssl-admin \

ip=$(curl icanhazip.com)
gateway="$(curl icanhazip.com | cut -d "." -f 1,2,3).0"
DIR=~/openvpn/ssl-admin
PATH_SSL_ADMIN="/etc/ssl-admin"
PATH_CONFIG="/etc/ssl-admin/ssl-admin.conf"
PATH_MOVPN="/etc/openvpn/movpn"
SERVER_CONF=~/openvpn/basic-udp-server.conf

if [[ -d "$DIR" ]]
then
    useradd "ovpn" -p "Alfa@ovpn3221"
    groupadd "nobody"

    echo 1 > /proc/sys/net/ipv4/ip_forward
    result=$(cat basic-udp-server.conf | grep "push")
    
    if [[ -z "$result" ]]
    then
        echo "push \"route $gateway 255.255.255.0\"" >> "$SERVER_CONF"
    fi

    iptables -t nat -A POSTROUTING -d "137.184.86.0/24" -s "10.0.0.0/24" -j ACCEPT
    iptables -t nat -A POSTROUTING -s "10.0.0.0/24" -o eth0 -j MASQUERADE
    
    ssl-admin 

    mkdir -p "$PATH_MOVPN"
    chmod 700 "$PATH_MOVPN"
    cp -a "$PATH_SSL_ADMIN/active/ca.crt" "$PATH_MOVPN/movpn-ca.crt"
    cp -a "$PATH_SSL_ADMIN/active/server.crt" "$PATH_MOVPN/movpn-server.crt"
    cp -a "$PATH_SSL_ADMIN/active/server.key" "$PATH_MOVPN/movpn-server.key"

    interface=$(ifconfig | grep "tun0")
    openvpn_running=$(netstat -ntplu | grep "openvpn")

    if [[ -n $interface ]]
    then    
        ifconfig tun0 down
    fi

    if [[ -n $openvpn_running ]]
    then
        killall openvpn
    fi

    if [[ ! -f "$PATH_MOVPN/dh2048.pem" ]]
    then
        cd "$PATH_MOVPN" && openssl dhparam -out dh2048.pem 2048
    fi

    if [[ ! -f "$PATH_MOVPN/ta.key" ]]
    then
        openvpn --genkey --secret "$PATH_MOVPN/ta.key"
    fi
   
    openvpn --config "$SERVER_CONF" --askpass

    # ip route add 10.200.0.0/24 via 192.168.122.1
    read -p "client [crt] name:" client
    
    echo "client"                               > ~/openvpn/client.conf
    echo "proto udp"                            >> ~/openvpn/client.conf
    echo "remote $ip"                           >> ~/openvpn/client.conf
    echo "port 1194"                            >> ~/openvpn/client.conf
    echo "dev tun"                              >> ~/openvpn/client.conf
    echo "nobind"                               >> ~/openvpn/client.conf
    #echo "remote-cert-tls server"               >> ~/openvpn/client.conf
    #echo "tls-auth /etc/openvpn/movpn/ta.key 1" >> ~/openvpn/client.conf
    echo "ca   /etc/openvpn/movpn/movpn-ca.crt" >> ~/openvpn/client.conf
    echo "cert /etc/openvpn/movpn/$client.crt"  >> ~/openvpn/client.conf
    echo "key  /etc/openvpn/movpn/$client.key"  >> ~/openvpn/client.conf

    echo "client"                               > ~/openvpn/client.ovpn
    echo "proto udp"                            >> ~/openvpn/client.ovpn
    echo "remote $ip"                           >> ~/openvpn/client.ovpn
    echo "port 1194"                            >> ~/openvpn/client.ovpn
    echo "dev tun"                              >> ~/openvpn/client.ovpn
    echo "nobind"                               >> ~/openvpn/client.ovpn
    echo "remote-cert-tls server"               >> ~/openvpn/client.ovpn
    echo "tls-auth /etc/openvpn/movpn/ta.key 1" >> ~/openvpn/client.ovpn
    echo "ca   /etc/openvpn/movpn/movpn-ca.crt" >> ~/openvpn/client.ovpn
    echo "cert /etc/openvpn/movpn/$client.crt"  >> ~/openvpn/client.ovpn
    echo "key  /etc/openvpn/movpn/$client.key"  >> ~/openvpn/client.ovpn

else

    if [[ -f "$PATH_CONFIG" ]]
    then
        rm "$PATH_CONFIG"
    fi
   
    echo "Initializing..."
    apt update -y && apt upgrade -y && apt install git -y && apt install make -y && apt install openvpn -y && apt install net-tools -y
    git clone https://github.com/shadowbq/ssl-admin.git
    chmod +x "$DIR/configure"
    cd "$DIR" && ./configure
    cd "$DIR" && make install

    echo "\$ENV{'KEY_SIZE'} = \"1024\";"                   > "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_DAYS'} = \"3650\";"                   >> "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_CN'} = \"\";"                         >> "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_CRL_LOC'} = \"URI:http://CRL_URI\";"  >> "$PATH_SSL_ADMIN/ssl-admin.conf"

    echo "\$ENV{'KEY_COUNTRY'} = \"BR\";"                  >> "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_PROVINCE'} = \"Minas gerais\";"       >> "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_CITY'} = \"Caratinga\";"              >> "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_ORG'} = \"You have a big problem\";"  >> "$PATH_SSL_ADMIN/ssl-admin.conf"
    echo "\$ENV{'KEY_EMAIL'} = \"sranonymouss@gmail.com\";">> "$PATH_SSL_ADMIN/ssl-admin.conf"
fi

#first menu S option
#after says y option to all others prompts
#option 4 for sign cert for clients