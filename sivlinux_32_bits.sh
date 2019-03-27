#!/bin/bash

#ATUALIZAÇÃO DO SISTEMA

apt update &&  apt upgrade -y

#INSTALAÇÃO DOS PACOTES NECESSÁRIOS

apt install curl firefox gcc git htop iperf iptraf links make nmap openssh-server p7zip rar screen traceroute ttf-mscorefonts-installer unrar vlc x11vnc xrdp zsh -y

#REMOVENDO SERVIÇOS DESNECESSÁRIOS

apt purge snapd -y
systemctl disable apparmor bluetooth cups ModemManager ufw unattended-upgrades apt-daily-upgrade.timer apt-daily.timer lvm2-monitor pppd-dns spice-vdagent spice-vdagentd avahi-daemon lvm2-lvmetad lvm2-lvmpolld 

#CONFIGURANDO O VNC SERVER

x11vnc -storepasswd @adminSD /etc/x11vnc.pass &&  chmod 744 /etc/x11vnc.pass
cat << "EOF">> /lib/systemd/system/x11vnc.service 
[Unit]
Description=Iniciar VNC durante o boot
After=multi-user.target
#
[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth
/etc/x11vnc.pass -rfbport 5900 -shared
#
[Install]
WantedBy=multi-user.target
EOF
systemctl enable x11vnc.service &&  systemctl daemon-reload

#INSTALANDO O ORACLE JAVA

wget http://javadl.oracle.com/webapps/download/AutoDL?BundleId=234462_96a7b8442fe848ef90c96a2fad6ed6d1 -O jre-linux-32bits.tar.gz
mkdir /usr/lib/jvm
tar zxvf jre-linux-32bits.tar.gz -C /usr/lib/jvm
mv /usr/lib/jvm/jre*/ /usr/lib/jvm/jre
ln -s /usr/lib/jvm/jre /usr/lib/jvm/java-oracle
cp -a /etc/profile /etc/profile.original
cat << "EOF">> /etc/profile 
JAVA_HOME=/usr/lib/jvm/java-oracle/
PATH=$JAVA_HOME/bin:$PATH export PATH JAVA_HOME
CLASSPATH=$JAVA_HOME/lib/tools.jar
CLASSPATH=.:$CLASSPATH
export  JAVA_HOME  PATH  CLASSPATH
EOF

#AJUSTES ADICIONAIS

mkdir /etc/xdg/xfce4/kiosk
cat << "EOF">>  /etc/xdg/xfce4/kiosk/kioskrc
[xfce4-session]
SaveSession=NONE
EOF

#CONFIGURANDO O GRUB

sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX=net.ifnames=0 biosdevname=0/' /etc/default/grub

#RECONFINGURANDO O ARQUIVO GRUB E REINICIANDO O SISTEMA

grub-mkconfig -o /boot/grub/grub.cfg 
cat /dev/null > ~/.bash_history && history -c && exit && sudo reboot