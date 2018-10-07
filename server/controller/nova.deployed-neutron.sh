#!/bin/bash
# After deploy neutron server
source ~/admin-openrc

cp -f etc/nova/nova.conf /etc/nova/nova.conf

systemctl restart nova-api.service
systemctl restart apache2