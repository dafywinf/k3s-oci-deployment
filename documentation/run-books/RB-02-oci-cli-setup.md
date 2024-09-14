# OCI CLI Setup

## Step 1: Install OCI CLI

For Mac users, you can install the OCI CLI
using [Homebrew](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#InstallingCLI__macos_homebrew).

Verify the installation by running the following command:

```bash
oci --version
```

## Step 2: Configure OCI CLI

Run the following command to configure the OCI CLI:

```bash
oci setup config
```

This will create a configuration file in `~/.oci/config`.

The config file contains essential credentials and identity information needed to authenticate with the OCI services. It
is where you define the core settings for accessing your OCI tenancy, such as user OCID, tenancy OCID, API keys, and the
default region.

Full instructions on how to configure the OCI CLI can be
found [here](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm).

## Step 3: Configure the OCI ClI

The oci_cli_rc file is used for customising the behaviour of the OCI CLI, such as setting default parameters, defining
command aliases, and managing profiles. It provides convenience features that reduce repetitive command options.

The oci CLI can setup the oci_cli_rc file for you. Run the following command:

```bash
oci setup oci-cli-rc
```

More information on the oci_cli_rc file can be
found [here](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliconfigure.htm).
