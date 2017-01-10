#!/bin/bash

HOST=$1

if [ -z $HOST ] ; then
    echo "Please specify the name of the host"
    echo "./certs.sh <you_hostname_or_FQDN>"
    exit 1
fi


rm -rf certs/
mkdir -p certs/
cd certs/

# Prepare custom certs file
cp ../req.conf ./
sed -i.bak s/HOST/$HOST/g req.conf

HOSTS=$HOST,$(hostname)

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
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout controller_key.pem -out controller_cert.pem -config req.conf

# Image
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ciao-image_key.pem -out ciao-image_cert.pem -config req.conf

# Keystone
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ciao-keystone_key.pem -out ciao-keystone_cert.pem -config req.conf

cd ..
