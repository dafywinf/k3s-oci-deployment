resource "oci_identity_compartment" "k3s-compartment" {
    compartment_id = var.compartment_id
    name           = "k3s-compartment"
    description    = "Compartment for K3s resources"
    enable_delete  = true
}
