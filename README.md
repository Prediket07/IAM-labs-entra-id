# Identity & Access Management Labs (Microsoft Entra ID)

This repository documents hands-on Identity and Access Management (IAM) labs built using Microsoft Entra ID (Azure AD). The goal of this project is to demonstrate practical IAM engineering skills including identity lifecycle management, RBAC, conditional access, privileged access, monitoring, and automation.

These labs simulate real enterprise IAM workflows and security practices.

---

# Technologies Used

- Microsoft Entra ID
- Azure Automation
- Microsoft Graph
- PowerShell
- Conditional Access
- RBAC
- Identity Lifecycle Management
- Privileged Identity Management
- Identity Monitoring & Auditing

---

# IAM Lab Projects

## Lab 0 – Tenant & User Setup
Configured Entra tenant and created test identities to simulate organizational users.

---

## Lab 1 – RBAC Least Privilege
Implemented role-based access control using the principle of least privilege.

Skills:
- Role assignment
- Permission scoping
- Identity governance

---

## Lab 2 – MFA Security Defaults
Configured MFA security defaults to strengthen identity protection.

Skills:
- Identity protection
- MFA enforcement
- Authentication security

---

## Lab 4 – Enterprise Application Access
Configured SSO and application access management using enterprise applications.

Skills:
- Application access control
- SSO configuration
- User assignment

---

## Lab 5 – Joiner / Mover / Leaver Lifecycle
Simulated identity lifecycle management for onboarding, role changes, and offboarding.

Skills:
- Identity lifecycle
- Access updates
- Role changes

---

## Lab 6 – Identity Monitoring & Audit Logs
Investigated sign-in logs and audit logs to monitor identity activity.

Skills:
- Log analysis
- Identity monitoring
- Security auditing

---

## Lab 7 – Conditional Access
Configured conditional access policies to control access based on security conditions.

Skills:
- Risk-based authentication
- Conditional access
- Identity security

---

## Lab 8 – Privileged Access
Implemented privileged access roles and access governance.

Skills:
- Privileged access management
- Administrative role control
- Least privilege

---

## Lab 9 – Automated User Offboarding
Built an automated offboarding workflow using Azure Automation runbooks and Microsoft Graph.

Automation workflow:

HR Event → Webhook → Azure Automation Runbook → Microsoft Graph → Disable User

Runbook actions:

- Authenticate using Managed Identity
- Locate user account
- Disable account
- Revoke active sessions

Skills demonstrated:

- IAM automation
- Microsoft Graph scripting
- Identity lifecycle automation
- Azure Automation runbooks

---

# Goal of This Repository

To demonstrate real-world IAM engineering concepts and practical identity security workflows using Microsoft Entra ID.

This portfolio is intended to showcase hands-on experience relevant to roles such as:

- Identity & Access Management Analyst
- IAM Engineer
- Cloud Identity Engineer
- Identity Security Engineer
