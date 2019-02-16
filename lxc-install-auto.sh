#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi

echo "Обновление системы"
apt update -y && apt upgrade -y
echo "Установка пакетов"
apt install -y ntpdate ntp psmisc mc htop iputils-ping needrestart git ca-certificates wget tzdata iptables lxc lxctl bridge-utils


echo "*filter
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -j ACCEPT
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -j REJECT
-A FORWARD -j REJECT
COMMIT" > /etc/iptables.test.rules

iptables-restore < /etc/iptables.test.rules && iptables-save > /etc/iptables.up.rules
echo "#!/bin/sh" > /etc/network/if-pre-up.d/iptables
echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
chmod +x /etc/network/if-pre-up.d/iptables

echo "Отключение IP v6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf


echo "
auto br0
iface br0 inet static
#bridge-ports enp0s3
address 172.23.4.200
gateway 172.23.4.1
netmask 255.255.255.0" >> /etc/network/interfaces

lxc-checkconfig

exit 0
