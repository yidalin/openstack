#!/bin/bash

apt install -y openstack-dashboard

cp -f etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py

chown horizon:horizon /var/lib/openstack-dashboard/secret_key

systemctl reload apache2.service 
