#!/bin/bash

# After deploy neutron server

cp -f etc/nova/nova.conf /etc/nova/nova.conf

systemctl restart nova-api.service
systemctl restart apache2
