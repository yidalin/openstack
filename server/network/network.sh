#!/bin/bash

systemctl restart neutron-linuxbridge-agent.service
systemctl restart neutron-dhcp-agent.service
systemctl restart neutron-metadata-agent.service
systemctl restart neutron-l3-agent.service
