!#/bin/bash
# Gets debian disk
wget https://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2

# Creates proxmox VM
qm create 9000 -name debian-10-template -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1 -cpu cputype=kvm64 -description "Debian 10 cloud image" -kvm 1 -numa 1
qm importdisk 9000 debian-10-openstack-amd64.qcow2 local-lvm
qm set 9000 -scsihw virtio-scsi-pci -virtio0 local-lvm:vm-9000-disk-1
qm set 9000 -serial0 socket
qm set 9000 -boot c -bootdisk virtio0
qm set 9000 -agent 1
qm set 9000 -hotplug disk,network,usb,memory,cpu
qm set 9000 -vcpus 1
qm set 9000 -vga qxl
qm set 9000 -name debian-10-template
qm set 9000 -ide2 local-lvm:cloudinit
qm set 9000 -sshkey /etc/pve/pub_keys/pub_key.pub