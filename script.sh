#!/bin/bash

DIR="$HOME/EasyRSA-3.0.8"
LOCAL="/usr/local/etc/easy-rsa"

echo "apagando $DIR ..."
sleep 5

if [ -d "$DIR" ]; then
    echo "clean..."
    rm -rf "$DIR"
fi

if [ -d "$LOCAL" ]; then
    rm -rf "$LOCAL"
fi

cd /tmp \

wget wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz \

tar -xvf /tmp/EasyRSA-3.0.8.tgz \

mv EasyRSA-3.0.8 ~/ \

rm /tmp/EasyRSA* \

echo "$LOCAL" \
mkdir -p "$LOCAL" \

read -p "country Ex[BR]:" COUNTRY
COUNTRY=${COUNTRY:-BR}
read -p "province Ex[Minas Gerais]:" PROVINCE
PROVINCE=${PROVINCE:-Minas Gerais}
read -p "city: Ex[Piedade de Caratinga]" CITY
CITY=${CITY:-Piedade de Caratinga}
read -p "organization Ex[balaco]" ORG
ORG=${ORG:-balaco}
read -p "email [admin@localhost.com]:" EMAIL
EMAIL=${EMAIL:-admin@localhost.com}
read -p "organization social name Ex[balaco Inc.]" OU
OU=${OU:-balaco Inc.}

# echo "set_var EASYRSA_PKI        \"$LOCAL\""      >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_COUNTRY \"$COUNTRY\""   >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_PROVINCE \"$PROVINCE\"" >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_CITY      \"$CITY\""    >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_ORG        \"$ORG\""    >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_EMAIL       \"$EMAIL\"" >> ~/EasyRSA-3.0.8/vars
# echo "set_var EASYRSA_REQ_OU           \"$OU\""   >> ~/EasyRSA-3.0.8/vars
# echo "PKCS11_MODULE_PATH=\"dummy\""               >> ~/EasyRSA-3.0.8/vars
# echo "PKCS11_PIN=\"dummy\""                       >> ~/EasyRSA-3.0.8/vars

echo "export EASY_RSA=/etc/openvpn/cookbook"                    >> ~/EasyRSA-3.0.8/vars
echo "export OPENSSL=\"openssl\""                               >> ~/EasyRSA-3.0.8/vars
echo "export PKCS11TOOL=\"pkcs11-tool\""                        >> ~/EasyRSA-3.0.8/vars
echo "export GREP=\"grep\""                                     >> ~/EasyRSA-3.0.8/vars
echo "export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`"  >> ~/EasyRSA-3.0.8/vars
echo "export KEY_DIR=\"$EASY_RSA/keys\""                        >> ~/EasyRSA-3.0.8/vars
echo "export PKCS11_MODULE_PATH=\"dummy\""                      >> ~/EasyRSA-3.0.8/vars
echo "export PKCS11_PIN=\"dummy\""                              >> ~/EasyRSA-3.0.8/vars
echo "export KEY_SIZE=2048"                                     >> ~/EasyRSA-3.0.8/vars
echo "export CA_EXPIRE=3650"                                    >> ~/EasyRSA-3.0.8/vars
echo "export KEY_EXPIRE=1000"                                   >> ~/EasyRSA-3.0.8/vars
echo "export KEY_COUNTRY=\"EUA\""                               >> ~/EasyRSA-3.0.8/vars
echo "export KEY_PROVINCE="                                     >> ~/EasyRSA-3.0.8/vars
echo "export KEY_CITY="                                         >> ~/EasyRSA-3.0.8/vars
echo "export KEY_ORG=\"big Z\""                                 >> ~/EasyRSA-3.0.8/vars
echo "export KEY_OU="                                           >> ~/EasyRSA-3.0.8/vars
echo "export KEY_CN="                                           >> ~/EasyRSA-3.0.8/vars
echo "export KEY_EMAIL=\"openvpn@example.com\""                 >> ~/EasyRSA-3.0.8/vars \

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

# openssl x509 -noout -text -in "$LOCAL/issued/$CLIENT.crt" 