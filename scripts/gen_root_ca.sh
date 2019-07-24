#!/usr/bin/env bash
SUBJECT=$1
COMMON_NAME=$2

openssl genrsa -aes256 -out private/ca.key.pem 4096
openssl req -config openssl.cnf \
      -key private/ca.key.pem \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -subj "${SUBJECT}/CN=${COMMON_NAME}" \
      -out certs/ca.cert.pem
chmod 400 private/ca.key.pem
chmod 444 certs/ca.cert.pem
cp certs/ca.cert.pem distribute/ca.cert.pem