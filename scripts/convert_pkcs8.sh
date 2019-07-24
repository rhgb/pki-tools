#!/usr/bin/env bash
PEM_FILE=$1

if [[ -z ${PEM_FILE} ]]; then
    echo "Please provide key filename"
    exit 1
fi

openssl pkcs8 -topk8 -in ${PEM_FILE} -outform PEM -nocrypt