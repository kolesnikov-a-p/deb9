

```sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git ca-certificates```

```git clone https://github.com/kolesnikov-a-p/deb9.git && cd deb9 && sudo bash lxc-install-host.sh```

```git clone https://github.com/kolesnikov-a-p/deb9.git && cd deb9 && sudo bash lxc-install-auto.sh```

```git clone https://github.com/kolesnikov-a-p/deb9.git && cd deb9 && sudo bash lxc-new.sh```



```sudo sh -c 'echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config' && mkdir ~/.ssh && nano ~/.ssh/authorized_keys```




```sudo visudo # username ALL=(ALL:ALL) NOPASSWD: ALL```


