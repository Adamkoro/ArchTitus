#!/bin/bash

chsh -s /bin/bash

if [ $(id -u) -eq 0 ]; then
    cp -r bash/.* /root/
else
    cp -r bash/.* /home/${USER}/
fi
echo "Shell setting installed and changed successfully"
