#!/bin/bash

# Ceph
echo Setting Ceph permissions
ceph auth get-or-create client.ciao -o /etc/ceph/ceph.client.ciao.keyring mon 'allow *' osd 'allow *' mds 'allow'

source /root/ciaorc

# Add default images
echo Adding default images
cd /share/images/

# CNCI Image
echo CNCI Image
ciao-cli image add --file clear-*networking* --name "ciao CNCI image" --id 4e16e743-265a-4bf2-9fd1-57ada0b28904

# ClearLinux
echo ClearLinux image
ciao-cli image add --file clear-*-cloud.img --name "Clear Linux" --id df3768da-31f5-4ba6-82f0-127a1a705169

# Fedora 24
echo Fedora image
ciao-cli image add --file Fedora-Cloud-Base-24-1.2.x86_64.qcow2 --name "Fedora 24" --id 73a86d7e-93c0-480e-9c41-ab42f69b7799

# Ubuntu Trusty
echo Ubuntu image
ciao-cli image add --file trusty-server-cloudimg-amd64-disk1.img --name "Ubuntu Trusty" --id cbba2aee-7204-4aae-a466-1c8b1f973378
