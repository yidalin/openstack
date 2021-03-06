#!/bin/bash
# Install neutron-linuxbridge-agent package
apt install -y neutron-linuxbridge-agent

cp -f etc/neutron/neutron.conf /etc/neutron/neutron.conf

read -n 1 -p "Press check the {local_ip} in the linuxbridge_agent.ini file"

cp -f etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp -f etc/nova/nova.conf /etc/nova/nova.conf

systemctl restart nova-compute.service
systemctl restart neutron-linuxbridge-agent.service

