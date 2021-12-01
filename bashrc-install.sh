#!/bin/bash

chsh -s /bin/bash

if [ $(id -u) -eq 0 ];
then
    sudo cp root-bashrc /root/.bashrc
else
    cp user-bashrc /root/.bashrc
fi
echo "Shell changed and installed successfully"