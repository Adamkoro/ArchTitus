#!/bin/bash

chsh -s /bin/bash

if [ $(id -u) -eq 0 ];
then
    cp root-bashrc /root/.bashrc
else
    cp user-bashrc /home/${USER}/.bashrc
fi
echo "Shell changed and installed successfully"