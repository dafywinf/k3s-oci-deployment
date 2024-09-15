resource "oci_core_vcn" "vcn" {
    cidr_block     = "10.0.0.0/16"
    compartment_id = var.compartment_id
    display_name   = "k3s-vcn"
}


output "vcn_domain_name" {
    value = oci_core_vcn.vcn.vcn_domain_name
}
