#!/bin/bash

chsh -s /bin/bash

if [ $(id -u) -eq 0 ]; then
    cp -a bash/* /root/
else
    cp -a bash/* /home/${USER}/.bashrc
fi
echo "Shell setting installed and changed successfully"
