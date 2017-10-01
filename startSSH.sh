#!/bin/bash

dhcpcd # Setup internet connection
sleep 5 # takes a moment to get an ip

# Update and aquire packages for ssh server
echo "yes" | pacman -Sy openssl
echo "yes" | pacman -Sy openssh

# Add a user to ssh as and set passwords
username="jdeaton"
PASS="wefwefwefwefwef"
useradd -m -g users -G wheel -s /bin/bash $username
echo -e "$PASS\n$PASS" | passwd $username

ROOTPASS="wefwef"
echo -e "$ROOTPASS\n$ROOTPASS" | passwd

# Allow that user to login
sed -i "37s/.*/AllowUsers "$username"/" /etc/ssh/sshd_config

# Start SSH Daemon
systemctl start sshd