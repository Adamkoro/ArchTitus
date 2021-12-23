#!/bin/bash

BRIDGE=br-bond0
BRIDGE_STP=yes
BOND=bond0
BOND_SLAVE0=eno1
BOND_SLAVE1=enp5s0
BOND_MODE=5
IP_ADDRESS=192.168.1.100/24
DNS_SERVERS=1.1.1.1,1.0.0.1
DEFAULT_ROUTE=192.168.1.0/24
DEFAULT_GATEWAY=192.168.1.254

nmcli con add ifname "${BRIDGE}" type bridge con-name "${BRIDGE}"
nmcli con modify "${BRIDGE}" bridge.stp "${BRIDGE_STP}"
nmcli con modify "${BRIDGE}" ipv4.method manual ipv4.address "${IP_ADDRESS}" ipv4.dns "${DNS_SERVERS}" ipv4.routes "${DEFAULT_ROUTE}" ipv4.gateway "${DEFAULT_GATEWAY}" ipv6.method disable
nmcli con up "${BRIDGE}"

nmcli con add type bond ifname "${BOND}" con-name "${BOND}"
nmcli con modify "${BOND}" bond.options mode="${BOND_MODE}"
nmcli con add type ethernet con-name "${BOND}-slave-${BOND_SLAVE0}" ifname "${BOND_SLAVE0}" master "${BOND}"
nmcli con add type ethernet con-name "${BOND}-slave-${BOND_SLAVE1}" ifname "${BOND_SLAVE1}" master "${BOND}"


nmcli con modify "${BOND}" master "${BRIDGE}" slave-type bridge
nmcli con up "${BOND}"
