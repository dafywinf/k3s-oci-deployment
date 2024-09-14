# hello-world-oci

Proof of Concept (PoC) application for setting up the infrastructure and deploying a Spring Boot application to an
Oracle Cloud Infrastructure (OCI) account.

The application will be hosted on a 4-node Kubernetes cluster (using the K3s variant). Each node will run on one of 4
OCI Ampere A1 Compute instances (ARM processor), with each instance providing 6 GB of memory. Oracle offers 3,000 OCPU
hours and 18,000 GB hours per month for free for VM instances that use the VM.Standard.A1.Flex shape. For Always Free
accounts, this allowance is equivalent to 4 OCPUs and 24 GB of memory.

![OCI Cloud Architecture](/documentation/images/OCI-Cloud-Architecture.drawio.png)

## Pre-requisites: Access to an OCI Account

1. Create an Oracle Cloud Infrastructure (OCI) account ([run-book](documentation/run-books/oci-account-creation.md)).
