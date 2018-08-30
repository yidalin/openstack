# OpenStack > Controller - memcache Service

# Install memcache and python MQ
apt install -y memcached python-memcache


cp -af memcached.conf /etc/memcached.conf
#sed -i 's/-l 127.0.0.1/-l controller/g' /etc/memcached.conf

systemctl restart memcached.service

