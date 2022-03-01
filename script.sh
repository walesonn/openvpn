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

DIR=~/openvpn/ssl-admin
PATH_SSL_ADMIN="/etc/ssl-admin"
PATH_CONFIG="/etc/ssl-admin/ssl-admin.conf"
PATH_MOVPN="/etc/openvpn/movpn"
SERVER_CONF=~/openvpn/movpn-04-01-server.conf

if [[ -d "$DIR" ]]
then
    # rm -rf "$DIR"
    
    ssl-admin 
    mkdir -p "$PATH_MOVPN"
    chmod 700 "$PATH_MOVPN"
    cp -a "$PATH_SSL_ADMIN/active/ca.crt" "$PATH_MOVPN/movpn-ca.crt"
    cp -a "$PATH_SSL_ADMIN/active/server.crt" "$PATH_MOVPN/movpn-server.crt"
    cp -a "$PATH_SSL_ADMIN/active/server.key" "$PATH_MOVPN/movpn-server.key"
    cd "$PATH_MOVPN" && openssl dhparam -out dh2048.pem 2048
    cat "$SERVER_CONF" | openvpn --config

else

    if [[ -f "$PATH_CONFIG" ]]
    then
        rm "$PATH_CONFIG"
    fi
   
    echo "Initializing..."
    apt update -y && apt upgrade -y && apt install git -y && apt install make -y && apt install openvpn -y
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