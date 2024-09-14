# Architectural Decision Record (ADR): Use of Bastion Host for Secure SSH Access to Compute Resources

## Status: Accepted ✅

## Context

In our current cloud infrastructure setup on Oracle Cloud Infrastructure (OCI), we have several compute resources (VM
instances) residing in private subnets that require occasional administrative access via SSH. Directly exposing these
instances to the internet for SSH access introduces significant security risks, including potential unauthorised access,
brute-force attacks, and an expanded attack surface.

To mitigate these risks, we need a secure method to manage SSH access to these instances while minimising exposure to
external threats.

## Decision

We will implement a **bastion host** as the primary mechanism for accessing compute resources (via SSH) within our
private subnets. The bastion host will act as a secure gateway, mediating SSH access to internal instances while keeping
the instances isolated from the public internet.

### Specifics of the Decision

1. **Use OCI Bastion Service**: We will leverage the **OCI Bastion** service, a managed bastion solution provided by
   Oracle Cloud Infrastructure. OCI Bastion will facilitate secure, temporary SSH sessions to instances within the
   private subnet. Additionally, OCI Bastion is part of Oracle's **Always Free** tier, so implementing it will not incur
   additional costs, thereby eliminating any financial impact on the current infrastructure budget.

2. **Access Control**:
    - Only the bastion host will be accessible from the public internet.
    - SSH access to the bastion will be restricted to specific IP addresses (e.g., office IP ranges) using OCI Network
      Security Groups (NSGs) or security lists.
    - All private instances will remain inaccessible directly from the public internet.

3. **Authentication**:
    - SSH access to the bastion host will use key-based authentication to prevent unauthorised access. Password
      authentication will be disabled.
    - Access to private instances via the bastion will also use key-based authentication.

4. **Monitoring and Auditing**:
    - Enable logging and monitoring on the bastion host. OCI Bastion provides audit logs to track access attempts and
      activities.
    - Implement alerting for suspicious activities on the bastion, such as multiple failed login attempts.

5. **Security and Maintenance**:
    - OCI Bastion Service is a managed service, which reduces the maintenance burden (e.g., patching and updating)
      compared to a traditional bastion host.
    - Regular reviews and audits of bastion access policies will be conducted to ensure compliance with security best
      practices.

## Rationale

1. **Enhanced Security**: A bastion host minimises the attack surface by providing a single, secured entry point to
   internal compute resources. This isolates internal instances from direct internet exposure, significantly reducing
   the risk of unauthorised access.
2. **Controlled Access**: By centralising SSH access through the bastion, we can enforce strict access controls and
   auditing, ensuring that only authorised users can connect to private instances.
3. **Reduced Complexity**: Using the OCI Bastion service simplifies bastion host management. It provides a scalable,
   managed solution for securing SSH access, avoiding the need to manually maintain and secure a traditional bastion
   instance.
4. **Cost Efficiency**: Since OCI Bastion is included in Oracle's **Always Free** tier, it introduces no additional
   financial cost. This allows us to enhance our security posture without impacting our budget.
5. **Compliance and Auditing**: The centralised access model with logging capabilities helps meet compliance
   requirements by providing a clear audit trail of access to sensitive resources.

## Alternatives Considered

1. **Direct SSH Access with IP Restrictions**: Allowing SSH access directly to instances with strict IP restrictions.
   This was deemed insufficient due to the increased risk and lack of centralised access control and auditing.
2. **VPN Access**: Using a VPN to provide access to the private subnet. While secure, it introduces additional
   complexity in setup and management compared to using a bastion host.
3. **SSH via Public IPs**: Assigning public IPs to instances for direct SSH access was rejected due to significant
   security risks and increased attack surface.

## Consequences

- **Positive**:
    - Improved security by isolating private instances from direct internet exposure.
    - Centralised access control, allowing for better monitoring and auditing.
    - Reduced maintenance overhead by using the managed OCI Bastion service.
    - No financial impact due to the inclusion of OCI Bastion in Oracle's Free Tier.
- **Negative**:
    - Slight increase in access complexity, as users must connect via the bastion host.
    - Potential single point of failure, mitigated by the reliability of the managed OCI Bastion service.

## Implementation

- Set up and configure the OCI Bastion service in the target VCN.
- Update security rules to restrict SSH access to the bastion and disallow direct SSH access to private instances.
- Configure key-based SSH access and enable logging and monitoring.

**Decision Date**: September 14, 2024

## Appendix

### References

- Oracle Cloud Infrastructure Bastion Service
  Documentation: [OCI Bastion](https://docs.oracle.com/en-us/iaas/Content/Bastion/home.htm)
