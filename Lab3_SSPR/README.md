# Lab 3 — Self-Service Password Reset (SSPR)

## Business Scenario

The IT helpdesk is receiving an average of 30+ password reset tickets per week, consuming significant time that could be spent on higher-value work. A large portion of these requests come outside business hours, leaving users locked out and unable to work until the next day. Leadership has approved implementing Self-Service Password Reset to allow users to securely reset their own passwords without helpdesk involvement — reducing ticket volume, improving employee productivity, and lowering IT operational costs.

-----

## Objective

Configure and deploy Microsoft Entra ID Self-Service Password Reset, require users to register authentication methods, enforce registration at next sign-in, and verify the end-to-end reset flow works correctly before rollout.

-----

## Tools Used

- Microsoft Entra ID Portal
- Microsoft 365 Admin Center
- PowerShell + Microsoft Graph PowerShell SDK
- SSPR Registration Portal (aka.ms/ssprsetup)
- SSPR Reset Portal (aka.ms/sspr)

-----

## What Was Configured

- Enabled SSPR for a pilot group before tenant-wide rollout
- Configured required authentication methods (number of methods + method types)
- Enforced SSPR registration at next sign-in via registration campaign
- Configured on-premises writeback (documented — requires Entra ID Connect)
- Tested full end-to-end reset flow as a standard user
- Reviewed SSPR usage reports and audit logs

-----

## Steps

### 1. Enable SSPR for Pilot Group

- Navigated to **Entra ID > Protection > Password Reset**
- Set **Self-service password reset enabled** to **Selected**
- Added pilot security group (e.g., `SSPR-Pilot-Users`) rather than enabling for all users immediately
- This staged approach allows testing before full rollout — standard enterprise practice

### 2. Configure Authentication Methods

- Navigated to **Password Reset > Authentication Methods**
- Set **Number of methods required to reset** to **2**
- Enabled the following methods:

|Method                 |Enabled|Notes                           |
|-----------------------|-------|--------------------------------|
|Mobile app notification|Yes    |Microsoft Authenticator         |
|Mobile app code        |Yes    |TOTP code from Authenticator    |
|Email                  |Yes    |External email address          |
|Mobile phone           |Yes    |SMS code                        |
|Security questions     |No     |Weakest method — not recommended|

- Security questions disabled intentionally — answers are often guessable or discoverable via social engineering

### 3. Configure Registration Settings

- Navigated to **Password Reset > Registration**
- Set **Require users to register when signing in** to **Yes**
- Set **Number of days before users are asked to re-confirm their authentication information** to **180**

### 4. Configure Notifications

- Navigated to **Password Reset > Notifications**
- Set **Notify users on password resets** to **Yes** — user receives email confirmation when their password is reset
- Set **Notify all admins when other admins reset their password** to **Yes** — security alert for privileged account resets

### 5. Verify Registration Flow (End User Simulation)

- Signed in as pilot group test user
- Redirected automatically to SSPR registration page
- Registered two authentication methods (Authenticator app + email)
- Confirmed registration complete in **Entra ID > Users > [User] > Authentication Methods**

```powershell
# Verify SSPR registration status for a user
Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All"

Get-MgUserAuthenticationMethod -UserId "testuser@domain.onmicrosoft.com" |
  Select-Object Id, AdditionalProperties
```

### 6. Test End-to-End Password Reset

- Navigated to **aka.ms/sspr** in a private browser window
- Entered UPN of test user
- Completed identity verification using two registered methods
- Set new password
- Confirmed sign-in successful with new password
- Verified reset event in audit logs

### 7. Review SSPR Usage Reports

- Navigated to **Entra ID > Protection > Password Reset > Usage & Insights**
- Reviewed:
  - Registration activity (how many users registered)
  - Reset activity (successful vs. failed resets)
  - Method usage breakdown

```powershell
# Pull SSPR-related audit events
Connect-MgGraph -Scopes "AuditLog.Read.All"

Get-MgAuditLogDirectoryAudit -Filter "category eq 'SelfServicePasswordManagement'" |
  Select-Object ActivityDateTime, ActivityDisplayName, Result, InitiatedBy |
  Sort-Object ActivityDateTime -Descending
```

-----

## Outcome / Verification

- SSPR enabled for pilot group and tested successfully end-to-end
- Test user completed password reset via **aka.ms/sspr** without any helpdesk involvement
- Reset event confirmed in **Entra ID > Audit Logs** under SelfServicePasswordManagement category
- Notifications received by user confirming password change
- Usage report showing registration and reset activity

-----

## Staged Rollout Plan (Enterprise Practice)

|Phase           |Scope                                        |Timeline|
|----------------|---------------------------------------------|--------|
|Phase 1 — Pilot |IT team + volunteers (SSPR-Pilot-Users group)|Week 1-2|
|Phase 2 — Expand|All non-admin users                          |Week 3-4|
|Phase 3 — Full  |Tenant-wide (Selected → All)                 |Week 5  |

Admins always require **phone + email** for SSPR regardless of phase — higher bar for privileged accounts.

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                        |
|----------------------------------------------|---------------------------------------------|
|Implement authentication and access management|Plan and implement SSPR                      |
|Implement authentication and access management|Manage authentication methods                |
|Implement authentication and access management|Monitor and report on authentication activity|

-----

## Key Concepts Demonstrated

- Staged rollout strategy — pilot group before tenant-wide deployment
- Why security questions are disabled — social engineering risk
- Two-method requirement as the security baseline for resets
- SSPR registration enforcement at sign-in vs. manual registration campaigns
- Audit log category for SSPR events: `SelfServicePasswordManagement`
- Admin reset notifications as a security control for privileged account activity
- SSPR as a direct helpdesk cost reduction — measurable business impact
