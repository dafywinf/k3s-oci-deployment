# VCN: A virtual network that provides connectivity for your cloud resources.
resource "oci_core_vcn" "vcn" {
    cidr_block     = "10.0.0.0/16"
    compartment_id = oci_identity_compartment.k3s-compartment.id
    display_name   = "k3s-vcn"
}

# Services: List of services available in Oracle Services Network.
data "oci_core_services" "services" {
    filter {
        name  = "name"
        values = ["All .* Services In Oracle Services Network"]
        regex = true
    }
}

# Internet Gateway: Allows traffic between the VCN and the internet.
resource "oci_core_internet_gateway" "ig" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    display_name   = "k3s-ig"
    vcn_id         = oci_core_vcn.vcn.id
}

# Service Gateway: Provides access to Oracle Cloud services without using the internet.
resource "oci_core_service_gateway" "sg" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    display_name   = "k3s-sg"
    vcn_id         = oci_core_vcn.vcn.id

    services {
        service_id = data.oci_core_services.services.services[0].id
    }
}

# NAT Gateway: Enables instances in a private subnet to initiate outbound connections to the internet.
resource "oci_core_nat_gateway" "ng" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    display_name   = "k3s-ng"
    vcn_id         = oci_core_vcn.vcn.id
}

# Route Tables: Define how traffic is directed within the network..
resource "oci_core_route_table" "rt-public" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    vcn_id         = oci_core_vcn.vcn.id
    display_name   = "k3s-rt-public"

    route_rules {
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.ig.id
    }
}

resource "oci_core_route_table" "rt-private" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    vcn_id         = oci_core_vcn.vcn.id
    display_name   = "k3s-rt-private"

    route_rules {
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_nat_gateway.ng.id
    }

    route_rules {
        destination = lookup(data.oci_core_services.services.services[0], "cidr_block")
        destination_type  = "SERVICE_CIDR_BLOCK"
        network_entity_id = oci_core_service_gateway.sg.id
        description       = "Terraformed - Auto-generated at Service Gateway creation: All Services in region to Service Gateway"
    }
}


# Security Lists: Act as virtual firewalls for the subnets, controlling ingress and egress traffic.
resource "oci_core_security_list" "sl-public" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    display_name   = "k3s-sl-public"
    vcn_id         = oci_core_vcn.vcn.id

    egress_security_rules {
        stateless        = false
        destination      = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol         = "all"
    }

    ingress_security_rules {
        stateless = false
        source    = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
        protocol  = "6"
        tcp_options {
            min = 22
            max = 22
        }
    }
    ingress_security_rules {
        stateless = false
        source    = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
        protocol  = "1"

        # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
        icmp_options {
            type = 3
            code = 4
        }
    }

    ingress_security_rules {
        stateless = false
        source    = "10.0.0.0/16"
        source_type = "CIDR_BLOCK"
        # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
        protocol  = "1"

        # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
        icmp_options {
            type = 3
        }
    }
}

# https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-vcn/01-summary.htm
resource "oci_core_security_list" "sl-private" {
    compartment_id = oci_identity_compartment.k3s-compartment.id
    display_name   = "k3s-sl-private"
    vcn_id         = oci_core_vcn.vcn.id

    egress_security_rules {
        stateless        = false
        destination      = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol         = "all"
    }

    ingress_security_rules {
        stateless = false
        source    = "10.0.0.0/16"
        source_type = "CIDR_BLOCK"
        # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
        protocol  = "6"
        tcp_options {
            min = 22
            max = 22
        }
    }
    ingress_security_rules {
        stateless = false
        source    = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
        protocol  = "1"

        # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
        icmp_options {
            type = 3
            code = 4
        }
    }

    ingress_security_rules {
        stateless = false
        source    = "10.0.0.0/16"
        source_type = "CIDR_BLOCK"
        # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
        protocol  = "1"

        # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
        icmp_options {
            type = 3
        }
    }


}

# Public Subnet: A subnet that allows public internet connectivity.
resource "oci_core_subnet" "sn-public" {
    compartment_id             = oci_identity_compartment.k3s-compartment.id
    vcn_id                     = oci_core_vcn.vcn.id
    cidr_block                 = "10.0.0.0/24"
    display_name               = "k3s-sn-public"
    route_table_id             = oci_core_route_table.rt-public.id
    security_list_ids = [oci_core_security_list.sl-public.id]
    prohibit_public_ip_on_vnic = false
}

# Private Subnet: A subnet without direct internet connectivity, using NAT and Service Gateways for outbound traffic.
resource "oci_core_subnet" "sn-private" {
    compartment_id            = oci_identity_compartment.k3s-compartment.id
    vcn_id                    = oci_core_vcn.vcn.id
    cidr_block                = "10.0.1.0/24"
    display_name              = "k3s-sn-private"
    route_table_id            = oci_core_route_table.rt-private.id
    security_list_ids = [oci_core_security_list.sl-private.id]
    prohibit_internet_ingress = true
}
