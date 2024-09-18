data oci_identity_availability_domains "ads" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
}

data "oci_core_images" "oracle_linux_8" {
    compartment_id           = var.compartment_id
    operating_system         = "Oracle Linux"
    operating_system_version = "8"
    shape                    = local.default_eks_node_shape["shape"]
    sort_by                  = "TIMECREATED"
}
