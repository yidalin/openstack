TARGETS = console-setup mountkernfs.sh resolvconf ufw screen-cleanup hostname.sh plymouth-log apparmor udev cryptdisks cryptdisks-early hwclock.sh urandom iscsid networking checkroot.sh lvm2 checkfs.sh mountdevsubfs.sh open-iscsi mountall-bootclean.sh mountall.sh bootmisc.sh scsitools-pre.sh kmod checkroot-bootclean.sh mountnfs.sh mountnfs-bootclean.sh scsitools.sh procps
INTERACTIVE = console-setup udev cryptdisks cryptdisks-early checkroot.sh checkfs.sh
udev: mountkernfs.sh
cryptdisks: checkroot.sh cryptdisks-early udev lvm2
cryptdisks-early: checkroot.sh udev
hwclock.sh: mountdevsubfs.sh
urandom: hwclock.sh
iscsid: networking
networking: mountkernfs.sh urandom resolvconf procps
checkroot.sh: hwclock.sh scsitools-pre.sh mountdevsubfs.sh hostname.sh
lvm2: cryptdisks-early mountdevsubfs.sh udev
checkfs.sh: cryptdisks checkroot.sh lvm2 scsitools.sh
mountdevsubfs.sh: mountkernfs.sh udev
open-iscsi: networking iscsid
mountall-bootclean.sh: mountall.sh
mountall.sh: lvm2 checkfs.sh checkroot-bootclean.sh
bootmisc.sh: mountall-bootclean.sh udev checkroot-bootclean.sh mountnfs-bootclean.sh
scsitools-pre.sh: mountdevsubfs.sh
kmod: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
mountnfs.sh: networking
mountnfs-bootclean.sh: mountnfs.sh
scsitools.sh: checkroot.sh scsitools-pre.sh
procps: mountkernfs.sh udev
