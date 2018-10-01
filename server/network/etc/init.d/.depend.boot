TARGETS = console-setup ebtables mountkernfs.sh resolvconf ufw screen-cleanup hostname.sh plymouth-log apparmor udev mountdevsubfs.sh procps cryptdisks cryptdisks-early hwclock.sh urandom networking iscsid checkroot.sh lvm2 checkfs.sh open-iscsi mountall-bootclean.sh mountall.sh bootmisc.sh kmod checkroot-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
INTERACTIVE = console-setup udev cryptdisks cryptdisks-early checkroot.sh checkfs.sh
udev: mountkernfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
procps: mountkernfs.sh udev
cryptdisks: checkroot.sh cryptdisks-early udev lvm2
cryptdisks-early: checkroot.sh udev
hwclock.sh: mountdevsubfs.sh
urandom: hwclock.sh
networking: mountkernfs.sh urandom resolvconf procps
iscsid: networking
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
lvm2: cryptdisks-early mountdevsubfs.sh udev
checkfs.sh: cryptdisks checkroot.sh lvm2
open-iscsi: networking iscsid
mountall-bootclean.sh: mountall.sh
mountall.sh: lvm2 checkfs.sh checkroot-bootclean.sh
bootmisc.sh: mountall-bootclean.sh udev checkroot-bootclean.sh mountnfs-bootclean.sh
kmod: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
mountnfs.sh: networking
mountnfs-bootclean.sh: mountnfs.sh
