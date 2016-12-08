#!/bin/bash
set -x

if [ ! "$(ls -A share/images)" ]; then

    mkdir -p share/images
    cd share/images

    # Fedora Image
    #curl -O https://dl.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-23-20151030.x86_64.qcow2

    # ClearLinux image
    LATEST=$(curl https://download.clearlinux.org/current/latest)
    clear_image=clear-$LATEST-cloud
    curl -O https://download.clearlinux.org/image/$clear_image.img.xz
    unxz $clear_image.img.xz

    # CNCI Image
    cnci_image_name="clear-8260-ciao-networking"
    curl -O https://download.clearlinux.org/demos/ciao/$cnci_image_name.img.xz
    unxz $cnci_image_name.img.xz
    rm *.xz
    cd -
    
    . $GOPATH/src/github.com/01org/ciao/networking/ciao-cnci-agent/scripts/generate_cnci_cloud_image.sh \
      --certs certs/ \
      --image share/images/$cnci_image_name.img
else
    echo "Images are already downloaded/customized"
fi
