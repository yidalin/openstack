#!/bin/bash
## Implement on storage server

# Install LVM function
apt install -y lvm2 thin-provisioning-tools

# Assign /dev/sdb as the LVM physical volume
pvcreate /dev/sdb

# Set the /dev/sdb as the LVM disk group
vgcreate cinder-volumes /dev/sdb

# Modity the LVM config: /etc/lvm/lvm.conf (Only use /dev/sdb)

cp -f etc/lvm/lvm.conf /etc/lvm/lvm.conf

# Install cinder packages
apt install -y cinder-volume tgt

# Replace the cinder conf
cp -f etc/cinder/cinder.conf /etc/cinder/cinder.conf

# Restart tgt (iSCSI target) service
systemctl restart tgt.service
#systemctl status tgt.service

# Restart cinder-volume service
systemctl restart cinder-volume.service
#systemctl status cinder-volume.service
