#!/bin/bash

# Export the temporary environment variables
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3/
export OS_IDENTITY_API_VERSION=3

# Create project (service, demo) on the keystone service
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo

openstack user create --domain default --password DEMO_PASS demo
openstack role create user
openstack role add --project demo --user demo user

unset OS_USERNAME OS_PASSWORD OS_AUTH_URL

cat << EOF > ~/admin-openrc
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

cat << EOF > ~/demo-openrc
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

cat << EOF > ~/none-openrc
unset OS_{PROJECT_DOMAIN_NAME,USER_DOMAIN_NAME,PROJECT_NAME,USERNAME}
unset OS_{PASSWORD,AUTH_URL}
unset OS_{IDENTITY_API_VERSION,IMAGE_API_VERSION}
export PS1='\u@\h:\w\$ '
EOF
