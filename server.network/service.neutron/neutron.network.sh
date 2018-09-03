## Implement on neutron server

# Install neutron layer 2 and layer 3 component
apt install -y neutron-plugin-ml2 neutron-linuxbridge-agent \
neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent

cp -af neutron.conf.no-comment /etc/neutron/neutron.conf