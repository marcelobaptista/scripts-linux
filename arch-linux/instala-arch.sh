#!/bin/bash
#Definindo teclado, zona horária e idioma
#
loadkeys br-abnt2
timedatectl set-ntp true
sed -i 's/#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
export LANG=pt_BR.UTF-8 
#
#Criando tabela de partições
#
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << FDISK_CMDS  | fdisk /dev/sda
g      
n      
1      
       
+1M    
n      
2      
       
+550M
n
3

+50G
n
4


t      
1      
4     
t      
2      
83
t
3
83
t
4
83     
w   
FDISK_CMDS
#
#Formatando partições e montando partições
#
mkfs.ext4 /dev/sda2 -L BOOT
mkfs.ext4 /dev/sda3 -L ROOT
mkfs.ext4 /dev/sda4 -L HOME
mount /dev/sda3 /mnt
mkdir /mnt/boot /mnt/home
mount /dev/sda2 /mnt/boot
mount /dev/sda4 /mnt/home
#
#Executando o pacstrap
#
pacstrap /mnt base base-devel openssh wget
#
#Gerando fstab através do genfstab
#
genfstab -U /mnt >> /mnt/etc/fstab
#
#Entrando no arch-root
#
cp arch-chroot.sh /mnt
arch-chroot /mnt bash arch-chroot.sh install;reboot