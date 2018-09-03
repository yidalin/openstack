# Install neutron-linuxbridge-agent package
apt install -y neutron-linuxbridge-agent

cp -af neutron.conf.no-comment /etc/neutron/neutron.conf
cp -af linuxbridge_agent.ini.no-comment /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp -af nova.conf.no-comment /etc/nova/nova.conf

systemctl restart nova-compute.service
systemctl restart neutron-linuxbridge-agent.service

