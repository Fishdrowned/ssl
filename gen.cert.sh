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

if [ ! -d "./out/newcerts" ]; then
    mkdir -p "./out/newcerts"
fi

if [ ! -f "./out/index.txt" ]; then
    touch "./out/index.txt"
fi

if [ ! -f "./out/serial" ]; then
    touch "./out/serial"
    echo 1000 > ./out/serial
fi
SAN=""
for var in "$@"
do
    SAN+="DNS:*.${var},DNS:${var},"
done
SAN=${SAN:0:${#SAN}-1}

# Move to root directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# Create domain directory
BASE_DIR="out/$1"
TIME=`date +%Y%m%d-%H%M`
DIR="${BASE_DIR}/${TIME}"
mkdir -p ${DIR}

# Create CSR
openssl req -new -out "${DIR}/$1.csr.pem" \
    -key out/cert.key.pem \
    -reqexts SAN \
    -config <(cat ca.cnf \
        <(printf "[SAN]\nsubjectAltName=${SAN}")) \
    -subj "/C=CN/ST=Guangdong/L=Guangzhou/O=Fishdrowned/OU=$1/CN=*.$1"

# Issue certification
# openssl ca -batch -config ./ca.cnf -notext -in "${DIR}/$1.csr.pem" -out "${DIR}/$1.cert.pem"
openssl ca -config ./ca.cnf -batch -notext \
    -in "${DIR}/$1.csr.pem" \
    -out "${DIR}/$1.crt" \
    -cert ./out/root.crt \
    -keyfile ./out/root.key.pem

# Chain certification with CA
cat "${DIR}/$1.crt" ./out/root.crt > "${DIR}/$1.bundle.crt"
ln -snf "./${TIME}/$1.bundle.crt" "${BASE_DIR}/$1.bundle.crt"
ln -snf "./${TIME}/$1.crt" "${BASE_DIR}/$1.crt"
ln -snf "../cert.key.pem" "${BASE_DIR}/$1.key.pem"

# Output certifications
echo
echo "Certifications are located in:"
ls -la `pwd`/${BASE_DIR}/*.*
