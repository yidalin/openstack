#!/bin/bash
## Implement on Controller node
# Install cinder caller and its management packages
apt install -y cinder-api cinder-scheduler

# Replace the cinder config
cp -f etc/cinder/cinder.conf /etc/cinder/cinder.conf

# Sync database by cinder-manage (Create tables, schema and some initial data...)
cinder-manage db sync

# Add cinder setting on the /etc/nova/nova.conf
cp -f etc/nova/nova.conf /etc/nova/nova.conf

# Restart nova-api service
systemctl restart nova-api.service

# Restart cinder-scheduler service
systemctl restart cinder-scheduler.service

# Restart apache service for cinder-api
systemctl restart apache2.service

openstack volume create --size 1 --description "Demo's volume" demoVol