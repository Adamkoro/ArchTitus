#! /bin/bash

vm_name=${1}
template_vm="opensuse-template"
template_uuid=$(virsh domuuid "#${template_vm}")
template_disk_size=$(virsh domblkinfo "${template_uuid}" --device vda  --human | cut -d':' -f2 | cut -d'.' -f1 | head -n 1 | sed -e 's/^[ \t]*//')

# PV chooser
pvs --separator ":" | awk -F":" 'NR!=1{print $2}'
echo -n "Enter PV: "; read pv_disk

# Creating vm's LVM
lvcreate -L ${template_disk_size}GB -n ${vm_name} ${pv_disk}

# Get LVM disk data for cloning
template_disk_rename=$(echo "${template_vm}" | sed -e 's/-/--/g')
vm_disk_rename=$(echo "${vm_name}" | sed -e 's/-/--/g')
template_disk=$(ls /dev/mapper/ | grep "${template_disk_rename}")
vm_disk=$(ls /dev/mapper/ | grep "${vm_disk_rename}")

# Cloning from template to new vm
dd if=/dev/mapper/${template_disk} of=/dev/mapper/${vm_disk} bs=4M status=progress

# Dump template config and changing to new vm's setting
virsh dumpxml "#"${template_vm} > "${vm_name}.xml"
sed -i 's/#'"${template_vm}"'/'${vm_name}'/g' "${vm_name}.xml"
sed -i 's/'"${template_disk}"'/'${vm_disk}'/g' "${vm_name}.xml"

# Generate and change uuid
vm_uuid=$(uuidgen -t)
sed -i 's/'"${template_uuid}"'/'${vm_uuid}'/g' "${vm_name}.xml"

# Load cloned vm
virsh define "${vm_name}.xml"

# Cleaning up
rm "${vm_name}.xml"
