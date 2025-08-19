#!/bin/bash

# Define the interfaces to check
INTERFACE_1="enP6p3s0f0np0"
INTERFACE_2="enP22p3s0f0np0"

# Function to check if an interface is up and has an IP
is_interface_up() {
    local iface="$1"
    ip link show "$iface" | grep -q "UP" && ip -4 addr show "$iface" | grep -q "inet"
}

echo "Checking interfaces: $INTERFACE_1 and $INTERFACE_2..."

# Infinite loop to monitor interfaces
while true; do
    if is_interface_up "$INTERFACE_1" && is_interface_up "$INTERFACE_2"; then
        echo "Both interfaces are up and have an IP. Proceeding with commands..."
        sleep 120
        
        echo "Restarting lnet.service..."
        systemctl restart lnet.service
        
        echo "Unloading Lustre modules..."
        lustre_rmmod
        
        echo "Reloading Lustre modules..."
        modprobe lustre
        
        echo "Mounting all Lustre file systems..."
        mount -a
        
        echo "Script execution completed."
        exit 0
    fi

    echo "Waiting for interfaces to be up and assigned an IP..."
    sleep 10
done

