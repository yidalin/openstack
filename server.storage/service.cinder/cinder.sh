## Implement on storage server

# Install LVM function
apt install -y lvm2 thin-provisioning-tools

# Assign /dev/sdb as the LVM physical volume
pvcreate /dev/sdb

# Set the /dev/sdb as the LVM disk group
vgcreate cinder-volumes /dev/sdb

# Modity the LVM config: /etc/lvm/lvm.conf (Only use /dev/sdb)

cp -af lvm.conf /etc/lvm/lvm.conf
:'
devices {
    filter = [ "a/sdb/", "r/.*/" ]
'

# Install cinder packages
apt install -y cinder-volume tgt

