TARGETS = console-setup ebtables mountkernfs.sh resolvconf ufw screen-cleanup hostname.sh plymouth-log apparmor udev mountdevsubfs.sh procps hwclock.sh cryptdisks cryptdisks-early checkroot.sh lvm2 checkfs.sh networking urandom iscsid open-iscsi mountall-bootclean.sh mountall.sh bootmisc.sh kmod checkroot-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
INTERACTIVE = console-setup udev cryptdisks cryptdisks-early checkroot.sh checkfs.sh
udev: mountkernfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
procps: mountkernfs.sh udev
hwclock.sh: mountdevsubfs.sh
cryptdisks: checkroot.sh cryptdisks-early udev lvm2
cryptdisks-early: checkroot.sh udev
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
lvm2: cryptdisks-early mountdevsubfs.sh udev
checkfs.sh: cryptdisks checkroot.sh lvm2
networking: mountkernfs.sh urandom resolvconf procps
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
