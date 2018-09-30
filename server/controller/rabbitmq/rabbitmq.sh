# OpenStack > Controller - RabbitMQ Service

# Install RabbitMQ service
apt install -y rabbitmq-server

# Delete user "guest" who has administrative permission
rabbitmqctl delete_user guest

# Add new user openstack for RabbitMQ
rabbitmqctl add_user openstack RABBIT_PASS

# Configure the permission for the user openstack
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

systemctl status rabbitmq-server.service
#systemctl enable rabbitmq-server.service
#systemctl restart rabbitmq-server.service
