#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo 'Please specify a domain name'
    exit;
fi

cd "$(dirname "${BASH_SOURCE[0]}")"
DIR="out/$1-`date +%Y%m%d-%H%M`"
mkdir ${DIR}

openssl req -new -out "${DIR}/$1.csr.pem" \
    -key out/root.key.pem \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "[SAN]\nsubjectAltName=DNS:*.$1,DNS:$1")) \
    -subj "/C=CN/ST=Guangdong/L=Guangzhou/O=Fishdrowned/OU=$1/CN=*.$1"

# openssl ca -batch -config ./ca.cnf -notext -in "${DIR}/$1.csr.pem" -out "${DIR}/$1.cert.pem"
openssl ca -config ./ca.cnf -in "${DIR}/$1.csr.pem" -out "${DIR}/$1.cert.pem" -cert ./out/root.cert.pem -keyfile ./out/root.key.pem

if [ "$2" ]
then
    $2 "${DIR}/$1"
fi
