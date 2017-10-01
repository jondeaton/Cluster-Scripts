#!/bin/bash
timedatectl set-ntp true

mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2

mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab

#something here...

arch-chroot /mnt /bin/bash
echo $(HOSTNAME) > /etc/hostname

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

sed -i "82s/.*/%wheel ALL=(ALL) ALL/" /etc/sudoers.tmp
sed -i "85s/.*/%wheel ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers.tmp
sed -i "82s/.*/%sudo ALL=(ALL) ALL/" /etc/sudoers.tmp


echo "yes" | sudo pacman -S sudo

# Uncomment en_US.UTF-8 UTF-8 and other needed localizations 
# in /etc/locale.gen, and generate them with 
locale-gen


mkinitcpio -p linux

# update passwords
username="jdeaton"
useradd -m -g users -G wheel -s /bin/bash $username

#### 
echo "yes" | sudo pacman -Sy grub
echo "yes" | sudo pacman -Sy efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

grub-mkconfig -o /boot/grub/grub.cfg




# Power Managment

# Into this file:
#/etc/systemd/system/powertop.service
# put the following: Without comment
# [Unit]
# Description=Powertop tunings

# [Service]
# Type=oneshot
# ExecStart=/usr/bin/powertop --auto-tune

# [Install]
# WantedBy=multi-user.target

sudo systemctl enable powertop.service
sudo systemctl start powertop.service


sudo pacman -S gnome-power-manager

sudo pacman -Sy thermald
sudo systemctl enable thermald
sudo systemctl start thermald


sudo pacman -S cpupower
sudo systemctl enable cpupower
sudo systemctl start cpupower



#/etc/exports
#/nfs *(rw,all_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)
/nfs 192.168.0.10(rw,no_root_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)
/nfs 192.168.0.12(rw,no_root_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)
/nfs 192.168.0.13(rw,no_root_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)
/nfs 192.168.0.14(rw,no_root_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)
/nfs 192.168.0.16(rw,no_root_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)

exportfs -a
sudo hostname new-server-name-here


#/etc/nfs.map
gid 100 100
uid 1000 1000

sudo pacman -Sy nfs-utils


# Change uid/gid
usermod -u 2005 foo
groupmod -g 3000 foo

# Deleting user
userdel -r username

# Changing home
vim /etc/passwd


# For no password login

# Server
cd ~/.ssh
ssh-keygen -t rsa
cat id_rsa.pub >> authorized_keys
chmod 600 authorized_keys
rm id_rsa.pub


# Client
cd ~/.ssh
scp myserver.com:~/.ssh/id_rsa myserver.rsa
chmod 600 myserver.rsa
echo "Host myserver" >> config
echo "Hostname reblets.com" >> config
echo "IdentityFile ~/.ssh/myserver.rsa" >> config








