#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi

apt-get update -y
apt-get upgrade -y
apt install -y sudo tzdata iptables mc nano iputils-ping psmisc
dpkg-reconfigure tzdata
echo "Введите имя пользователя"
read ADDUSER
adduser $ADDUSER
usermod -aG sudo $ADDUSER

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

passwd -l root

rm ./setting.sh
exit
exit 0
