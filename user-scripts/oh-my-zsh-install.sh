#!/bin/bash

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
zshrc_file=.zshrc
cp ${zshrc_file} "/home/${USER}/${zshrc_file}"
sed -i "s/!!!USER!!!/${USER}/" "/home/${USER}/${zshrc_file}"