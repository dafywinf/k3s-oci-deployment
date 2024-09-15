terraform {
    required_version = ">= 0.13"
    required_providers {
        oci = {
            source = "hashicorp/oci"
        }
    }
}


# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformconfig.htm#terraformconfig_topic_Configuration_File_Requirements_Provider
# https://registry.terraform.io/providers/hashicorp/oci/4.0.0/docs#tenancy_ocid
provider "oci" {
    region               = var.region
    tenancy_ocid         = var.tenancy_ocid
    user_ocid            = var.user_ocid
    fingerprint          = var.fingerprint
    private_key_path     = var.private_key_path
    private_key_password = var.private_key_password
}

resource "oci_identity_compartment" "k3s-compartment" {
    compartment_id = var.compartment_id
    name           = "k3s-compartment"
    description    = "Compartment for K3s resources"
    enable_delete  = true
}
