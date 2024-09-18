output "k3s-server-details" {
    description = "K3s Server Details"
    value = [
        oci_core_instance.k3s-server.id,
        oci_core_instance.k3s-server.private_ip,
    ]
}

output "bastion-details" {
    description = "Bastion Details"
    value = [
        oci_bastion_bastion.bastion.id,
    ]
}
