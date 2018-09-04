## Implement on neutron server

# Install neutron layer 2 and layer 3 component
apt install -y neutron-plugin-ml2 neutron-linuxbridge-agent \
neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent

cp -af /root/openstack/server.network/service.neutron/neutron.conf.no-comment /etc/neutron/neutron.conf
cp -af /root/openstack/server.network/service.neutron/ml2_conf.ini.no-comment /etc/neutron/plugins/ml2/ml2_conf.ini
cp -af /root/openstack/server.network/service.neutron/linuxbridge_agent.ini.no-comment /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp -af /root/openstack/server.network/service.neutron/l3_agent.ini.no-comment /etc/neutron/l3_agent.ini
cp -af /root/openstack/server.network/service.neutron/dhcp_agent.ini.no-comment /etc/neutron/dhcp_agent.ini
cp -af /root/openstack/server.network/service.neutron/metadata_agent.ini.no-comment /etc/neutron/metadata_agent.ini