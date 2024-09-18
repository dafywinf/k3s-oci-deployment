# Bastion : A bastion provides secured, public access to target resources in the cloud that you cannot otherwise reach from the internet.
resource oci_bastion_bastion "bastion" {
    compartment_id   = oci_identity_compartment.k3s-compartment.id
    name             = "k3s-bastion"
    bastion_type     = "STANDARD"
    target_subnet_id = oci_core_subnet.sn-public.id
    client_cidr_block_allow_list = ["0.0.0.0/0"]

}

locals {
    node_configs = {
        "e2" = var.e2_node_config
        "e5" = var.e5_node_config
        "a1" = var.a1_node_config

    }

    default_eks_node_shape = lookup(local.node_configs, var.instance_type, var.a1_node_config)
}

resource oci_core_instance "k3s-server" {
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id      = oci_identity_compartment.k3s-compartment.id
    display_name        = "k3s-server"
    shape               = local.default_eks_node_shape["shape"]

    source_details {
        source_type = "image"
        source_id   = data.oci_core_images.oracle_linux_8.images[0].id
    }

    shape_config {
        ocpus         = local.default_eks_node_shape["ocpus"]
        memory_in_gbs = local.default_eks_node_shape["memory_in_gbs"]
    }

    create_vnic_details {
        subnet_id        = oci_core_subnet.sn-private.id
        assign_public_ip = false
    }

    metadata = {
        ssh_authorized_keys = file(var.instance_ssh_public_key)
    }

    agent_config {
        # Enable the Bastion plugin
        plugins_config {
            desired_state = "ENABLED"
            name          = "Bastion"
        }
    }

}

# Create 4 k3s worker nodes, spread across the availability domains
resource oci_core_instance "k3s-worker" {
    count               = var.eks_worker_count
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[count.index % length(data.oci_identity_availability_domains.ads.availability_domains)].name
    compartment_id      = oci_identity_compartment.k3s-compartment.id
    display_name        = "k3s-worker-${count.index}"
    shape               = local.default_eks_node_shape["shape"]

    source_details {
        source_type = "image"
        source_id   = data.oci_core_images.oracle_linux_8.images[0].id
    }

    shape_config {
        ocpus         = 1
        memory_in_gbs = 6
    }

    create_vnic_details {
        subnet_id        = oci_core_subnet.sn-private.id
        assign_public_ip = false
    }

    metadata = {
        ssh_authorized_keys = sensitive(file(var.instance_ssh_public_key))
    }
}


resource "null_resource" "wait_for_server_bastion_plugin" {
    depends_on = [oci_core_instance.k3s-server]

    provisioner "local-exec" {
        command = <<EOT
            #!/bin/bash

            INSTANCE_OCID="${oci_core_instance.k3s-server.id}"
            COMPARTMENT_OCID="${oci_core_instance.k3s-server.compartment_id}"

            # Wait for the instance to be in the 'RUNNING' state
            while true; do
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
            EOT
        interpreter = ["/bin/bash", "-c"]
    }
}

# Create a Bastion Session to access the target instance
resource "oci_bastion_session" "k3s-server-bastion-session" {
    depends_on = [null_resource.wait_for_server_bastion_plugin]
    count      = var.eks_server_count
    bastion_id = oci_bastion_bastion.bastion.id

    target_resource_details {
        session_type                               = "MANAGED_SSH"
        target_resource_id                         = oci_core_instance.k3s-server.id
        target_resource_operating_system_user_name = "opc"
    }

    key_details {
        public_key_content = file(var.bastion_ssh_public_key)
    }

    display_name = "k3s-server-bastion-session"
}
