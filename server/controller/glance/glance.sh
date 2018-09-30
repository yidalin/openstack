# Controller - Glance

source ./admin-openrc

# Install glance service
apt install -y glance

:'
# Modify the glance-api conf

1. Setting the connection for database
# 1924
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

2. Setting the store method for glance image
# 2041
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images

3. Setting the support image format for glance
# 3459
[image_format]
disk_formats = ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,ploop.root-tar

4. Setting the authentication information for keystone
# 3474
[keystone_authtoken] <-- Insert these configuration after this line
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

5. Setting the paste_deploy
# 4489
[paste_deploy]
flavor = keystone
'

:'
# Modify the glance-registry conf: /etc/glance/glance-registry.conf

1. Setting the connection for database
# 1170
[database] 
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

2. Setting the authentication for keystone
# 1287
[keystone_authtoken] <-- Insert these configuration after this line
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

3. Setting the paste_deploy
# 2275
[paste_deploy]
flavor = keystone
'

# Synchronizee the database by glance-manage (Create table, schema, data...)
glance-manage db_sync

# Restart the glance-registry service
systemctl restart glance-registry.service
# Restart the glance-api service
systemctl restart glance-api.service

# Upload image (Cirros) to glance service (controller)
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img

openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public

openstack image list
