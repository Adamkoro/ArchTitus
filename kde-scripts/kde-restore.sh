#!/bin/bash

name=kde
export PATH=${PATH}:~/.local/bin
cp -r ${PWD}/files/* ${HOME}/.config/
pip install konsave
konsave -i ${PWD}/${name}.knsv
sleep 1
konsave -a ${name}
