# This script shoud implement on controller server #

# Install nova service components
sudo apt install -y nova-api nova-conductor nova-consoleauth \
nova-novncproxy nova-scheduler nova-placement-api 

# Replace the nova conf
cp -af nova.conf.no-comment /etc/nova/nova.conf

# Sync the nova-api database by nova-manage (Create tables, schema...)
# Log: /var/log/nova/nova-manage.log
nova-manage api_db sync

# Register the database: cell0
# Log: /var/log/nova/nova-manage.log
nova-manage cell_v2 map_cell0

# Create cell1
nova-manage cell_v2 create_cell --name=cell1 --verbose

# Confirm that cell0 and cell1 created.
nova-manage cell_v2 list_cells

# Sync the nova database by nova-manage (Create tables, schema...)
nova-manage db sync

# Restart nova-api service
systemctl restart nova-api.service

# Restart nova-consoleauth service
systemctl restart nova-consoleauth.service

# Restart nova-scheduler service
systemctl restart nova-scheduler.service

# Restart nova-conductor service
systemctl restart nova-conductor.service

# Restart nova-novncproxy service
systemctl restart nova-novncproxy.service


### Please implement after deployed nova compute server
## Setting the Hypervisor
source /root/openstack/admin-openrc

# Check the hypervisor
openstack compute service list --service nova-compute

# Add compute1 node to ... 
nova-manage cell_v2 discover_hosts --verbose

source none-openrc


# Verify and test the nova service
source admin-openrc


# After deploy neutron server
cp -ai nova.conf.no-comment /etc/nova/nova.conf
systemctl restart nova-api.service