#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
#  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm

PKGS=(
    'autojump'
    'awesome-terminal-fonts'
    'brave-bin' # Brave Browser
    'dxvk-bin' # DXVK DirectX to Vulcan
    #'github-desktop-bin' # Github Desktop sync
    'mangohud' # Gaming FPS Counter
    'mangohud-common'
    'nerd-fonts-fira-code'
    'noto-fonts-emoji'
    'papirus-icon-theme'
    'lightly-git'
    'plasma-pa'
    'ocs-url' # install packages from websites
    'snapper-gui-git'
    'ttf-droid'
    'ttf-hack'
    'ttf-meslo' # Nerdfont package
    'ttf-roboto'
    #'zoom' # video conferences
    'snap-pac'
    'timeshift'
    'visual-studio-code-bin'
    'firefox'
    'flatpak'
    'update-grub'
    'megasync'
    'remmina'
    'freerdp' #for Remmina rdp connections
    'openvpn'
    'flameshot' #screenshot maker tool
    'base'
    'libreoffice-still'
    'libreoffice-still-hu'
    'transmission-qt'
    'git-completion'
    'teams'
    'kwalletmanager'
    'plymouth' # For add a better boot screen
    'gdm-plymouth' # Plymouth needed
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

name=kde
export PATH=${PATH}:~/.local/bin
cp -r ${PWD}/files/* ${HOME}/.config/
pip install konsave
konsave -i ${PWD}/${name}.knsv
sleep 1
konsave -a ${name}

echo -e "\nDone!\n"
echo "--------------------------------------"
echo "--  SYSTEM READY FOR 3-post-setup   --"
echo "--------------------------------------"
exit
