#!/bin/bash
# This script shoud implement on controller server #

source ~/admin-openrc

# Check the hypervisor
openstack compute service list --service nova-compute

# Add compute1 node to ... 
nova-manage cell_v2 discover_hosts --verbose
