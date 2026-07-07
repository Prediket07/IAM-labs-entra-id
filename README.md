# Identity & Access Management Portfolio

### Microsoft Entra ID | Azure Automation | Microsoft Graph | PowerShell

**Jairus Ross** — IAM Engineer  
📍 CompTIA Security+ | SC-300 (In Progress)  
🔗 [LinkedIn](https://www.linkedin.com/in/jairus-ross-5b964a78) | 📧 JairusrossIAM@gmail.com

-----

## About This Repository

This repository documents a structured, hands-on IAM engineering portfolio built in a live Microsoft Entra ID tenant using a Microsoft 365 E5 environment.

Every lab in this repository reflects a real enterprise scenario — not a tutorial exercise. Each one was built around the question: *what would an IAM engineer actually be asked to do on day one?*

The progression moves deliberately from identity foundations through lifecycle management, access governance, authentication protocols, and full automation — mirroring the growth path of an IAM engineer from provisioning specialist to automation architect.

**This portfolio demonstrates:**

- Hands-on experience with Microsoft Entra ID across the full IAM lifecycle
- PowerShell scripting using the Microsoft Graph SDK for repeatable, auditable identity operations
- End-to-end automation of Joiner-Mover-Leaver workflows using Azure Automation and webhooks
- Security-first thinking: least privilege, just-in-time access, session revocation, and policy enforcement
- Deep understanding of modern authentication protocols: OAuth 2.0, OpenID Connect, SAML, WS-Federation
- Emergency access planning and break glass account hardening
- Documentation discipline — every lab written to enterprise standards, not student notes

-----

## Certifications

|Certification                                       |Status       |Issuer   |
|----------------------------------------------------|-------------|---------|
|CompTIA Security+                                   |✅ Earned     |CompTIA  |
|Microsoft SC-300 (Identity and Access Administrator)|🔄 In Progress|Microsoft|

-----

## Lab Overview

### 🔹 Foundation Track — Identity Infrastructure

|Lab                                   |Title                                  |Key Skills                                                 |
|--------------------------------------|---------------------------------------|-----------------------------------------------------------|
|[Lab 0](./Lab0_Tenant-Users/)         |Tenant Setup & User Identity Foundation|Tenant configuration, user provisioning, license assignment|
|[Lab 1](./Lab1_RBAC-Least-Privilege/) |RBAC & Least Privilege Access          |Role assignments, least privilege, Entra ID vs Azure RBAC  |
|[Lab 2](./Lab2_MFA-Security-Defaults/)|MFA Implementation & Security Defaults |MFA enforcement, Security Defaults, authentication methods |
|[Lab 3](./Lab3_SSPR/)                 |Self-Service Password Reset (SSPR)     |SSPR configuration, authentication methods, staged rollout |
|[Lab 4](./Lab4_Enterprise-App-Access/)|Enterprise Application Access & SSO    |SSO (SAML/OIDC), app assignment, access control            |

-----

### 🔹 Lifecycle & Governance Track

|Lab                                 |Title                               |Key Skills                                                   |
|------------------------------------|------------------------------------|-------------------------------------------------------------|
|[Lab 5](./Lab5_Joiner-Mover-Leaver/)|JML Identity Lifecycle (Manual)     |Full JML process, user transitions, deprovisioning           |
|[Lab 6](./Lab6_Monitoring-Audit/)   |Identity Monitoring & Audit Logs    |Audit logs, sign-in analysis, diagnostic settings, log export|
|[Lab 7](./Lab7_Conditional-Access/) |Conditional Access Policy Design    |CA policies, named locations, What If tool, risk-based access|
|[Lab 8](./Lab8_Privileged-Access/)  |Privileged Identity Management (PIM)|JIT access, eligible assignments, approval workflows         |

-----

### 🔹 Automation Track — IAM Engineering

|Lab                                   |Title                       |Key Skills                                                |
|--------------------------------------|----------------------------|----------------------------------------------------------|
|[Lab 9](./Lab9_Automated-Offboarding/)|Automated Offboarding       |Azure Automation, Managed Identity, Graph API, runbooks   |
|[Lab 10](./Lab10_JML-Automation/)     |Full JML Automation System ⭐|Webhook triggers, end-to-end JML automation, JSON payloads|

-----

### 🔹 Identity Governance Track

|Lab                                          |Title                                   |Key Skills                                                                           |
|---------------------------------------------|----------------------------------------|-------------------------------------------------------------------------------------|
|[Lab 11](./Lab11_Entitlement-Management/)    |Entitlement Management & Access Packages|Catalogs, access packages, approval workflows, access reviews                        |
|[Lab 12](./Lab12_Access-Reviews/)            |Access Reviews — Standalone Group Review|Recurring access reviews, auto-apply, decision helpers, compliance enforcement       |
|[Lab 13](./Lab13_Identity-Protection/)       |Identity Protection & Risk Policies     |Sign-in risk, user risk, risk detections, report-only mode                           |
|[Lab 14](./Lab14_App-Registrations/)         |App Registrations & API Permissions     |App registration, delegated vs application permissions, client secrets, admin consent|
|[Policy Framework](./IAM-Policy-Enforcement/)|IAM Policy Enforcement Framework        |Policy inventory, compliance validation, Secure Score                                |

-----

### 🔹 Advanced Identity Track — External Access, Protocols & Security

|Lab                                                |Title                                         |Key Skills                                                                                        |
|---------------------------------------------------|----------------------------------------------|--------------------------------------------------------------------------------------------------|
|[Lab 15](./Lab15_B2B-External-Collaborations/)     |B2B External Collaborations                   |External Collaboration Settings, Connected Organizations, Cross-tenant access, B2B direct connect |
|[Lab 16](./Lab16_Conditional-Access-Named-L.../)   |Conditional Access — Named Locations          |Named locations, trusted IPs, location-based CA policy enforcement                               |
|[Lab 17](./Lab17_PIM-Role-with-MFA-and-App.../)    |PIM Role Activation with MFA & Approval       |PIM eligible roles, activation requirements, MFA on activation, approval workflows               |
|[Lab 18](./Lab18_Access-Package-with-Conne.../)    |Access Package with Connected Organization    |Entitlement Management, Connected Organization, external user access packages                    |
|[Lab 19](./LAB19_OIDC-&-OAuth-2.0-Authentic.../)  |OIDC & OAuth 2.0 Authentication Flows ⭐       |OAuth 2.0, OpenID Connect, Implicit Flow, Authorization Code Flow, JWT token analysis            |
|[Lab 20](./Lab20_Break-Glass-Account-Config.../)   |Break Glass Account Configuration ⭐           |Emergency access accounts, CA exclusions, onmicrosoft.com domain, Identity Protection alerts     |

-----

## Capstone: JML Automation Architecture (Lab 10)

The most advanced lab in this portfolio simulates a production-grade identity automation system triggered by HR workflows:

```
HR System (Workday/SAP simulation)
        │
        ▼
   Webhook (HTTP POST)
        │
        ▼
Azure Automation Runbook
        │
   ┌────┴────┐────────┐
   ▼         ▼        ▼
JOINER    MOVER    LEAVER
   │         │        │
   └────┬────┘────────┘
        ▼
Microsoft Graph API
        │
        ▼
  Microsoft Entra ID
  (User created/updated/disabled,
   licenses assigned/removed,
   groups managed, sessions revoked)
        │
        ▼
  Audit Log + Output Report
```

**What this demonstrates to an employer:**

- Ability to design and build identity automation pipelines, not just run manual tasks
- Understanding of Managed Identity as a secure, credential-free auth pattern
- Microsoft Graph as the single API surface for all Entra ID operations
- Production thinking: error handling, structured logging, JSON schema design

-----

## Featured Labs

### Lab 19 — OIDC & OAuth 2.0 Authentication Flows
End-to-end demonstration of modern authentication protocols in a live Entra ID tenant. Built and executed OIDC Implicit Flow and Authorization Code Flow URLs manually, decoded real JWT ID tokens, analyzed all claims (aud, iss, nonce, email, name, oid, tid), and documented the security rationale behind each flow type. Confirmed CORS enforcement on Step 2 of Authorization Code Flow as proof of the server-side-only token exchange security model.

**Key concepts demonstrated:** OAuth 2.0 vs OIDC, access tokens vs ID tokens, Implicit Flow vs Authorization Code Flow, JWT structure, redirect URI security, client secrets, implicit grant settings.

### Lab 20 — Break Glass Account Configuration
Full emergency access account implementation following Microsoft best practice guidance. Created two cloud-only break glass accounts on the onmicrosoft.com domain, assigned permanent Global Administrator, excluded both from all Conditional Access policies, and configured Identity Protection alerting as a compensating control. Documented the production monitoring gap and operational procedures.

**Key concepts demonstrated:** Emergency access planning, onmicrosoft.com domain rationale, Active vs Eligible PIM assignment, CA exclusion strategy, federation failure scenarios, break glass operational procedures.

-----

## Technologies Used

|Technology                    |Usage                                                      |
|------------------------------|-----------------------------------------------------------|
|Microsoft Entra ID (Azure AD) |Core identity platform across all labs                     |
|Microsoft Graph PowerShell SDK|Scripted identity operations and automation                |
|Azure Automation              |Runbook hosting and execution environment                  |
|Managed Identity              |Secure, credential-free authentication for automation      |
|Webhooks                      |HR system simulation and runbook triggering                |
|PowerShell                    |Primary scripting language throughout                      |
|Microsoft 365 E5              |Live tenant environment for all lab work                   |
|OAuth 2.0 / OpenID Connect    |Modern authentication protocol implementation and analysis |
|JWT (JSON Web Tokens)         |Token structure analysis and claims mapping                |
|SAML / WS-Federation          |Legacy federation protocol understanding and migration     |

-----

## Skills Demonstrated

**Identity Administration**

- User provisioning, attribute management, license assignment
- Group creation and dynamic membership
- Identity lifecycle management (Joiner, Mover, Leaver)
- Break glass account configuration and emergency access planning

**Access Control & Security**

- Role-Based Access Control (RBAC) with least privilege
- Conditional Access policy design and enforcement
- Multi-Factor Authentication implementation
- Privileged Identity Management (PIM) — just-in-time access
- B2B external collaboration and cross-tenant access configuration

**Authentication & Protocols**

- OAuth 2.0 authorization flows (Implicit, Authorization Code)
- OpenID Connect identity layer and JWT token analysis
- SAML and WS-Federation federation protocols
- App registration configuration (redirect URIs, client secrets, permissions)
- Delegated vs application permission models

**Automation & Engineering**

- PowerShell scripting with Microsoft Graph SDK
- Azure Automation runbook development
- Webhook-triggered identity workflows
- Managed Identity configuration and permissions

**Monitoring & Governance**

- Audit log analysis and export
- Sign-in log investigation
- Identity Protection risk policies and alerting
- Diagnostic settings and Log Analytics integration
- IAM policy inventory and compliance validation

-----

## Lab Environment

All labs were performed in a live Microsoft Entra ID tenant (Boclair Industries) with Microsoft 365 E5 licensing. Configurations, scripts, and outputs have been sanitized to remove all tenant-specific identifiers (tenant IDs, object IDs, UPNs) before publication.

-----

## Why IAM Engineering

Identity is the new perimeter. In a cloud-first world, every breach starts with a compromised credential or an over-privileged account. IAM engineers are the people who close those gaps before they become incidents.

My path into IAM comes through Security+ certification, 20 hands-on labs in a live Entra ID tenant, and a deliberate focus on automation — because manually managing identity at enterprise scale isn't sustainable, and the engineers who can automate it are the ones organizations want to keep.

I'm pursuing the SC-300 certification to formalize what I've built in this portfolio, and targeting IAM engineer roles where I can contribute from day one while continuing to grow toward IAM architecture.

-----

*All lab content is original work performed in a personal Microsoft 365 E5 tenant. Scripts are provided for educational and portfolio purposes.*
