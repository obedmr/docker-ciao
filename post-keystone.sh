#!/bin/bash

source /root/openrc

# Create CIAO Compute Endpoint
openstack service create --name ciao \
	  --description "CIAO compute" compute

openstack endpoint create compute \
	  --region RegionOne public https://localhost:8774/v2.1/%\(tenant_id\)s

openstack endpoint create compute \
	  --region RegionOne admin https://localhost:8774/v2.1/%\(tenant_id\)s

openstack endpoint create compute \
	  --region RegionOne internal https://localhost:8774/v2.1/%\(tenant_id\)s

# Create CIAO Image Endpoint
openstack service create --name glance \
          --description "CIAO Image Service" image

openstack endpoint create --region RegionOne \
          image public https://localhost:9292

openstack endpoint create --region RegionOne \
          image internal https://localhost:9292

openstack endpoint create --region RegionOne \
          image admin https://localhost:9292

# Create CIAO Demo project/user
openstack project create --domain default \
	  --description "CIAO Demo Project" demo

openstack user create --domain default \
	  --password demo demo

openstack role add --project demo --user demo user
