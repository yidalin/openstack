#!/bin/bash
## Implement on neutron server

# Install neutron layer 2 and layer 3 component
apt install -y neutron-plugin-ml2 neutron-linuxbridge-agent \
neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent

cp -f etc/neutron/neutron.conf /etc/neutron/neutron.conf
cp -f etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini

read -n 1 -p "Press check the {physical_interface_mappings} in the linuxbridge_agent.ini file"
read -n 1 -p "Press check the {local_ip} in the linuxbridge_agent.ini file"

cp -f etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp -f etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini
cp -f etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini
cp -f etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini

systemctl restart neutron-linuxbridge-agent.service
systemctl restart neutron-dhcp-agent.service
systemctl restart neutron-metadata-agent.service
systemctl restart neutron-l3-agent.service