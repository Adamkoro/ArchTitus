#!/bin/bash

chsh -s /bin/bash

if [ $(id -u) -eq 0 ]; then
    cp -r bash/.* /root/
    cp /usr/share/git/git-prompt.sh /root/
else
    cp -r bash/.* /home/${USER}/
    cp /usr/share/git/git-prompt.sh /home/${USER}/
fi
echo "Shell setting installed and changed successfully"
