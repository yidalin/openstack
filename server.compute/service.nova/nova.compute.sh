# Implement on the compute server
apt install -y nova-compute

cp -af nova.conf.no-comment /etc/nova/nova.conf
cp -af nova-compute.conf.no-comment /etc/nova/nova-compute.conf

systemctl restart nova-compute.service

systemctl status nova-compute.service