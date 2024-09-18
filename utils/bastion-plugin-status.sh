#!/bin/bash

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <instance_ocid> <compartment_ocid>"
    exit 1
fi

COMPARTMENT_OCID=$1
INSTANCE_OCID=$2

# Wait for the instance to be in the 'RUNNING' state
while true; do
    echo "oci instance-agent plugin get --compartment-id $COMPARTMENT_OCID --instanceagent-id $INSTANCE_OCID --plugin-name=Bastion --query \"data.status\" --raw-output"

    PLUGIN_STATUS=$(oci instance-agent plugin get --compartment-id "$COMPARTMENT_OCID" --instanceagent-id "$INSTANCE_OCID" --plugin-name=Bastion --query "data.status" --raw-output )

    echo "Current Bastion Plugin state: $PLUGIN_STATUS"

    if [ "$PLUGIN_STATUS" == "RUNNING" ]; then
        echo "Instance is running."
        break
    fi

    echo "Waiting for Bastion Plugin to start..."
    sleep 10  # Wait 10 seconds before checking again
done

echo "Bastion Plugin is now running."
