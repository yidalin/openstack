# Install neutron service on Controller
apt install -y neutron-server neutron-plugin-ml2 python-neutronclient

cp -af neutron.conf.no-comment /etc/neutron/neutron.conf 
cp -af ml2_conf.ini.orig.no-comment /etc/neutron/plugins/ml2/ml2_conf.ini
cp -af nova.conf.no-comment /etc/nova/nova.conf
break