#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi
echo "Введите название контейнера"
read VMNAME

lxc-create -n $VMNAME -t debian

chroot /var/lib/lxc/$VMNAME/rootfs/ apt-get update -y
chroot /var/lib/lxc/$VMNAME/rootfs/ apt-get upgrade -y
chroot /var/lib/lxc/$VMNAME/rootfs/ apt install -y sudo tzdata iptables mc nano iputils-ping psmisc
chroot /var/lib/lxc/$VMNAME/rootfs/ dpkg-reconfigure tzdata
echo "Введите имя пользователя"
read ADDUSER
chroot /var/lib/lxc/$VMNAME/rootfs/ adduser $ADDUSER
chroot /var/lib/lxc/$VMNAME/rootfs/ usermod -aG sudo $ADDUSER

echo "# lxc.start.auto = 1" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.type  = veth" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.flags = up" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.name = eth0" >> /var/lib/lxc/$VMNAME/config
echo "lxc.network.link = br0" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.veth.pair = veth-01" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.ipv4 = 10.0.0.10/24" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.ipv4.gateway = 10.0.0.1" >> /var/lib/lxc/$VMNAME/config
echo "# lxc.network.hwaddr = 00:1E:2D:F7:E3:4E" >> /var/lib/lxc/$VMNAME/config

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /var/lib/lxc/$VMNAME/rootfs/etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /var/lib/lxc/$VMNAME/rootfs/etc/sysctl.conf

echo "127.0.0.1   " $VMNAME >> /var/lib/lxc/$VMNAME/rootfs/etc/hosts

echo "*filter
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -j ACCEPT
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -j REJECT
-A FORWARD -j REJECT
COMMIT" > /var/lib/lxc/$VMNAME/rootfs/etc/iptables.test.rules

chroot /var/lib/lxc/$VMNAME/rootfs/ iptables-restore < /etc/iptables.test.rules && iptables-save > /etc/iptables.up.rules

echo "#!/bin/sh" > /var/lib/lxc/$VMNAME/rootfs/etc/network/if-pre-up.d/iptables
echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /var/lib/lxc/$VMNAME/rootfs/etc/network/if-pre-up.d/iptables
chmod +x /var/lib/lxc/$VMNAME/rootfs/etc/network/if-pre-up.d/iptables

exit 0
