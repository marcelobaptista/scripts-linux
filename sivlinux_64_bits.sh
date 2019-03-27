#!/bin/bash

echo "ATUALIZAÇÃO DO SISTEMA"
echo ""
apt update &&  apt upgrade -y
echo "INSTALAÇÃO DOS PACOTES NECESSÁRIOS"
echo ""
apt-get install curl firefox gcc git htop iperf iptraf links make multitail net-tools nmap openssh-server p7zip rar screen traceroute ttf-mscorefonts-installer unrar vlc x11vnc xrdp -y
echo "REMOVENDO SERVIÇOS DESNECESSÁRIOS"
echo ""
sudo apt purge snapd -y
sudo systemctl disable apparmor bluetooth cups ModemManager ufw unattended-upgrades apt-daily-upgrade.timer apt-daily.timer
echo "CONFIGURANDO O VNC SERVER"
echo ""
x11vnc -storepasswd @adminSD /etc/x11vnc.pass &&  chmod 744 /etc/x11vnc.pass
cat > /lib/systemd/system/x11vnc.service << EOF
[Unit]
Description=Iniciar VNC durante o boot
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth
/etc/x11vnc.pass -rfbport 5900 -shared

[Install]
WantedBy=multi-user.target
EOF
systemctl enable x11vnc.service &&  systemctl daemon-reload
echo "INSTALANDO O ORACLE JAVA"
echo ""
wget http://javadl.oracle.com/webapps/download/AutoDL?BundleId=234464_96a7b8442fe848ef90c96a2fad6ed6d1 -O jre-linux-64bits.tar.gz
mkdir /usr/lib/jvm
tar zxvf jre-linux-64bits.tar.gz -C /usr/lib/jvm
mv /usr/lib/jvm/jre*/ /usr/lib/jvm/jre
ln -s /usr/lib/jvm/jre /usr/lib/jvm/java-oracle
cp -a /etc/profile /etc/profile.original
cat > /etc/profile << EOF
JAVA_HOME=/usr/lib/jvm/java-oracle/
PATH=$JAVA_HOME/bin:$PATH export PATH JAVA_HOME
CLASSPATH=$JAVA_HOME/lib/tools.jar
CLASSPATH=.:$CLASSPATH
export  JAVA_HOME  PATH  CLASSPATH
EOF
echo "CONFIGURANDO O GRUB"
echo ""
sed -i 's/locale=pt_BR/net.ifnames=0 biosdevname=0/' /etc/default/grub
echo ""
echo "RECONFINGURANDO O ARQUIVO GRUB E REINICIANDO O SISTEMA"
grub-mkconfig -o /boot/grub/grub.cfg && sudo reboot



