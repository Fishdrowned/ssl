#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo
    echo 'Issue a wildcard SSL certification with Fishdrowned ROOT CA'
    echo
    echo 'Usage: ./gen.cert.sh <domain> [<domain2>] [<domain3>] [<domain4>] ...'
    echo '    <domain>          The domain name of your site, like "example.dev",'
    echo '                      you will get a certification for *.example.dev'
    echo '                      Multiple domains are acceptable'
    exit;
fi

SAN=""
for var in "$@"
do
    SAN+="DNS:*.${var},DNS:${var},"
done
SAN=${SAN: : -1}

# Move to root directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# Create domain directory
DIR="out/$1-`date +%Y%m%d-%H%M`"
mkdir ${DIR}

# Create CSR
openssl req -new -out "${DIR}/$1.csr.pem" \
    -key out/root.key.pem \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "[SAN]\nsubjectAltName=${SAN}")) \
    -subj "/C=CN/ST=Guangdong/L=Guangzhou/O=Fishdrowned/OU=$1/CN=*.$1"

# Issue certification
# openssl ca -batch -config ./ca.cnf -notext -in "${DIR}/$1.csr.pem" -out "${DIR}/$1.cert.pem"
openssl ca -config ./ca.cnf -in "${DIR}/$1.csr.pem" -out "${DIR}/$1.cert.pem" -cert ./out/root.cert.pem -keyfile ./out/root.key.pem

# Chain certification with CA
cat "${DIR}/$1.cert.pem" ./out/root.cert.pem > "${DIR}/$1.bundle.cert.pem"

# Output certifications
echo
echo "Certifications are located in:"
find "${DIR}/" -type f
