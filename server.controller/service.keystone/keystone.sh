# Controller - Keystone Service

# Install Keystone service
apt install -y keystone apache2 libapache2-mod-wsgi python-openstackclient

# Install the bash completion for OpenStack command
openstack complete | sudo tee /etc/bash_completion.d/osc.bash_completion > /dev/null

# Backup the origin file
if [ -f "/etc/keystone/keystone.conf" ]
then
	echo "The backup keystone conf exist, do not thing."
else
	echo "Backup the keystone conf file."
    cp -af keystone.conf /etc/keystone/keystone.conf
    cp -a /etc/keystone/keystone.conf /etc/keystone/keystone.conf.bk
fi

cp -af keystone.conf /etc/keystone/keystone.conf


:'
[database]
# ...
721 connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone

[token]
# ...
2934 provider = fernet
'

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
cp -af apache2.conf /etc/apache2/apache2.conf
:'
# 57 ServerName controller
'

systemctl restart apache2.service

# Export the temporary environment variables
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3/
export OS_IDENTITY_API_VERSION=3


# Create project (service, demo) on the keystone service
openstack project create service --domain default --description "Service Project"
openstack project create demo --domain default --description "Demo Project"

echo 'The next answer is "DEMO_PASS"'
openstack user create demo --domain default --password-prompt
openstack role create user
openstack role add user --project demo --user demo

unset OS_USERNAME OS_PASSWORD OS_AUTH_URL

cat << EOF > /root/admin-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export PS1='\u(OS-ADMIN)@\h:\w\$ '
EOF

cat << EOF > /root/demo-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=DEMO_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export PS1='\u(OS-DEMO)@\h:\w\$ '
EOF

cat << EOF > /root/none-openrc
unset OS_{PROJECT_DOMAIN_NAME,USER_DOMAIN_NAME,PROJECT_NAME,USERNAME}
unset OS_{PASSWORD,AUTH_URL}
unset OS_{IDENTITY_API_VERSION,IMAGE_API_VERSION}
export PS1='\u@\h:\w\$ '
EOF

source /root/admin-openrc
# Create user glance on keystone
echo 'The glance user password is "GLANCE_PASS"'
openstack user create glance --domain default --password-prompt
# Add  role admin to project service and user glance on keystone
openstack role add admin --project service --user glance
# Create service image on keystone
openstack service create image --name glance --description "OpenStack Image Service"
# Create endpoint public, internal, admin on keystone
openstack endpoint create image --region RegionOne public http://controller:9292
openstack endpoint create image --region RegionOne internal http://controller:9292
openstack endpoint create image --region RegionOne admin http://controller:9292
