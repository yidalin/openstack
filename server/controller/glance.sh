#!/bin/bash

# Install glance service
apt install -y glance

cp -f ./etc/glance/glance-api.conf /etc/glance/glance-api.conf
cp -f ./etc/glance/glance-registry.conf /etc/glance/glance-registry.conf

# Synchronizee the database by glance-manage (Create table, schema, data...)
glance-manage db_sync

# Restart the glance-registry service
systemctl restart glance-registry.service
# Restart the glance-api service
systemctl restart glance-api.service

# Upload image (Cirros) to glance service (controller)
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img

source ~/admin-openrc

openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
mv ./cirros-0.4.0-x86_64-disk.img ~
openstack image list
