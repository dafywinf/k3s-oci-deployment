# Bastion : A bastion provides secured, public access to target resources in the cloud that you cannot otherwise reach from the internet.
resource oci_bastion_bastion "bastion" {
    compartment_id   = oci_identity_compartment.k3s-compartment.id
    name             = "k3s-bastion"
    bastion_type     = "STANDARD"
    target_subnet_id = oci_core_subnet.sn-public.id
    client_cidr_block_allow_list = ["0.0.0.0/0"]
}
