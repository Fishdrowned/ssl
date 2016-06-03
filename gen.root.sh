#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")"

openssl req -newkey rsa:2048 -days 7300 -x509 -nodes -keyout out/root.key.pem -out out/root.cert.pem \
    -subj "/C=CN/ST=Guangdong/L=Guangzhou/O=Fishdrowned/CN=Fishdrowned ROOT CA"
