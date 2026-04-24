# Lab 8 — Privileged Identity Management (PIM)

## Business Scenario

A security audit revealed that several administrators hold permanently active privileged roles — meaning their elevated access is available 24/7 even when they’re not performing admin tasks. This violates the principle of just-in-time access and creates a standing attack surface. As the IAM engineer, you are tasked with implementing Privileged Identity Management (PIM) to convert permanent role assignments to time-bound, approval-gated, and audited eligible assignments.

-----

## Objective

Implement Microsoft Entra Privileged Identity Management to enforce just-in-time privileged access, require justification and approval for role activation, configure activation limits, and establish an audit trail for all privileged activity.

-----

## Tools Used

- Microsoft Entra ID Portal (Privileged Identity Management)
- Microsoft Entra ID P2 (required for PIM)
- PowerShell + Microsoft Graph PowerShell SDK

-----

## What Was Configured

- Discovered and reviewed all existing permanent role assignments
- Converted permanent assignments to PIM-eligible assignments
- Configured role settings: activation duration, MFA requirement, justification, approval
- Activated an eligible role as a test user and completed the approval workflow
- Reviewed PIM audit history and access reviews

-----

## Steps

### 1. Discover Existing Privileged Assignments

- Navigated to **Entra ID > Privileged Identity Management > Entra ID Roles > Assignments**
- Reviewed **Active Assignments** tab — identified all permanently active privileged roles
- Documented all accounts with permanent Global Administrator, User Administrator, and Security Administrator assignments

### 2. Convert Permanent to Eligible Assignments

- For each over-privileged permanent assignment:
  - Removed permanent active assignment
  - Created new **Eligible** assignment for the same user and role
  - Set eligibility expiration (e.g., 12 months)

### 3. Configure Role Settings

- Navigated to **PIM > Entra ID Roles > Role Settings > [Role Name]**
- Configured settings for Global Administrator:

|Setting                  |Value             |
|-------------------------|------------------|
|Activation duration      |1 hour maximum    |
|Require MFA on activation|Yes               |
|Require justification    |Yes               |
|Require approval         |Yes               |
|Approver                 |Security team lead|

- Configured settings for User Administrator:

|Setting                  |Value                               |
|-------------------------|------------------------------------|
|Activation duration      |4 hours maximum                     |
|Require MFA on activation|Yes                                 |
|Require justification    |Yes                                 |
|Require approval         |No (self-approve with justification)|

### 4. Test Role Activation Workflow

- Signed in as eligible user
- Navigated to **MyRoles** in PIM portal
- Clicked **Activate** on eligible role
- Entered justification: “Processing new hire provisioning for Q2 onboarding batch”
- Completed MFA challenge
- Submitted for approval (Global Admin) or self-activated (User Admin)
- Confirmed role active for configured duration only

### 5. Approve Activation Request (Approver View)

- Signed in as designated approver
- Navigated to **PIM > Approve Requests**
- Reviewed requestor, justification, and role
- Approved request with approver comment

### 6. Review PIM Audit History

```powershell
Connect-MgGraph -Scopes "PrivilegedAccess.Read.AzureAD"

# Get PIM audit events
Get-MgPrivilegedAccessResource -PrivilegedAccessId "aadRoles" |
  Select-Object DisplayName, Type, Status
```

-----

## Outcome / Verification

- Zero permanent active assignments for privileged roles (Global Admin, Security Admin)
- Test activation completed successfully — role active for configured duration, then automatically expired
- Approval workflow tested end-to-end — request submitted, reviewed, approved, role activated
- PIM audit log showing full trail: who requested, what role, justification provided, who approved, activation time
- Role automatically expired at end of configured duration — no manual deactivation required

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                            |
|----------------------------------------------|-------------------------------------------------|
|Implement authentication and access management|Plan and implement Privileged Identity Management|
|Govern access using Microsoft Entra ID        |Manage and monitor privileged access             |

-----

## Key Concepts Demonstrated

- Just-in-time (JIT) access vs. standing privileged access — security posture improvement
- Eligible vs. Active vs. Active (time-bound) assignment types in PIM
- Role activation settings: MFA, justification, approval, duration
- PIM approval workflow as an operational control
- Audit trail as a compliance and incident response tool
- Break-glass account strategy: one permanent Global Admin excluded from PIM as emergency access
