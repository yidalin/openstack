TARGETS = console-setup mountkernfs.sh resolvconf ufw screen-cleanup hostname.sh plymouth-log apparmor udev mountdevsubfs.sh procps hwclock.sh checkroot.sh cryptdisks cryptdisks-early networking lvm2 checkfs.sh urandom iscsid open-iscsi mountall-bootclean.sh mountall.sh bootmisc.sh kmod checkroot-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
INTERACTIVE = console-setup udev checkroot.sh cryptdisks cryptdisks-early checkfs.sh
udev: mountkernfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
procps: mountkernfs.sh udev
hwclock.sh: mountdevsubfs.sh
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
cryptdisks: checkroot.sh cryptdisks-early udev lvm2
cryptdisks-early: checkroot.sh udev
networking: mountkernfs.sh urandom resolvconf procps
lvm2: cryptdisks-early mountdevsubfs.sh udev
checkfs.sh: cryptdisks checkroot.sh lvm2
urandom: hwclock.sh
iscsid: networking
open-iscsi: networking iscsid
mountall-bootclean.sh: mountall.sh
mountall.sh: lvm2 checkfs.sh checkroot-bootclean.sh
bootmisc.sh: mountall-bootclean.sh udev checkroot-bootclean.sh mountnfs-bootclean.sh
kmod: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
mountnfs.sh: networking
mountnfs-bootclean.sh: mountnfs.sh
