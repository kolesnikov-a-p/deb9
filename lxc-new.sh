#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi
echo "Введите название контейнера"
read VMNAME

lxc-create -n $VMNAME -t debian

chroot /var/lib/lxc/$VMNAME/rootfs/ passwd

echo "# lxc.start.auto = 1" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.type  = veth" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.flags = up" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.name = eth0" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.link = br0" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.veth.pair = veth-$VMNAME" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.ipv4 = 10.0.0.10/24" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.ipv4.gateway = 10.0.0.1" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.hwaddr = 00:1E:2D:F7:E3:4E" >> /var/lib/lxc/$VMNAME/config

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /var/lib/lxc/$VMNAME/rootfs/etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /var/lib/lxc/$VMNAME/rootfs/etc/sysctl.conf

echo "127.0.0.1   " $VMNAME >> /var/lib/lxc/$VMNAME/rootfs/etc/hosts

cp ./setting.sh /var/lib/lxc/$VMNAME/rootfs/root/setting.sh
chmod +x /var/lib/lxc/$VMNAME/rootfs/root/setting.sh

exit 0
