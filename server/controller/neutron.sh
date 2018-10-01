#!/bin/bash
# Install neutron service on Controller
apt install -y neutron-server neutron-plugin-ml2 python-neutronclient

cp -af neutron.conf.no-comment /etc/neutron/neutron.conf 
cp -af ml2_conf.ini.orig.no-comment /etc/neutron/plugins/ml2/ml2_conf.ini
cp -af nova.conf.no-comment /etc/nova/nova.conf

neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head

systemctl restart nova-api.service
systemctl restart neutron-server.service

## Create External network
# Cteate ext-net external network (flat)
openstack network create ext-net --external --provider-physical-network external --provider-network-type flat
# Create a subnet for ext-net
openstack subnet create ext-subnet --network ext-net --subnet-range 192.168.9.0/24 --allocation-pool start=192.168.9.220,end=192.168.9.240 --no-dhcp --gateway 192.168.9.254

# Use demo account
openstack network create demo-net
openstack subnet create demo-subnet --network demo-net --subnet-range 192.168.0.0/24 --dns-nameserver 8.8.8.8 --gateway 192.168.0.1
openstack router create demo-router
openstack router add subnet demo-router demo-subnet
openstack router set demo-router --external-gateway ext-net