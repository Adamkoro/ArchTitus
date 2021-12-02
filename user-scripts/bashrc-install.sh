#!/bin/bash

chsh -s /bin/bash

if [ $(id -u) -eq 0 ]; then
    cp bashrc /root/.bashrc
    cp bash_profile /root/.bash_profile
else
    cp bashrc /home/${USER}/.bashrc
fi
echo "Shell setting installed and changed successfully"