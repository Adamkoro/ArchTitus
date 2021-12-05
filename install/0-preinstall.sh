#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
#  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
#-------------------------------------------------------------------------
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -Sy
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#Para/Para/' /etc/pacman.conf
pacman -S --noconfirm reflector rsync grub
localectl --no-ask-password set-keymap hu
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo -e "-------------------------------------------------------------------------"
echo -e "   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗"
echo -e "  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝"
echo -e "  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗"
echo -e "  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║"
echo -e "  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║"
echo -e "  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝"
echo -e "-------------------------------------------------------------------------"
echo -e "-Setting up $iso mirrors for faster downloads"
echo -e "-------------------------------------------------------------------------"

reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt


echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk #btrfs-progs

echo "-------------------------------------------------"
echo "-------your keymap is set to HU------------------"
echo "-------------------------------------------------"

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk to work on: (example /dev/sda)"
read DISK
echo "THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK"
read -p "are you sure you want to continue (Y/N):" formatdisk
case $formatdisk in
    
    y|Y|yes|Yes|YES)
        echo "--------------------------------------"
        echo -e "\nFormatting disk...\n$HR"
        echo "--------------------------------------"
        
        # disk prep
        sgdisk -Z ${DISK} # zap all on disk
        sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment
        
        # create partitions
        sgdisk -n 1::+1M --typecode=1:ef02 --change-name=1:'BIOSBOOT' ${DISK} # partition 1 (BIOS Boot Partition)
        sgdisk -n 2::+512M --typecode=2:ef00 --change-name=2:'EFIBOOT' ${DISK} # partition 2 (UEFI Boot Partition)
        sgdisk -n 3::-0 --typecode=3:8e00 --change-name=3:'SYSTEM' ${DISK} # partition 3 (LVM), default start, remaining
        if [[ ! -d "/sys/firmware/efi" ]]; then
            sgdisk -A 1:set:2 ${DISK}
        fi
        
        # make filesystems and LVMs
        echo -e "\nCreating Filesystems...\n$HR"
        LVM_SIZE=32
        VG_NAME="system-vg0"
        ROOT="/dev/mapper/system--vg0-root"
        if [[ ${DISK} =~ "nvme" ]]; then
            mkfs.vfat -F32 -n "EFIBOOT" "${DISK}p2"
            pvcreate "${DISK}p3"
            pvs
            vgcreate ${VG_NAME} "${DISK}p3"
            vgs
            lvcreate -L ${LVM_SIZE}GB ${VG_NAME} -n root
            lvs
            mkfs.xfs -L "Root" ${ROOT} -f
            mount -t xfs ${ROOT} /mnt
        else
            mkfs.vfat -F32 -n "EFIBOOT" "${DISK}2"
            pvcreate "${DISK}3"
            pvs
            vgcreate "${VG_NAME}" "${DISK}3"
            vgs
            lvcreate -L "${LVM_SIZE}GB" ${VG_NAME} -n root
            lvs
            mkfs.xfs -L "Root" ${ROOT} -f
            mount -t xfs ${ROOT} /mnt
        fi
    ;;
    *)
        echo "Rebooting in 3 Seconds ..." && sleep 1
        echo "Rebooting in 2 Seconds ..." && sleep 1
        echo "Rebooting in 1 Second ..." && sleep 1
        reboot now
    ;;
esac

# mount target
mount -t xfs -L Root /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L EFIBOOT /mnt/boot/

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drive is not mounted can not continue"
    echo "Rebooting in 3 Seconds ..." && sleep 1
    echo "Rebooting in 2 Seconds ..." && sleep 1
    echo "Rebooting in 1 Second ..." && sleep 1
    reboot now
fi

echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
cp -R ${SCRIPT_DIR} /mnt/root/ArchTitus
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

echo "--------------------------------------"
echo "--GRUB BIOS Bootloader Install&Check--"
echo "--------------------------------------"
if [[ ! -d "/sys/firmware/efi" ]]; then
    grub-install --boot-directory=/mnt/boot ${DISK}
fi

echo "--------------------------------------"
echo "-- Creating SWAP file               --"
echo "--------------------------------------"
#Put swap into the actual system, not into RAM disk, otherwise there is no point in it, it'll cache RAM into RAM. So, /mnt/ everything.
mkdir /mnt/opt/swap #make a dir that we can apply NOCOW to to make it btrfs-friendly.
#chattr +C /mnt/opt/mnt/opt/swap #apply NOCOW, btrfs needs that.
dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=2048 status=progress
chmod 600 /mnt/opt/swap/swapfile #set permissions.
chown root /mnt/opt/swap/swapfile
mkswap /mnt/opt/swap/swapfile
swapon /mnt/opt/swap/swapfile
#The line below is written to /mnt/ but doesn't contain /mnt/, since it's just / for the sysytem itself.
echo "/opt/swap/swapfile	none	swap	sw	0	0" >> /mnt/etc/fstab #Add swap to fstab, so it KEEPS working after installation.

echo -e "\nDone!\n"
echo "--------------------------------------"
echo "--  SYSTEM READY FOR 1-setup        --"
echo "--------------------------------------"
exit