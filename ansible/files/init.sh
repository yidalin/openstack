#!/bin/bash
hostnamectl set-hostname controller
cp -af interfaces /etc/network/interfaces
ip addr flush eth0
systemctl restart networking.service