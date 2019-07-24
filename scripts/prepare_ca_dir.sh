#!/usr/bin/env bash
BASE_DIR=`dirname "${BASH_SOURCE[0]}"`

if [[ -d ca ]]; then
    echo "directory \"ca\" exists. exiting."
    exit 1
fi

mkdir -p \
    ca/distribute \
    ca/certs \
    ca/crl \
    ca/newcerts \
    ca/private \
    ca/intermediate/certs \
    ca/intermediate/crl \
    ca/intermediate/csr \
    ca/intermediate/newcerts \
    ca/intermediate/private

touch ca/index.txt
echo 1000 > ca/serial

touch ca/intermediate/index.txt
echo 1000 > ca/intermediate/serial

cp ${BASE_DIR}/../conf/ca_openssl.cnf ca/openssl.cnf
cp ${BASE_DIR}/../conf/intermediate_openssl.cnf ca/intermediate/openssl.cnf