#!/bin/bash
CA=`echo $SUBJECT | sed 's/%CN%/CertAuthority/'`
CLIENT=`echo $SUBJECT | sed 's/%CN%/Client/'`
SERVER=`echo $SUBJECT | sed 's/%CN%/Server/'`

mkdir -p certs private subjects/certs subjects/private
echo 01 > serial
touch index.txt

# Create CA
openssl genrsa -out private/cakey.pem 4096
openssl req -new -x509 -days 3650 -config /ca/openssl.conf -key private/cakey.pem -out certs/cacert.crt \
        -subj "${CA}"
openssl x509 -in certs/cacert.crt -out certs/cacert.pem -outform PEM

pushd subjects

#create client
openssl genrsa -out private/client.key.pem 4096
openssl req -new -key private/client.key.pem -out certs/client.csr -subj "${CLIENT}"
openssl ca -config /ca/openssl.conf -extfile /ca/openssl.client.ext.conf -days 1650 -notext -batch -in certs/client.csr -out certs/client.cert.pem

#create server
openssl genrsa -out private/server.key.pem 4096
openssl req -new -key private/server.key.pem -out certs/server.csr -subj "${SERVER}"
openssl ca -config /ca/openssl.conf -extfile /ca/openssl.server.ext.conf -days 1650 -notext -batch -in certs/server.csr -out certs/server.cert.pem

popd

mkdir dest
cp \
    certs/cacert.pem \
    private/cakey.pem \
    subjects/private/client.key.pem \
    subjects/certs/client.cert.pem \
    subjects/private/server.key.pem \
    subjects/certs/server.cert.pem \
    dest

tar zcfv key_material.tgz dest
