#!/usr/bin/env bash
BASE_DIR=`dirname "${BASH_SOURCE[0]}"`
SUBJECT=$1
CERT_TYPE=$2
INTERMEDIATE_IDENT=$3
COMMON_NAME=$4
IDENT=$5

if [[ -z ${CERT_TYPE} || -z ${INTERMEDIATE_IDENT} || -z ${COMMON_NAME} || -z ${IDENT} ]]
then
    echo "Usage: gen_cert.sh intermediate_identifier \"Common Name\" identifier"
    exit 1
fi

openssl genrsa \
    -out intermediate/private/${IDENT}.key.pem 2048

openssl req \
    -config intermediate/openssl.cnf \
    -key intermediate/private/${IDENT}.key.pem \
    -subj "${SUBJECT}/CN=${COMMON_NAME}" \
    -addext "subjectAltName = DNS:${COMMON_NAME}" \
    -new -sha256 -out intermediate/csr/${IDENT}.csr.pem

openssl ca -config intermediate/openssl.cnf \
    -extensions ${CERT_TYPE}_cert -days 750 -notext -md sha256 \
    -keyfile intermediate/private/intermediate_${INTERMEDIATE_IDENT}.key.pem \
    -cert intermediate/certs/intermediate_${INTERMEDIATE_IDENT}.cert.pem \
    -in intermediate/csr/${IDENT}.csr.pem \
    -out intermediate/certs/${IDENT}.cert.pem

chmod 400 intermediate/private/${IDENT}.key.pem
chmod 444 intermediate/certs/${IDENT}.cert.pem

cat intermediate/certs/${IDENT}.cert.pem \
    intermediate/certs/ca_chain_${INTERMEDIATE_IDENT}.cert.pem \
    > distribute/${IDENT}.cert_chain.pem

${BASE_DIR}/convert_pkcs8.sh intermediate/private/${IDENT}.key.pem \
    > distribute/${IDENT}.key.pem