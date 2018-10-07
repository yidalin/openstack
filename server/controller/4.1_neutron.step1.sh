#!/bin/bash
# Install neutron service on Controller
apt install -y neutron-server neutron-plugin-ml2 python-neutronclient

cp -f etc/neutron/neutron.conf /etc/neutron/neutron.conf 
cp -f etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
cp -f etc/nova/nova.conf /etc/nova/nova.conf

neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head

systemctl restart nova-api.service
systemctl restart neutron-server.service
