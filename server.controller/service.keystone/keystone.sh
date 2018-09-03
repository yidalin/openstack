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

## Image service ##
# Create user glance on keystone
echo 'The glance user password is "GLANCE_PASS"'
openstack user create glance --domain default --password-prompt
# Add  role admin to project service and user glance on keystone
openstack role add admin --project service --user glance
# Create image service (glance) on keystone
openstack service create image --name glance --description "OpenStack Image Service"
# Create endpoint public, internal, admin on keystone
openstack endpoint create image --region RegionOne public http://controller:9292
openstack endpoint create image --region RegionOne internal http://controller:9292
openstack endpoint create image --region RegionOne admin http://controller:9292

## Compute service ##
# Create user nova on keystone
echo 'The nova user password is "NOVA_PASS"'
#openstack user create nova --domain default --password-prompt
openstack user create nova --domain default --password NOVA_PASS
# Add  role admin to project service and user nova on keystone
openstack role add admin --project service --user nova
# Create compute service (nova) on keystone
openstack service create compute --name nova --description "OpenStack Compute Service"
# Create endpoint public, internal, admin on keystone
openstack endpoint create compute --region RegionOne public http://controller:8774/v2.1
openstack endpoint create compute --region RegionOne internal http://controller:8774/v2.1
openstack endpoint create compute --region RegionOne admin http://controller:8774/v2.1

# Create user placement on keystone
echo 'The placement user password is "PLACEMENT_PASS"'
#openstack user create placement --domain default --password-prompt
openstack user create placement --domain default --password PLACEMENT_PASS
# Add  role admin to project service and user placement on keystone
openstack role add admin --project service --user placement
# Create compute service (placement) on keystone
openstack service create placement --name placement --description "OpenStack Placement API"
# Create endpoint public, internal, admin on keystone
openstack endpoint create placement --region RegionOne public http://controller:8778
openstack endpoint create placement --region RegionOne internal http://controller:8778
openstack endpoint create placement --region RegionOne admin http://controller:8778

# Create user cinder on keystone
echo 'The cinder user password is "CINDER_PASS"'
#openstack user create cinder --domain default --password-prompt
openstack user create cinder --domain default --password CINDER_PASS
# Add  role admin to project service and user cinder on keystone
openstack role add admin --project service --user cinder
# Create block storage service (cinder) on keystone
openstack service create volumev2 --name cinderv2 --description "OpenStack Block Storage"
openstack service create volumev3 --name cinderv3 --description "OpenStack Block Storage"

# Create endpoint public, internal, admin on keystone
openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(project_id\)s

openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s

# Create user neutron on keystone
echo 'The neutron user password is "NEUTRON_PASS"'
#openstack user create neutron --domain default --password-prompt
openstack user create neutron --domain default --password NEUTRON_PASS
# Add  role admin to project service and user neutron on keystone
openstack role add admin --project service --user neutron
# Create network service (neutron) on keystone
openstack service create network --name neutron --description "OpenStack Network Service"
# Create endpoint public, internal, admin on keystone
openstack endpoint create neutron --region RegionOne public http://controller:9696
openstack endpoint create neutron --region RegionOne internal http://controller:9696
openstack endpoint create neutron --region RegionOne admin http://controller:9696
