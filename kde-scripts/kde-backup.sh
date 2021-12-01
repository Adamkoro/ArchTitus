#!/bin/bash
name=kde
cp -r ${HOME}/.config/kitty ${PWD}/files/
konsave -s ${name}
konsave -e ${name}
mv ${HOME}/${name}.knsv ${PWD}/
