#!/bin/bash

read -n 1 -p "Please replace {my_ip} as the controller's IP address in the nova.conf"

# Implement on the compute server
apt install -y nova-compute

read -n 1 -p "Please check whether the compute server support hardware virtualization by kvm-ok command"

cp -f etc/nova/nova.conf /etc/nova/nova.conf
cp -f etc/nova/nova-compute.conf /etc/nova/nova-compute.conf

systemctl restart nova-compute.service
systemctl status nova-compute.service
