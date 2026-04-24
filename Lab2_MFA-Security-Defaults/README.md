# Lab 2 — MFA Implementation & Security Defaults

## Business Scenario

Following a phishing incident that compromised two employee accounts, leadership has mandated that all users must authenticate with Multi-Factor Authentication. As the IAM engineer, you are responsible for evaluating the organization’s current MFA posture, selecting the appropriate enforcement method, and rolling out MFA in a way that minimizes disruption while maximizing security coverage.

-----

## Objective

Implement Multi-Factor Authentication across the tenant using both Security Defaults and per-user MFA enforcement. Evaluate tradeoffs between Security Defaults, per-user MFA, and Conditional Access-based MFA (foundation for Lab 7).

-----

## Tools Used

- Microsoft Entra ID Portal
- Microsoft 365 Admin Center
- Microsoft Authenticator App (end-user verification)
- PowerShell + Microsoft Graph PowerShell SDK

-----

## What Was Configured

- Reviewed and documented the tenant’s default MFA state
- Enabled Security Defaults and tested behavior across user accounts
- Disabled Security Defaults and transitioned to per-user MFA enforcement
- Configured MFA registration policy requiring users to register on next sign-in
- Verified MFA challenge behavior for both admin and standard accounts
- Documented when to use Security Defaults vs. Conditional Access MFA

-----

## Steps

### 1. Assess Current MFA State

```powershell
Connect-MgGraph -Scopes "Policy.Read.All", "UserAuthenticationMethod.Read.All"

# Check Security Defaults status
Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy | 
  Select-Object IsEnabled
```

### 2. Enable Security Defaults (Portal)

- Navigated to **Entra ID > Properties > Manage Security Defaults**
- Toggled Security Defaults **On**
- Documented what Security Defaults enforces:
  - Requires MFA registration for all users
  - Requires MFA for all admin accounts on every sign-in
  - Blocks legacy authentication protocols
  - Requires MFA when necessary (risk-based)

### 3. Transition to Per-User MFA

- Disabled Security Defaults (prerequisite for Conditional Access in Lab 7)
- Navigated to **Microsoft 365 Admin Center > Users > Multi-Factor Authentication**
- Set MFA state to **Enabled** then **Enforced** for test users
- Verified MFA registration prompt on next sign-in

### 4. Configure MFA Registration Policy

- Navigated to **Entra ID > Protection > Authentication Methods > Registration Campaign**
- Set registration campaign targeting all users
- Configured 14-day grace period for existing users

### 5. Verify MFA Enforcement

```powershell
# Check authentication methods registered for a user
Get-MgUserAuthenticationMethod -UserId "user@domain.onmicrosoft.com"
```

-----

## Outcome / Verification

- All admin accounts requiring MFA on every sign-in
- Standard users prompted to register MFA on next sign-in
- Sign-in logs in **Entra ID > Monitoring > Sign-in logs** showing MFA success/failure events
- Legacy authentication protocols blocked at tenant level

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                 |
|----------------------------------------------|--------------------------------------|
|Implement authentication and access management|Plan and implement MFA                |
|Implement authentication and access management|Manage authentication methods         |
|Implement authentication and access management|Configure and manage Security Defaults|

-----

## Key Concepts Demonstrated

- Security Defaults vs. per-user MFA vs. Conditional Access MFA — when to use each
- MFA enforcement states: Disabled → Enabled → Enforced
- Authentication method registration and management
- Legacy authentication as an attack vector and how to block it
