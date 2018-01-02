#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")"

folder="./out"
if [ ! -d "$folder" ]; then
    mkdir "$folder"
fi

# Generate root cert along with root key
openssl req -config ca.cnf \
    -newkey rsa:2048 -nodes -keyout out/root.key.pem \
    -new -x509 -days 7300 -out out/root.crt \
    -subj "/C=CN/ST=Guangdong/L=Guangzhou/O=Fishdrowned/CN=Fishdrowned ROOT CA"

# Generate cert key
openssl genrsa -out "out/cert.key.pem" 2048
