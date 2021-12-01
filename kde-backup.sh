#!/bin/bash
name=kde
cp -r ${HOME}/.config/kitty ${PWD}/dotfiles/
konsave -s ${name}
konsave -e ${name}
mv ${HOME}/${name}.knsv ${PWD}/
