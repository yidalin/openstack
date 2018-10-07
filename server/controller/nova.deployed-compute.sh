#!/bin/bash

### Please implement after deployed nova compute server
## Setting the Hypervisor
source ~/admin-openrc

# Check the hypervisor
openstack compute service list --service nova-compute

# Add compute1 node to ... 
nova-manage cell_v2 discover_hosts --verbose
