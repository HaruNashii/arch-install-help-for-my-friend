#!/bin/bash

# clear the terminal
clear

#change the system settings of the timezone to (Brazil, Sao Paulo)
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#syncronize the timezone settings with the system
hwclock --systohc

#open the nano editor for you select your system language
nano /etc/locale.gen

#apply the locale.gen config in your system
locale-gen

clear
#ask the name of the user for create the user after
read -p "write the name of the user: " username

clear 
#add permissions for your user to use varios commands and others things
useradd -m -g users -G wheel,storage,power -s /bin/bash $username

clear
#ask for you define one password for your user (*this is very important don't forget it*)
echo "Create the user Password"
passwd $username

clear
#ask for you define one password for the root user *this is very important don't forget it*
echo "Create the Root Password"
passwd

clear
#install the sudo
pacman -Sy --noconfirm sudo

#-add an argument for the while be a loop
x=1
clear
echo "you will use internet via Ethernet or Wi-Fi"
echo "1 = Ethernet, 2 = Wi-Fi"
read -p "asnwer : " answer
while [ $x -le 2 ]; do

	    case $answer in
	        [1]*)
             		pacman -S --noconfirm networkmanager dhcpcd dhcp
             		systemctl enable NetworkManager
             		systemctl enable dhcpcd
	            	break
	            ;;
	        [2]*)
	            	pacman -S --noconfirm iwd dhcpcd dhcp
             		systemctl enable iwd
             		systemctl enable dhcpcd
	            	break
	            ;;
	        *)
		    	echo "Invalid input. Please enter either '1' for (Ethernet) or '2' for (Wi-Fi)."
		    	read -p "asnwer : " answer
	            ;;
	    esac
done

clear
echo "THIS STEP IS VERY IMPORTANT DONT MISS IT"
echo "you need to uncomment the string '%wheel ALL=(ALL:ALL) ALL'"
echo "the nano with the file that you need to change will be open in 7 secs"
sleep 7
nano /etc/sudoers

clear
#download grub the system bootloader
pacman -S --noconfirm grub efibootmgr

clear 
#try to install the grub on your machine using the ufi method
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck

#try to generate the grub config
grub-mkconfig -o /boot/grub/grub.cfg

#uninstall nano, it have no more use
pacman -R --noconfirm nano

#download and install the pipewire, and remove the pulseaudio
sudo pacman -Rdd pulseaudio
sudo pacman -Sy --needed --noconfirm pipewire pipewire-pulse pipewire-alsa wireplumber

#active the pipewire service and exclude the pulseaudio service
systemctl --user daemon-reload
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user mask pulseaudio
systemctl --user --now enable pipewire pipewire-pulse

echo "All Done, Now you can say 'I use Arch BTW' :3"
