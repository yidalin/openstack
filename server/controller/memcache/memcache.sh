# OpenStack > Controller - memcache Service

# Install memcache and python MQ
apt install -y memcached python-memcache

cp -f etc/memcached.conf /etc/memcached.conf

systemctl restart memcached.service
