#!/bin/bash
#
#Definindo a senha do root
#
printf "123\n123\n" | passwd root
#
#Definindo teclado, zona horária e idioma
#
loadkeys br-abnt2
rm /etc/localtime && ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
timedatectl set-ntp true
sed -i 's/#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
export LANG=pt_BR.UTF-8 
#
#Instalando o GRUB
#
pacman -S grub os-prober --noconfirm && grub-install /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg
#
#Configurando mirrorlist
#
wget -q https://raw.githubusercontent.com/marcelobaptista/scripts-linux/master/arch-linux/pacman.conf -O /etc/pacman.conf
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
pacman -Sy
pacman -S reflector --noconfirm
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
#
#Instalando o XORG, interface gráfica XFCE, pacotes multimedia, driver de vídeo e pacotes adicionais
#
pacman -S alsa-{utils,plugins,firmware} a52dec anki arduino audacious cups cups-pdf dialog evince exfat-utils faac faad2 flac flashplugin flatpak-builder ffmpegthumbnailer filezilla firefox firefox-i18n-pt-br gcompris-qt gimp git gnome-disk-utility go guake gvfs-mtp htop iperf file-roller jasper lame libdca libdv libmad libmpeg2 libmtp libreoffice-fresh libreoffice-fresh-pt-br libtheora libvorbis libxv lutris lxdm nautilus nautilus-image-converter python-nautilus networkmanager network-manager-applet nm-connection-editor noto-fonts noto-fonts-extra numix-gtk-theme nfs-utils nmap opera opera-ffmpeg-codecs p7zip pavucontrol pulseaudio pulseaudio-{equalizer,alsa} qbittorrent ristretto rsync screenfetch steam steam-native-runtime sublime-text-nightly supertux system-config-printer traceroute ttf-dejavu ttf-droid ttf-opensans ttf-roboto tuxpaint tuxracer unrar vlc xf86-video-vesa wavpack wine wine-mono winetricks x264 xarchiver xdg-user-dirs xfce4 xfce4-goodies xorg xorg-server xorg-xinit xvidcore zsh --noconfirm
#
#Configurando o shell padrão para ZSH para todos os usuários
#
git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/oh-my-zsh/custom/plugins/
touch /etc/skel/.zshrc
cp /etc/oh-my-zsh/templates/zshrc.zsh-template /etc/skel/.zshrc
mkdir -p /etc/skel/.oh-my-zsh/cache
sed -i 's/export ZSH=$HOME\/.oh-my-zsh/export ZSH=\/etc\/oh-my-zsh/' /etc/skel/.zshrc
sed -i 's/robbyrussell/gianu/' /etc/skel/.zshrc
cp /etc/skel/.zshrc /root/.zshrc && cp /etc/skel/.zshrc $HOME
sed -i 's/SHELL=\/bin\/bash/SHELL=\/bin\/zsh/' /etc/default/useradd
chsh -s /bin/zsh
#
#Configurando conta de usuário e configurando permissão administrativa
#
useradd -m -G sys,lp,network,video,optical,storage,scanner,power,wheel marcelo
printf "123\n123\n" | passwd marcelo
xdg-user-dirs-update
sed -i 's/# %wheel/%wheel/g' /etc/sudoers
#
#Instalando helper YAY e instalando pacotes adicionais
#
git clone https://aur.archlinux.org/yay.git
chmod -R 777 yay
cd yay
makepkg -si --noconfirm
yay -Sy alacarte-xfce cover-thumbnailer-git deezer downgrade etcher ezthumb gitkraken gksu gparted gstreamer0.10-base-plugins gstreamer0.10-base icu52 isomaster jdiskreport jre mtnm multisystem nautilus-admin ncurses5-compat-libs network-manager-applet ntfs-3g ocs-url pamac-aur paper-icon-theme plymouth samsung-unified-driver simplenote-electron-bin spotify ttf-fantasque-sans-mono ttf-ms-fonts ulauncher update-grub vmware-workstation xfce4-panel-profiles xfce4-goodies-meta --noconfirm
cd /home/marcelo && git clone https://github.com/rpallai/flatpak-pt.git
flatpak install flathub org.freedesktop.Platform/x86_64/18.08 --assumeyes
flatpak install flathub org.freedesktop.Sdk/x86_64/18.08 --assumeyes
cd flatpak-pt && wget "https://sourceforge.net/projects/arch-installer/files/Packet Tracer 7.2.1 for Linux 64 bit.tar.gz/download" -O "Packet Tracer 7.2.1 for Linux 64 bit.tar.gz"
flatpak-builder --delete-build-dirs --force-clean --user --install build-dir com.cisco.PacketTracer-72.json
echo "export PT7HOME=~/.local/share/flatpak/app/com.cisco.PacketTracer-72/current/active/files" >> ~/.bashrc
#
#Configurando o gerenciador de login e habilitando SSH e DHCP durante o boot
#
sed -i 's/# session=\/usr\/bin\/startlxde/session=\/usr\/bin\/startxfce4/' /etc/lxdm/lxdm.conf
sed -i 's/# autologin=dgod/autologin=marcelo/' /etc/lxdm/lxdm.conf
sed -i 's/# numlock=0/numlock=1/' /etc/lxdm/lxdm.conf
systemctl enable lxdm ; systemctl enable dhcpcd ; systemctl enable sshd ; systemctl enable NetworkManager
#
#Instalando Kernel LTS"
#
pacman -S linux-lts linux-lts-headers nvidia-340xx-lts --noconfirm; grub-mkconfig -o /boot/grub/grub.cfg
#
#Alterando o idioma da interface"
#
localectl set-locale LANG=pt_BR.UTF-8

cat /dev/null > ~/.bash_history && history -c && exit