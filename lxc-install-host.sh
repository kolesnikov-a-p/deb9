#!/bin/bash

apt install lxc lxctl bridge-utils ntpdate ntp psmisc mc htop iptables iputils-ping

echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config

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

echo "#!/bin/sh
/sbin/iptables-restore < /etc/iptables.up.rules" > /etc/network/if-pre-up.d/iptables

chmod +x /etc/network/if-pre-up.d/iptables

echo "Отключение IP v6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

lxc-checkconfig
