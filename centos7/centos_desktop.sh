#!/bin/bash
#
# Adicionando repositórios extras
#
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
yum install -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm https://centos7.iuscommunity.org/ius-release.rpm yum-utils
#
# Atualização inicial do sistema
#
yum update -y
#
# Instalando interface gráfica e XFCE
#
yum groupinstall "X Window System" -y
yum groupinstall "Xfce" -y
rm /usr/share/xsessions/openbox.desktop
systemctl set-default graphical.target
#
# Instalando pacotes básicos e removendo os desnecessários
#
yum remove firewalld postfix -y
yum install -y alsa-utils alsa-plugins-pulseaudio autoconf automake bash-completion bash-completion-extras bc bzip2 certmonger evince file-roller firefox flash-plugin gcc git gnome-calculator gnome-disk-utility gparted gtk3-devel gvfs-fuse gvfs-mtp htop light-locker mlocate mousepad mtr nano nautilus nautilus-image-converter network-manager-applet nmap ntfs-3g ntp numix-gtk-theme paper-icon-theme ristretto system-config-printer tcpdump traceroute unrar unzip vlc x264 xarchiver xdg-user-dirs xfce4-notifyd xfce4-screenshooter xfce4-whiskermenu-plugin xvidcore wget
yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh | sh
wget https://github.com/marcelobaptista/scripts-linux/raw/master/centos7/jre-8u201-linux-x64.rpm
rpm -ivh jre-8u201-linux-x64.rpm
wget http://tdf.c3sl.ufpr.br/libreoffice/stable/6.3.0/rpm/x86_64/LibreOffice_6.3.0_Linux_x86-64_rpm.tar.gz
wget http://tdf.c3sl.ufpr.br/libreoffice/stable/6.3.0/rpm/x86_64/LibreOffice_6.3.0_Linux_x86-64_rpm_langpack_pt-BR.tar.gz
tar -vzxf LibreOffice_6.3.0_Linux_x86-64_rpm.tar.gz
tar -vzxf LibreOffice_6.3.0_Linux_x86-64_rpm_langpack_pt-BR.tar.gz
rpm -vih LibreOffice_6.3.0_Linux_x86-64_rpm/RPMS/*.rpm
rpm -vih LibreOffice_6.3.0_Linux_x86-64_rpm_langpack_pt-BR/RPMS/*.rpm
rm -rf LibreOffice_6.3.0_Linux_x86-64_rpm LibreOffice_6.3.0_Linux_x86-64_rpm_langpack_pt-BR *.tar.gz jre-8u201-linux-x64.rpm
yum clean all
#
# Instalando e configurando o ZSH
#
git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/oh-my-zsh
rm -rf /etc/oh-my-zsh/custom/plugins/*
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/oh-my-zsh/custom/plugins/
wget https://raw.githubusercontent.com/marcelobaptista/scripts-linux/master/.zshrc -O /etc/skel/.zshrc
mkdir -p /etc/skel/.oh-my-zsh/cache
cp /etc/skel/.zshrc $HOME
sed -i 's/SHELL=\/bin\/bash/SHELL=\/bin\/zsh/' /etc/default/useradd
chsh -s /bin/zsh
#
# Aplicando configurações adicionais
#
sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd
wget https://github.com/marcelobaptista/scripts-linux/raw/master/centos7/.config.tar.gz
tar -vzxf .config.tar.gz && cp -rf .config /etc/skel/
mkdir /etc/xdg/xfce4/kiosk
cat << "EOF">>  /etc/xdg/xfce4/kiosk/kioskrc
[xfce4-session]
SaveSession=NONE
EOF
#
# Habilitando o NTP e desabilitando serviços desnecessários
# 
systemctl disable lvm2-lvpolld.socket lvm2-lvmetad.socket lvm2-monitor.service
systemctl enable ntpd 
#
# Instalando Kernel LTS mais recente e ajustando o GRUB
#
yum --enablerepo=elrepo-kernel install -y kernel-lt
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub
sed -i 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
#
# Limpando histórico do Shell e reiniciando
#
cat /dev/null > ~/.bash_history && history -c && reboot
