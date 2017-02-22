#!/bin/bash

# Ceph
echo Setting Ceph permissions
ceph auth get-or-create client.ciao -o /etc/ceph/ceph.client.ciao.keyring mon 'allow *' osd 'allow *' mds 'allow'

# Create demorc file
cp /root/ciaorc /root/demorc
sed -i s/admin/demo/g /root/demorc
sed -i s/secret/demo/g /root/demorc

source /root/ciaorc

# Add default images
echo Adding default images
cd /share/images/

# CNCI Image
echo CNCI Image
ciao-cli image add --file clear-*networking* --name "ciao CNCI image" --id 4e16e743-265a-4bf2-9fd1-57ada0b28904

# ClearLinux
echo ClearLinux image
ciao-cli image add --file clear-*-cloud.img --name "Clear Linux"

# Fedora 24
echo Fedora image
ciao-cli image add --file Fedora-Cloud-Base-24-1.2.x86_64.qcow2 --name "Fedora 24"

# Ubuntu Trusty
echo Ubuntu image
ciao-cli image add --file trusty-server-cloudimg-amd64-disk1.img --name "Ubuntu Trusty"

# Workloads
echo Creating Workloads
/usr/bin/workloads.sh
