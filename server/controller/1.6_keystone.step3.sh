#!/bin/bash
source ~/admin-openrc

## Image service ## 
# Create user glance on keystone
openstack user create --domain default --password GLANCE_PASS glance
# Add  role admin to project service and user glance on keystone
openstack role add --project service --user glance admin
# Create image service (glance) on keystone
openstack service create --name glance --description "OpenStack Image Service" image
# Create endpoint public, internal, admin on keystone
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

## Compute service ##
# Create user nova on keystone
#openstack user create nova --domain default --password-prompt
openstack user create --domain default --password NOVA_PASS nova
# Add  role admin to project service and user nova on keystone
openstack role add --project service --user nova admin
# Create compute service (nova) on keystone
openstack service create --name nova --description "OpenStack Compute Service" compute
# Create endpoint public, internal, admin on keystone
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

# Create user placement on keystone
#openstack user create placement --domain default --password-prompt
openstack user create --domain default --password PLACEMENT_PASS placement
# Add  role admin to project service and user placement on keystone
openstack role add --project service --user placement admin
# Create compute service (placement) on keystone
openstack service create --name placement --description "OpenStack Placement API" placement
# Create endpoint public, internal, admin on keystone
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778

# Create user cinder on keystone
#openstack user create cinder --domain default --password-prompt
openstack user create --domain default --password CINDER_PASS cinder
# Add  role admin to project service and user cinder on keystone
openstack role add --project service --user cinder admin
# Create block storage service (cinder) on keystone
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
# Create endpoint public, internal, admin on keystone
openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(project_id\)s

openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s

# Create user neutron on keystone
#openstack user create neutron --domain default --password-prompt
openstack user create --domain default --password NEUTRON_PASS neutron
# Add  role admin to project service and user neutron on keystone
openstack role add --project service --user neutron admin
# Create network service (neutron) on keystone
openstack service create --name neutron --description "OpenStack Network Service" network
# Create endpoint public, internal, admin on keystone
openstack endpoint create --region RegionOne neutron public http://controller:9696
openstack endpoint create --region RegionOne neutron internal http://controller:9696
openstack endpoint create --region RegionOne neutron admin http://controller:9696
