#!/bin/bash

systemctl restart nova-compute.service
systemctl restart neutron-linuxbridge-agent.service
