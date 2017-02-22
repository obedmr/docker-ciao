#!/bin/bash
set -x
# Initial variables
ssh_user=demouser
mkdir -p ~/.ssh/
cp /share/ssh/* ~/.ssh/
pushd ~/.ssh/
ssh_key=$(< "$ssh_user".pub)
#Note: Password is set to ciao
ssh_passwd='$1$xyz$AgiIJ0Erux.NYtwL.GjNT/'

# Generate ssh config file
(
cat <<-EOF
Host 192.168.0.*
     User $ssh_user
     IdentityFile ~/.ssh/$ssh_user
EOF
) > ~/.ssh/config
popd

# Create workload files
tmpdir=`mktemp -d`
pushd $tmpdir

# create a VM test workload with ssh capability
echo "Generating VM cloud-init"
(
    cat <<-EOF
---
#cloud-config
users:
  - name: ${ssh_user}
    gecos: CIAO Demo User
    lock-passwd: false
    passwd: ${ssh_passwd}
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh-authorized-keys:
    - ${ssh_key}
...
EOF
) > vm-test.yaml

# Get the image ID for the fedora cloud image
id=$(ciao-cli image list -f='{{$x := filter . "Name" "Fedora 24"}}{{if gt (len $x) 0}}{{(index $x 0).ID}}{{end}}')

# Add test workloads
echo "Generating Fedora VM test workload"
(
    cat <<-EOF
	description: "Fedora test VM"
	vm_type: qemu
	fw_type: legacy
	defaults:
	    vcpus: 2
	    mem_mb: 128
	    disk_mb: 80
	cloud_init: "vm-test.yaml"
	disks:
	  - source:
	       service: image
	       id: "$id"
	    ephemeral: true
	    bootable: true
EOF
) > fedora_vm.yaml

clear_id=$(ciao-cli image list -f='{{$x := filter . "Name" "Clear Linux"}}{{if gt (len $x) 0}}{{(index $x 0).ID}}{{end}}')

# create a clear VM workload definition
echo "Creating Clear test workload"
(
    cat <<-EOF
	description: "Clear Linux test VM"
	vm_type: qemu
	fw_type: efi
	defaults:
	    vcpus: 2
	    mem_mb: 128
	    disk_mb: 80
	cloud_init: "vm-test.yaml"
	disks:
	  - source:
	       service: image
	       id: "$clear_id"
	    ephemeral: true
	    bootable: true
	EOF
) > clear_vm.yaml

# Get the image ID for the ubuntu trusty image
ubuntu_id=$(ciao-cli image list -f='{{$x := filter . "Name" "Ubuntu Trusty"}}{{if gt (len $x) 0}}{{(index $x 0).ID}}{{end}}')

# add 2 vm test workloads
echo "Generating Ubuntu VM test workload"
(
    cat <<-EOF
	description: "Ubuntu test VM"
	vm_type: qemu
	fw_type: legacy
	defaults:
	    vcpus: 2
	    mem_mb: 128
	    disk_mb: 80
	cloud_init: "vm-test.yaml"
	disks:
	  - source:
	       service: image
	       id: "$ubuntu_id"
	    ephemeral: true
	    bootable: true
	EOF
) > ubuntu_vm.yaml

# Create workloads
ciao-cli workload create -yaml fedora_vm.yaml
ciao-cli workload create -yaml clear_vm.yaml
ciao-cli workload create -yaml ubuntu_vm.yaml

popd
