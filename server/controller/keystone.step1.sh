#!/bin/bash
# Controller - Keystone Service

# Install Keystone service
apt install -y keystone apache2 libapache2-mod-wsgi python-openstackclient

# Install the bash completion for OpenStack command
openstack complete | sudo tee /etc/bash_completion.d/osc.bash_completion > /dev/null

cp -f etc/keystone/keystone.conf /etc/keystone/keystone.conf

# Synchronizing the database
keystone-manage db_sync

# Initializing the Fernet Key
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

# Initializing credentials
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

# Create the keystone service endpoing for admin auth
keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
--bootstrap-admin-url http://controller:5000/v3 \
--bootstrap-internal-url http://controller:5000/v3 \
--bootstrap-public-url http://controller:5000/v3 \
--bootstrap-region-id RegionOne

# Apache service
cp -f etc/apache2/apache2.conf /etc/apache2/apache2.conf

systemctl restart apache2.service
