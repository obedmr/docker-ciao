#!/bin/bash

HOST="${HOST:-localhost}"
NET_IFACE="${NET_IFACE:-eth10}"

option=$1
daemon=""

if [ -z "$command" ]; then
    daemon="-d"
fi

function set_macvlan() {
    sudo ip link delete macvlan0
    sudo ip link add name $NET_IFACE type bridge
    sudo iptables -t nat -A POSTROUTING -o $NET_IFACE -j MASQUERADE
    sudo ip link add link $NET_IFACE name macvlan0 type macvlan mode bridge
    sudo ip addr add 192.168.0.1/24 brd 192.168.0.255 dev macvlan0
    sudo ip link set dev macvlan0 up
    sudo ip -d link show macvlan0
    sudo ip link set dev $NET_IFACE up
    sudo ip -d link show $NET_IFACE
}

if [ ! -d "certs/" ] ; then
    ./certs.sh $HOST
    sudo rm -rf share/
    mkdir -p share/images
fi

# Download / prepare images
./images.sh

# Create CIAO macvlan
set_macvlan

# Stop / Start CIAO Cluster
docker-compose stop
docker-compose rm -f
docker-compose up -d

# Validate Cluster is up
echo "Waiting cluster to be ready "
until docker-compose exec ciao-controller /bin/bash -c "source /root/ciaorc ; ciao-cli image list" > /dev/null 2>&1 ; do
    echo -n .
done

echo " The Cluster is READY "

# Initial Configuration for running cluster
docker-compose exec ciao-controller /usr/bin/post-controller.sh
