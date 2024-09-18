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
