#!/bin/bash

# Exit on any error
set -e

echo "Starting Lustre client setup DDN/Gaia cluster..."

# 0. SCP copy the exa-client to the target machine
echo "Copying exa-client to /tmp/..."
scp -rp /auto/swgwork2/dazulay/gaia/exa-client /tmp/

# 1. Install Lustre client
echo "Installing Lustre client using exa_client_deploy.py..."
sudo /tmp/exa-client/exa_client_deploy.py -i -y

# 2. Configure lnet
LUSTRE_CONF="/etc/modprobe.d/"
echo "Configuring lnet in $LUSTRE_CONF..."
sudo cp -rp /auto/swgwork2/dazulay/GB200/lustre_install/lustre_gb200.conf $LUSTRE_CONF

# 3. Create mount point
MOUNT_POINT="/mnt/lustre"
echo "Creating mount point at $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT

# 4. Add Lustre mount configuration to /etc/fstab
FSTAB_ENTRY="172.16.2.2@o2ib,172.16.2.3@o2ib:172.16.2.6@o2ib,172.16.2.7@o2ib:172.16.2.4@o2ib,172.16.2.5@o2ib:172.16.2.8@o2ib,172.16.2.9@o2ib:/gb200 $MOUNT_POINT lustre defaults,_netdev,x-systemd.mount,x-systemd.requires=lnet.service 0 0"
echo "Adding Lustre mount configuration to /etc/fstab..."
echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab

# 5. Mount the Lustre filesystem
echo "Mounting Lustre filesystem..."
sudo mount -a

echo "Lustre client setup on Gaia completed successfully."
 
