#!/usr/bin/env bash
set -ex

KEY_FILE=$1
CERT_FILE=$2
CA_FILE=$3
OUTPUT_FILE=$4

keytool=/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/bin/keytool
tmpfile=$(mktemp /tmp/owopki.XXXXXX)

package_pkcs12.sh ${KEY_FILE} ${CERT_FILE} ${tmpfile}

${keytool} -importkeystore -srckeystore ${tmpfile} -srcstoretype pkcs12 \
    -destkeystore ${OUTPUT_FILE} -deststoretype bks \
    -provider org.bouncycastle.jce.provider.BouncyCastleProvider -providerpath bcprov-jdk15on-160.jar

rm ${tmpfile}

${keytool} -storetype BKS -providerpath bcprov-jdk15on-160.jar \
 -providerclass org.bouncycastle.jce.provider.BouncyCastleProvider \
 -importcert -trustcacerts -keystore ${OUTPUT_FILE} -file ${CA_FILE}
