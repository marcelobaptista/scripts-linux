#!/bin/bash
#
# Adicionando repositórios extras
#
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf install -y https://www.elrepo.org/elrepo-release-8.0-2.el8.elrepo.noarch.rpm https://rpms.remirepo.net/enterprise/remi-release-8.rpm 
cat <<"EOF">/etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos8-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
#
# Atualização inicial do sistema
#
dnf update -y
#
# Instalando pacotes básicos e a pilha LAMP
#
dnf install -y bash-completion boost-program-options bzip2 certmonger cockpit cockpit-pcp curl epel-release dnf-automatic dnf-utils fail2ban gcc git htop httpd httpd-tools iptraf less lsof make mlocate nano net-tools nmap p7zip perl perl-Encode-Detect perl-Net-SSLeay openssl php php-common php-fpm php-gd php-mbstring php-mysqlnd php-opcache php-xml psmisc python3 realmd rkhunter rsync screen setroubleshoot-server sos tcpdump traceroute unzip vim wget zsh
dnf install MariaDB-server MariaDB-client --disablerepo=AppStream 
#
# Instalando ZSH
#
git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/oh-my-zsh
rm -rf /etc/oh-my-zsh/custom/plugins/*
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/oh-my-zsh/custom/plugins/
#
# Aplicando configurações adicionais
#
sed -i 's/^SELINUX=.*$/SELINUX=permissive/' /etc/selinux/config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
cat <<"EOF"> /etc/chrony.conf
server a.st1.ntp.br iburst
server b.st1.ntp.br iburst
server c.st1.ntp.br iburst
server d.st1.ntp.br iburst
server a.ntp.br iburst
server b.ntp.br iburst
server c.ntp.br iburst
server gps.ntp.br iburst
keyfile /etc/chrony.keys
driftfile /var/lib/chrony/drift
maxupdateskew 100.0
dumponexit
dumpdir /var/lib/chrony
makestep 1.0 3
rtcsync
leapsectz right/UTC
logdir /var/log/chrony
EOF
systemctl enable chronyd cockpit fail2ban firewalld httpd mariadb php-fpm
chown apache:apache /var/www/html -R
#
# Configuração básica do FirewallD
#
firewall-cmd --permanent --add-service=cockpit
firewall-cmd --permanent --add-service=dhcp
firewall-cmd --permanent --add-service=dns
firewall-cmd --permanent --add-service=git
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=ntp
firewall-cmd --permanent --add-service=snmp
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload
#
# Limpando histórico do Shell e reiniciando
#
cat /dev/null > ~/.bash_history && history -c && reboot
