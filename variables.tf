# OCI Provider Variables
variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "compartment_id" {}


# Kubernetes Cluster Variables
variable "k3s_version" {
    default = "v1.21.4+k3s1"    # Update to desired K3s version
}

variable "k3s_cluster_name" {
    default = "k3s-cluster"    # Update to desired K3s cluster name
}

variable "node_count" {
    default = 3    # Update to desired number of worker nodes
}



