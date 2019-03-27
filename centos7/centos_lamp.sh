#!/bin/bash

# Atualização inicial do sistema
#
yum update -y
#
# Adicionando repositórios extras
#
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm https://rpms.remirepo.net/enterprise/remi-release-7.rpm https://centos7.iuscommunity.org/ius-release.rpm yum-utils 
yum-config-manager --disable remi-php54 && yum-config-manager --enable remi-php72
cat <<"EOF">/etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/rhel7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
cat <<"EOF">/etc/yum.repos.d/webmin.repo
[Webmin]
name=Webmin Distribution Neutral
baseurl=http://download.webmin.com/download/yum
enabled=1
gpgcheck=1
gpgkey=http://www.webmin.com/jcameron-key.asc
EOF
#
# Instalando pacotes
#
yum install -y bzip2 certmonger curl epel-release fail2ban gcc git htop httpd iperf iptraf less links lsof make MariaDB-client mariadb-server multitail nano nmap ntp p7zip perl perl-IO-Tty perl-Encode-Detect perl-Net-SSLeay openssl php php-common php-gd php-mbstring php-mcrypt php-mysql php-xml psmisc python36u rar realmd rsync screen setroubleshoot-server sos tcpdump traceroute unrar unzip webmin wget zsh
yum clean all
#
# Instalando e configurando o ZSH
#
git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 
cp -rf zsh-syntax-highlighting/ /etc/oh-my-zsh/custom/plugins/
touch /etc/skel/.zshrc
cp /etc/oh-my-zsh/templates/zshrc.zsh-template /etc/skel/.zshrc
mkdir -p /etc/skel/.oh-my-zsh/cache
sed -i 's/export ZSH=$HOME\/.oh-my-zsh/export ZSH=\/etc\/oh-my-zsh/' /etc/skel/.zshrc
sed -i 's/robbyrussell/gianu/' /etc/skel/.zshrc
cp /etc/skel/.zshrc /root/.zshrc && cp /etc/skel/.zshrc $HOME
sed -i 's/SHELL=\/bin\/bash/SHELL=\/bin\/zsh/' /etc/default/useradd
chsh -s /bin/zsh
sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/ssl=1/ssl=0/' /etc/webmin/miniserv.conf
/etc/init.d/webmin restart
systemctl enable fail2ban firewalld httpd mariadb ntpd 
systemctl restart sshd
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-port 10000/tcp
firewall-cmd --reload
cat /dev/null > ~/.bash_history && history -c && exit