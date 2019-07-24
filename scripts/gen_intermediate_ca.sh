#!/usr/bin/env bash
SUBJECT=$1
COMMON_NAME=$2
IDENT=$3
if [[ -z ${COMMON_NAME} || -z ${IDENT} ]]
then
    echo "Usage: gen_intermediate_ca.sh \"Common Subject\" \"Common Name\" intermediate_identifier"
    exit 1
fi

echo "Common Name: ${COMMON_NAME}"

openssl genrsa -aes256 \
      -out intermediate/private/intermediate_${IDENT}.key.pem 4096

openssl req -config intermediate/openssl.cnf -new -sha256 \
      -key intermediate/private/intermediate_${IDENT}.key.pem \
      -subj "${SUBJECT}/CN=${COMMON_NAME}" \
      -out intermediate/csr/intermediate_${IDENT}.csr.pem

openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in intermediate/csr/intermediate_${IDENT}.csr.pem \
      -out intermediate/certs/intermediate_${IDENT}.cert.pem

cat intermediate/certs/intermediate_${IDENT}.cert.pem certs/ca.cert.pem > intermediate/certs/ca_chain_${IDENT}.cert.pem

chmod 400 intermediate/private/intermediate_${IDENT}.key.pem
chmod 444 intermediate/certs/intermediate_${IDENT}.cert.pem
chmod 444 intermediate/certs/ca_chain_${IDENT}.cert.pem