#!/bin/bash

bash ./install/0-preinstall.sh
arch-chroot /mnt /root/ArchTitus/install/1-setup.sh
source /mnt/root/ArchTitus/install.conf
arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/install/2-user.sh
#arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/install/kde-restore.sh # Restore KDE settings
arch-chroot /mnt /root/ArchTitus/install/3-post-setup.sh