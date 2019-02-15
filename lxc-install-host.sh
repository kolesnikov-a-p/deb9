#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi

echo "Обновление системы"
apt update && apt upgrade
echo "Установка пакетов"
apt install ntpdate ntp psmisc mc htop iputils-ping needrestart git ca-certificates wget

echo "========================================"
echo "Установить iptables (y - да, n - нет)"
read B

if [[ "$B" = "y" ]]
then
echo "Установка пакетов"
apt install iptables
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
fi

echo "========================================"
echo "Отключить IP v6 (y - да, n - нет)"
read B

if [[ "$B" = "y" ]]
then
echo "Отключение IP v6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
fi

echo "========================================"
echo "Установить LXC (y - да, n - нет)"
read B

if [[ "$B" = "y" ]]
then
echo "Установка пакетов"
apt install lxc lxctl bridge-utils
lxc-checkconfig
fi

exit 0
