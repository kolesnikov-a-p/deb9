# Полезные скрипты для Debian 9

```sudo apt update && sudo apt upgrade && sudo apt install git ca-certificates```

```git clone https://github.com/kolesnikov-a-p/deb9.git && cd deb9 && sudo bash lxc-install-host.sh```

## Авторизация по ключу

sudo sh -c 'echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config' && mkdir ~/.ssh && nano ~/.ssh/authorized_keys


## Отключение проверки пароля для sudo

sudo visudo # username ALL=(ALL:ALL) NOPASSWD: ALL


