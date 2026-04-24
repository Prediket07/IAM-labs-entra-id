# Lab 0 — Tenant Setup & User Identity Foundation

## Business Scenario

A company has just acquired a Microsoft 365 tenant and needs to establish its identity foundation before any users can be onboarded. As the IAM engineer, your first responsibility is to configure the tenant structure, create user accounts with appropriate attributes, and verify that the identity baseline is operational before any access policies are applied.

-----

## Objective

Configure a Microsoft Entra ID tenant from scratch, establish the organizational identity structure, and provision user accounts that will serve as the foundation for all subsequent IAM labs.

-----

## Tools Used

- Microsoft Entra ID (Azure AD) Portal
- Microsoft 365 Admin Center
- PowerShell + Microsoft Graph PowerShell SDK

-----

## What Was Configured

- Tenant display name, primary domain, and organizational settings
- Created multiple user accounts with defined attributes (department, job title, usage location)
- Assigned Microsoft 365 licenses to provisioned users
- Verified user principal names (UPNs) and sign-in capability
- Established admin account separation (Global Admin vs. standard user)

-----

## Steps

### 1. Tenant Verification

- Navigated to **Entra ID > Overview** and confirmed tenant ID, primary domain, and license tier
- Documented tenant ID for use across all subsequent labs

### 2. User Provisioning (Portal)

- Created test users with realistic attributes:
  - First/Last Name, Display Name, UPN
  - Department, Job Title, Usage Location (required for license assignment)
- Set initial passwords with “must change at next sign-in” enforced

### 3. License Assignment

- Navigated to **Microsoft 365 Admin Center > Users > Active Users**
- Assigned Microsoft 365 Business Premium licenses to provisioned users
- Verified license propagation in Entra ID

### 4. PowerShell Verification

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All"

# List all provisioned users
Get-MgUser -All | Select-Object DisplayName, UserPrincipalName, AccountEnabled

# Verify license assignment
Get-MgUserLicenseDetail -UserId "user@domain.onmicrosoft.com"
```

-----

## Outcome / Verification

- All test users visible in **Entra ID > Users > All Users**
- Users able to sign in to the Microsoft 365 portal
- Licenses confirmed as assigned and active
- Tenant ready for RBAC, MFA, and policy configuration in subsequent labs

-----

## SC-300 Exam Alignment

|Domain                                    |Topic                          |
|------------------------------------------|-------------------------------|
|Implement identities in Microsoft Entra ID|Create and manage user accounts|
|Implement identities in Microsoft Entra ID|Manage licenses                |

-----

## Key Concepts Demonstrated

- Tenant structure and identity hierarchy
- User attribute requirements for license assignment (usage location)
- Separation of admin and standard user accounts
- PowerShell verification of portal-based configurations
