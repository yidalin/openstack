#!/bin/bash

systemctl restart mysql.service
systemctl restart rabbitmq-server
systemctl restart memcached.service

systemctl restart glance-registry.service
systemctl restart glance-api.service

systemctl restart nova-api.service
systemctl restart nova-consoleauth.service
systemctl restart nova-scheduler.service
systemctl restart nova-conductor.service
systemctl restart nova-novncproxy.service
systemctl restart nova-api.service

systemctl restart cinder-scheduler.service
systemctl restart neutron-server.service

systemctl restart apache2.service 
