## Implement on Controller node
# Install cinder caller and its management packages
apt install -y cinder-api cinder-scheduler

# Replace the cinder config
cp -af cinder.conf.no-comment /etc/cinder/cinder.conf

# Sync database by cinder-manage (Create tables, schema and some initial data...)
cinder-manage db sync

# Add cinder setting on the /etc/nova/nova.conf
:'
[cinder]
os_region_name = RegionOne
'
# Restart nova-api service
systemctl restart nova-api.service

# Restart cinder-scheduler service
systemctl restart cinder-scheduler.service

# Restart apache service for cinder-api
systemctl restart apache2.service
