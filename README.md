# hello-world-oci

Proof of Concept (PoC) application for setting up the infrastructure and deploying a Spring Boot application to an
Oracle Cloud Infrastructure (OCI) account.

The application will be hosted on a 4-node Kubernetes cluster (using the K3s variant). Each node will run on one of 4
OCI Ampere A1 Compute instances (ARM processor), with each instance providing 6 GB of memory. Oracle offers 3,000 OCPU
hours and 18,000 GB hours per month for free for VM instances that use the VM.Standard.A1.Flex shape. For Always Free
accounts, this allowance is equivalent to 4 OCPUs and 24 GB of memory.

![OCI Cloud Architecture](/documentation/images/OCI-Cloud-Architecture.drawio.png)

## Pre-requisites: Access to an OCI Account

1. Create an Oracle Cloud Infrastructure (OCI)
   account ([run-book](documentation/run-books/RB-01-oci-account-creation.md)).
2. Install the OCI CLI ([run-book](documentation/run-books/RB-02-oci-cli-setup.md)).
3. Create a compartment as a logical container for all associated
   resources ([run-book](documentation/run-books/RB-03-create-compartment.md)).

## Steps to Deploy the Application

### Init the OCI Terraform Provider

Run the following command:

```bash
terraform init
```

### Set the Authentication Variables

values.auto.tfvars is a file in Terraform used for setting variable values. Terraform automatically loads variables from
files with names ending in .auto.tfvars or matching the pattern *.auto.tfvars. This makes it easier to manage
configurations by separating variable values into their own file, and it reduces the need to pass variables directly via
the command line or environment variables.

Rename the `values.auto.tfvars.example` file to `values.auto.tfvars` with your OCI credentials and other configuration
settings.

```bash
region               = ""
tenancy_ocid         = ""
user_ocid            = ""
fingerprint          = ""
private_key_path     = ""
private_key_password = ""
compartment_id       = ""
```

Note: The `private_key_password` field is optional and can be left empty if the private key is not password-protected.

Alternatively, you can set these variables as environment variables using the `TF_VAR_` variable naming convention:

```bash
# Mac/Linux
export TF_VAR_region="your-region"
export TF_VAR_tenancy_ocid="your-tenancy-ocid"
export TF_VAR_user_ocid="your-user-ocid"
export TF_VAR_fingerprint="your-fingerprint"
export TF_VAR_private_key_path="/path/to/your/private/key"
export TF_VAR_private_key_password="your-private-key-password"
export TF_VAR_compartment_id="your-compartment-id"

```

### Plan the Terraform Deployment

Run the following command to see what Terraform will do before actually doing it:

```bash
terraform plan
```

### Apply the Terraform Deployment

Run the following command to create the infrastructure:

```bash
terraform apply
```

# Appendix

## Renaming Terraform Resources

Renaming a resource in Terraform can cause Terraform to interpret this change as the removal of the old resource and the
creation of a new one. This behaviour occurs because Terraform tracks resources using the resource_type and
resource_name combination in the state file. When you change the resource_name, Terraform sees it as a completely new
resource, which leads to the following actions during the next terraform apply:

* Destroy the Old Resource: Terraform will destroy the resource with the old name.
* Create the New Resource: Terraform will then create a new resource with the new name.

The terraform state mv command allows you to rename resources in the Terraform state without actually destroying and
recreating them. This command updates the Terraform state file to reflect the new name, so Terraform understands that
the resource is being renamed rather than replaced.

```bash
terraform state mv <resource_type>.<old_resource_name> <resource_type>.<new_resource_name>
```
