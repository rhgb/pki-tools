#!/usr/bin/env bash

KEY_FILE=$1
CERT_FILE=$2
OUTPUT_NAME=$3

if [[ -z ${KEY_FILE} || -z ${CERT_FILE} || -z ${OUTPUT_NAME} ]]
then
    echo "Usage: package_pkcs12.sh [key_file] [cert_file] [output_name]"
    exit 1
fi

openssl pkcs12 \
    -inkey ${KEY_FILE} \
    -in ${CERT_FILE} \
    -export \
    -out ${OUTPUT_NAME}