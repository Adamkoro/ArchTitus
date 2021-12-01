#!/bin/bash
# This is fix for invalid key at spotify build
# From here: https://aur.archlinux.org/packages/spotify/#comment-838643

#import new key
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -

#delete old one (optional)
gpg --delete-key D1742AD60D811D58

cd ~/git

#clone Repo
git clone https://aur.archlinux.org/spotify.git

#move into git-repo-dir
cd spotify

#update PKGBUILD with new key and new pkgrel
sed -i 's/8FD3D9A8D3800305A9FFF259D1742AD60D811D58/F9A211976ED662F00E59361E5E3C45D7B312C643/;s/pkgrel=1/pkgrel=2/' PKGBUILD

#build and install
makepkg -scCri