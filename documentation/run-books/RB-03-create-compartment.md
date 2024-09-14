# Create Compartment

For this demo, we will create a dedicated compartment to store all associated resources. Using a separate compartment
allows us to isolate and manage all the resources for this demo efficiently. This approach enhances organisation, making
it easier to monitor and control access to these resources through compartment-specific policies. It also simplifies the
cleanup process after the demo, as all resources are grouped within a single compartment, allowing for easy
identification and deletion if necessary.

## Steps

### Step 1: Identify the Root Compartment

To get the root compartment ID from the OCI web console, navigate to "Identity & Security" > "Compartments," select the
root compartment (usually named after your tenancy), and copy the OCID displayed.

### Step 2: Create the new Compartment

```bash
oci iam compartment create --compartment-id <ROOT_COMPARTMENT_ID> --name oci-hello-world --description "OCI Hello World"

# Expected result
{
  "data": {
    "compartment-id": "ocid1.tenancy.oc1..aaaaaaaaXXXXXX",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/XXXXXXX",
        "CreatedOn": "2024-09-14T18:17:15.494Z"
      }
    },
    "description": "OCI Hello World",
    "freeform-tags": {},
    "id": "ocid1.compartment.oc1..aaaaaaaaXXXXX",
    "inactive-status": null,
    "is-accessible": true,
    "lifecycle-state": "ACTIVE",
    "name": "oci-hello-world",
    "time-created": "2024-09-14T18:17:15.547000+00:00"
  },
  "etag": "14390c4f4ebXXXXXXX"
}
```

### Step 3: Set Compartment as default in the oci_cli_rc Config File

You can set defaults such as compartment-id in the oci_cli_rc file to avoid the need for --compartment-id on all
commands. Retrieve the compartment id from the last command and add the following lines to the oci_cli_rc file:

```bash
[DEFAULT]
compartment-id=ocid1.compartment.oc1..aaaaaaaape4XXXXXXXXX.....
```


