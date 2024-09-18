# OCI Provider Variables
variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "compartment_id" {}
variable "instance_ssh_public_key" {}
variable "bastion_ssh_public_key" {}

variable "a1_node_config" {
    type = map(string)
    default = {
        "shape"         = "VM.Standard.A1.Flex"
        "ocpus"         = "1"
        "memory_in_gbs" = "6"
    }
}

variable "e2_node_config" {
    type = map(string)
    default = {
        "shape"         = "VM.Standard.E2.1.Micro"
        "ocpus"         = "1"
        "memory_in_gbs" = "1"
    }
}

variable "e4_node_config" {
    type = map(string)
    default = {
        "shape"         = "VM.Standard.E4.Flex"
        "ocpus"         = "1"
        "memory_in_gbs" = "1"
    }
}

variable "e5_node_config" {
    type = map(string)
    default = {
        "shape"         = "VM.Standard.E5.Flex"
        "ocpus"         = "1"
        "memory_in_gbs" = "1"
    }
}


# Kubernetes Cluster Variables
variable "k3s_version" {
    default = "v1.21.4+k3s1"    # Update to desired K3s version
}

variable "k3s_cluster_name" {
    default = "k3s-cluster"    # Update to desired K3s cluster name
}

variable "eks_server_count" {
    type    = number
    default = 1    # Update to desired number of server nodes
}

variable "eks_worker_count" {
    type    = number
    default = 0    # Update to desired number of worker nodes
}

variable "instance_type" {
    type    = string
    default = "e5"
}


