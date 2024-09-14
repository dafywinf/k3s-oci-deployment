# Creating an Oracle Cloud Infrastructure (OCI) Account

Oracle Free Tier: Sign up for an [Oracle Cloud Free Tier account](https://www.oracle.com/cloud/free/), which provides
limited access to a range of Oracle Cloud services, including compute, storage, and database services.
Registration: Visit the Oracle Cloud Free Tier page and register using a valid email address. During registration,
you may need to provide credit card information for identity verification, but Oracle offers free credits without any
upfront charges.

ℹ️ When you set up your account you will need to select a home region. You cannot change home region after sign-up and
free tier resources are only available in your home region. Your home region is the geographic location where your
account, identity resources, and primary identity domain will be created. Your home region selection cannot be changed
after this step in the sign-up process. Some cloud services may not be available in all regions. See Regions for service
availability.

💰 You won’t be charged for using OCI Free Tier, however, a credit card is required for identify verification. If you
choose to upgrade your account to Paid tier, you will only be charged for services used over your Always Free limits. If
you don’t upgrade your account to Paid tier, you will continue to have access to Always Free service (according to
Oracle).

❌ During setup I received this error: "Forbidden: The number of requests has been exceeded. Reload the page or retry the
operation. If the problem persists, then contact Oracle Support". This did clear in a few minutes but not a good start (
especially as you have to re-enter some details each time)!

🔑 At this point is worth enabling two-factor authentication (2FA) for your account. This requires the download of the
Oracle Mobile Authenticator app to your phone. This is a good security measure and is required for some services.

## [Always Free Services](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)

Always Free services are part of Oracle Cloud Free Tier. Always Free services are available for an unlimited time.
However, some limitations apply.

* HeatWave
* AMD-based Compute
* Arm-based Ampere A1 Compute
* Block Volume
* Object Storage
* Archive Storage
* Flexible Load Balancer
* Flexible Network Load Balancer
* Site-to-Site VPN
* Autonomous Data Warehouse
* Autonomous Transaction Processing
* Autonomous JSON Database
* NoSQL Database (Phoenix Region only)
* APEX Application Development
* Resource Manager (Terraform)
* Monitoring
* Notifications
* Logging
* Application Performance Monitoring
* Service Connector Hub
* Vault
* Bastions
* Security Advisor
* Virtual Cloud Networks
* Site-to-Site VPN
* Content Management Starter Edition
* Email Delivery

### Compute Available Shapes for Free Tier

* Micro instances (AMD processor): All tenancies get up to two Always Free VM instances using the VM.Standard.E2.1.Micro
  shape, which has an AMD processor.
* OCI Ampere A1 Compute instances (Arm processor): All tenancies get the first 3,000 OCPU hours and 18,000 GB hours per
  month for free for VM instances using the VM.Standard.A1.Flex shape, which has an Arm processor. For Always Free
  tenancies, this is equivalent to 4 OCPUs and 24 GB of memory.

In regions with multiple availability domains:

* You can create OCI Ampere A1 Compute instances in any availability domain.
* Instances using the VM.Standard.E2.1.Micro shape can only be created in one availability domain.

ℹ️ If you receive an "out of host capacity" error when trying to create a Compute instance, this indicates a temporary
lack
of Always Free shapes in your home region. Try creating the instance in a different availability domain, or wait a
while, then try to create the instance again. You can also choose to upgrade your account to Pay as You Go or another
Paid account type, which gives you access to more types of Compute resources. Remember that Oracle doesn't charge for
Always Free resources after you upgrade, and will only charge you for resource usage above the Always Free limits. You
can use compartment quotas to control resource consumption within your account.
