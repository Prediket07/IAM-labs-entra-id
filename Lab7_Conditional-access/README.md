# Lab 7 — Conditional Access Policy Design & Enforcement

## Business Scenario

The organization’s security team has determined that flat MFA enforcement is insufficient. Users signing in from managed corporate devices on the internal network should have a streamlined experience, while sign-ins from personal devices, foreign locations, or high-risk scenarios should face additional friction or be blocked outright. As the IAM engineer, you are tasked with designing a Conditional Access policy framework that enforces context-aware access decisions.

-----

## Objective

Design, implement, and test a suite of Conditional Access policies that enforce MFA, device compliance, location-based access controls, and block legacy authentication — replacing blunt Security Defaults with granular, context-aware policy enforcement.

-----

## Tools Used

- Microsoft Entra ID Portal (Conditional Access)
- Microsoft Entra ID Named Locations
- Conditional Access What If tool
- PowerShell + Microsoft Graph PowerShell SDK

-----

## Policies Implemented

|Policy                         |Condition               |Control                                  |
|-------------------------------|------------------------|-----------------------------------------|
|Require MFA for All Users      |Any location, any device|Require MFA                              |
|Require MFA for Admins (Always)|Admin roles             |Require MFA every sign-in                |
|Block Legacy Authentication    |Legacy auth clients     |Block                                    |
|Require Compliant Device       |Outside trusted location|Require compliant or hybrid joined device|
|Block High-Risk Sign-Ins       |Sign-in risk: High      |Block access                             |
|MFA for Risky Sign-Ins         |Sign-in risk: Medium    |Require MFA                              |

-----

## Steps

### 1. Configure Named Locations (Trusted IPs)

- Navigated to **Entra ID > Security > Conditional Access > Named Locations**
- Created IP-based named location for trusted corporate network range
- Marked as **Trusted Location** — used as condition in device compliance policy

### 2. Create: Require MFA for All Users

- **Users:** All users (excluding break-glass account)
- **Cloud Apps:** All cloud apps
- **Conditions:** None (applies everywhere)
- **Grant:** Require MFA
- **State:** Report-only first, then On

### 3. Create: Block Legacy Authentication

- **Users:** All users
- **Cloud Apps:** All cloud apps
- **Conditions:** Client apps = Exchange ActiveSync, Other clients
- **Grant:** Block
- **State:** On

```powershell
# Verify legacy auth attempts in Sign-In Logs
Connect-MgGraph -Scopes "AuditLog.Read.All"

Get-MgAuditLogSignIn -Filter "clientAppUsed eq 'Exchange ActiveSync' or clientAppUsed eq 'Other clients'" |
  Select-Object CreatedDateTime, UserDisplayName, ClientAppUsed, Status
```

### 4. Create: Block High-Risk Sign-Ins

- **Users:** All users
- **Cloud Apps:** All cloud apps
- **Conditions:** Sign-in risk level = High
- **Grant:** Block access
- **State:** On
- *Note: Requires Entra ID P2 license*

### 5. Test Policies with What If Tool

- Navigated to **Conditional Access > What If**
- Simulated sign-in scenarios:
  - Standard user, MFA-registered → Policy: MFA required and satisfied ✓
  - Admin user → Policy: MFA required every sign-in ✓
  - Legacy client (EAS) → Policy: Blocked ✓
  - High-risk sign-in simulation → Policy: Blocked ✓

### 6. Review Policy Impact in Sign-In Logs

- Navigated to **Sign-In Logs**
- Reviewed **Conditional Access** tab per sign-in event
- Confirmed policy names, applied controls, and success/failure status

-----

## Outcome / Verification

- All policies tested via What If tool before moving to Report-only, then enforced
- Sign-in logs showing Conditional Access policy names applied per sign-in
- Legacy authentication attempts blocked — confirmed via sign-in log filter
- Zero high-risk sign-ins allowed through — blocked at policy level
- Break-glass admin account excluded from all policies and access tested

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                |
|----------------------------------------------|-------------------------------------|
|Implement authentication and access management|Plan and implement Conditional Access|
|Implement authentication and access management|Implement controls for sign-in risk  |
|Implement authentication and access management|Block legacy authentication          |

-----

## Key Concepts Demonstrated

- Report-only mode as a safe deployment practice before enforcement
- Named Locations as a Conditional Access condition
- Break-glass account exclusion — critical operational requirement
- What If tool for pre-enforcement policy validation
- Sign-in risk vs. user risk — different conditions, different responses
- Legacy authentication as one of the highest-impact attack vectors to close
