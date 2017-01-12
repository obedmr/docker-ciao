#!/bin/bash

HOST=$1

if [ -z $HOST ] ; then
    echo "Please specify the name of the host"
    echo "./certs.sh <you_hostname_or_FQDN>"
    exit 1
fi

HOSTS=$HOST,$(hostname)
rm -rf certs/
mkdir -p certs/
cd certs/

# Scheduler
$GOPATH/bin/ciao-cert -anchor -role scheduler -email=ciao-dev@example.com -organization=Ciao -ip=192.168.0.1 -host=$HOSTS -verify

# Compute,Network
$GOPATH/bin/ciao-cert -role agent,netagent -anchor-cert cert-Scheduler-$HOST.pem -email=ciao-dev@example.com -organization=Ciao -host=$HOSTS -ip=192.168.0.1 -verify

# Networking
$GOPATH/bin/ciao-cert -role netagent -anchor-cert cert-Scheduler-$HOST.pem -email=ciao-dev@example.com -organization=Ciao -host=$HOSTS -ip=192.168.0.1 -verify

# CNCI Agent
$GOPATH/bin/ciao-cert -role cnciagent -anchor-cert cert-Scheduler-$HOST.pem -email=ciao-dev@example.com -organization=Ciao -host=$HOSTS -ip=192.168.0.1 -verify

# Controller
$GOPATH/bin/ciao-cert -role controller -anchor-cert cert-Scheduler-$HOST.pem -email=ciao-dev@example.com -organization=Ciao -host=$HOSTS -ip=192.168.0.1 -verify
mkdir -p tmp/
cd tmp/
$GOPATH/bin/ciao-cert -anchor -role server -email=ciao-dev@example.com -organization=Ciao -ip=192.168.0.1 -host=$HOSTS -verify
mv CAcert-$HOST.pem ../controller_cert.pem
mv cert-Server-$HOST.pem   ../controller_key.pem

# Image
$GOPATH/bin/ciao-cert -anchor -role server -email=ciao-dev@example.com -organization=Ciao -ip=192.168.0.1 -host=$HOSTS -verify
mv CAcert-$HOST.pem ../ciao-image_cert.pem
mv cert-Server-$HOST.pem   ../ciao-image_key.pem

# Keystone
$GOPATH/bin/ciao-cert -anchor -role server -email=ciao-dev@example.com -organization=Ciao -ip=192.168.0.1 -host=$HOSTS -verify
mv CAcert-$HOST.pem ../ciao-keystone_cert.pem
mv cert-Server-$HOST.pem   ../ciao-keystone_key.pem

# WebUI
$GOPATH/bin/ciao-cert -anchor -role server -email=ciao-dev@example.com -organization=Ciao -ip=192.168.0.1 -host=$HOSTS -verify
mv CAcert-$HOST.pem ../ciao-webui_cert.pem
mv cert-Server-$HOST.pem   ../ciao-webui_key.pem

cd ..
rm -rf tmp/

cd ..
