#!/bin/bash

# Exit if any command fails or if a variable is unset
set -euo pipefail

# Check if two arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <bastion_ocid> <bastion_private_key> <host_ip> <host_private_key> "
    exit 1
fi

# Assign filenames from arguments
BASTION_OCID=$1
BASTION_PRIVATE_KEY=$2
HOST_IP=$3
HOST_PRIVATE_KEY=$4

# Execute the SSH command
ssh -i "$HOST_PRIVATE_KEY" -o ProxyCommand="ssh -i $BASTION_PRIVATE_KEY -W %h:%p -p 22 $BASTION_OCID" -p 22 opc@"$HOST_IP"
