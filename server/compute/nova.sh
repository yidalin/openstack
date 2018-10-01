#!/bin/bash
# Implement on the compute server
apt install -y nova-compute

cp -f etc/nova/nova.conf /etc/nova/nova.conf
cp -f etc/nova/nova-compute.conf /etc/nova/nova-compute.conf

systemctl restart nova-compute.service
systemctl status nova-compute.service
