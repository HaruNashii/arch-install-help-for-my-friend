#!/bin/bash

#add permission for the other scripts be executed
chmod a+x $PWD/arch_install_after_chroot.sh
chmod a+x $PWD/wifi_configuration.sh
chmod a+x $PWD/hyprland_install.sh
chmod a+x $PWD/rice.sh

clear
read -p "What Device Will Be Your Boot Partition? :" bootpartition
#convert the boot partition to FAT32
mkfs.fat -F32 $bootpartition
clear
#convert the swap partition to swap
read -p "What Device Will Be Your Swap? :" swapdevice
mkswap $swapdevice


clear
read -p "What Device Will Be Your Root Partition? :" rootpartition
sleep 1
clear
read -p "What Device Will Be Your Home Partition? :" homepartition
sleep 1
clear


#-add an argument for the while be a loop
x=1
clear 
echo "What Filesystem Format You Will Use For The (Root Partition) And (Home Partition)"
echo "1 = ext4, 2 = btrfs"
read -p "asnwer : " answer
while [ $x -le 2 ]; do

	    case $answer in
	        [1]*)
		    clear
		    #convert the root partitiom in to ext4
		    mkfs.ext4 $rootpartition
		    clear

		    #convert the home partition in to ext4
		    mkfs.ext4 $homepartition
	            break
	            ;;
	        [2]*)
		    clear
		    #convert the root partition in to btrfs
		    mkfs.btrfs -f $rootpartition
		    clear

		    #convert the home partition in to btrfs
		    mkfs.btrfs -f $homepartition
	            break
	            ;;
	        *)
		    echo "Invalid input. Please enter either '1' for (ext4) or '2' for (btrfs)."
		    read -p "asnwer : " answer
	            ;;
	    esac
done


#mount the "/" in /mnt
mount $rootpartition /mnt 

#create the boot folder in the "/" folder
mkdir /mnt/boot
mkdir /mnt/boot/efi

#mount the "boot" in /mnt/boot/efi
mount $bootpartition /mnt/boot/efi

#create the home folder in the "/" folder
mkdir /mnt/home

#mount the "/home" in /mnt
mount $homepartition /mnt/home

#turn on the swap
swapon $swapdevice

clear
echo "check if everything is correctly mounted"
lsblk
sleep 6
clear


#install the base of linux and others useful tools in the /dev/sda3 the root of your system
pacstrap /mnt base linux linux-firmware nano

#generate the config of all your disks
genfstab -U -p /mnt >> /mnt/etc/fstab


clear 
echo "check if the fstab is correct (should have all your partitions [root, boot, home, swap])"
sleep 4
cat /mnt/etc/fstab
sleep 5



clear
echo "moving arch-install-script to mounted devices..."
mkdir /mnt/arch-install-help-for-my-friend
cp -rf $PWD/* /mnt/arch-install-help-for-my-friend/
sleep 1

clear
echo "Done."
echo "Running Chroot..."
echo "Dont forget to run the 'arch_install_after_chroot.sh' script after the chroot"
sleep 2
clear
arch-chroot /mnt

