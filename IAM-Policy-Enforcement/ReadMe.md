# IAM Policy Enforcement — Access Control Governance Framework

## Business Scenario

After establishing individual IAM controls across the tenant, the organization needs a unified policy enforcement framework that documents, tests, and governs all access control policies in one place. The security and compliance team has requested a formal policy inventory with enforcement status, test results, and remediation notes — the kind of documentation that would be reviewed during an audit or compliance assessment.

-----

## Objective

Document and validate the organization’s complete IAM policy enforcement posture across authentication, access control, privileged access, and identity governance — serving as the master reference for the tenant’s security configuration.

-----

## Tools Used

- Microsoft Entra ID Portal
- Microsoft Secure Score
- PowerShell + Microsoft Graph PowerShell SDK
- Conditional Access What If tool

-----

## Policy Inventory & Enforcement Status

### Authentication Policies

|Policy                                |Status  |Enforcement Method          |Lab Reference|
|--------------------------------------|--------|----------------------------|-------------|
|MFA for all users                     |Enforced|Conditional Access          |Lab 2, Lab 7 |
|MFA for admins (every sign-in)        |Enforced|Conditional Access          |Lab 7        |
|Block legacy authentication           |Enforced|Conditional Access          |Lab 7        |
|SSPR enabled for users                |Enabled |Authentication Methods      |—            |
|Password protection (banned passwords)|Enabled |Entra ID Password Protection|—            |

### Access Control Policies

|Policy                         |Status  |Enforcement Method       |Lab Reference|
|-------------------------------|--------|-------------------------|-------------|
|RBAC least privilege           |Enforced|Entra ID Role Assignments|Lab 1        |
|Application assignment required|Enforced|Enterprise App Settings  |Lab 4        |
|Group-based access control     |Enforced|Dynamic/Assigned Groups  |Lab 1        |
|No standing privileged access  |Enforced|PIM Eligible Assignments |Lab 8        |

### Identity Lifecycle Policies

|Policy                                   |Status   |Enforcement Method      |Lab Reference|
|-----------------------------------------|---------|------------------------|-------------|
|Automated onboarding (Joiner)            |Automated|Azure Automation Runbook|Lab 10       |
|Automated transfer (Mover)               |Automated|Azure Automation Runbook|Lab 10       |
|Automated offboarding (Leaver)           |Automated|Azure Automation Runbook|Lab 9, Lab 10|
|30-day account retention post-termination|Policy   |Documented SOP          |Lab 5        |

-----

## Policy Validation Scripts

### Validate No Permanent Privileged Assignments

```powershell
Connect-MgGraph -Scopes "RoleManagement.Read.Directory"

# Get all active (permanent) role assignments - should only show break-glass
$activeAssignments = Get-MgRoleManagementDirectoryRoleAssignment -All

Write-Output "=== PERMANENT ACTIVE ROLE ASSIGNMENTS ==="
foreach ($assignment in $activeAssignments) {
    $user = Get-MgUser -UserId $assignment.PrincipalId -ErrorAction SilentlyContinue
    $role = Get-MgDirectoryRoleTemplate -DirectoryRoleTemplateId $assignment.RoleDefinitionId -ErrorAction SilentlyContinue
    Write-Output "User: $($user.UserPrincipalName) | Role: $($role.DisplayName)"
}
```

### Validate No Accounts with Excessive Permissions

```powershell
# Get all Global Administrators
$globalAdminRole = Get-MgDirectoryRole | Where-Object {$_.DisplayName -eq "Global Administrator"}
$globalAdmins = Get-MgDirectoryRoleMember -DirectoryRoleId $globalAdminRole.Id

Write-Output "=== GLOBAL ADMINISTRATORS ($($globalAdmins.Count) total) ==="
$globalAdmins | ForEach-Object {
    $user = Get-MgUser -UserId $_.Id -ErrorAction SilentlyContinue
    Write-Output $user.UserPrincipalName
}

# Flag if more than 2 permanent Global Admins (break-glass + one)
if ($globalAdmins.Count -gt 2) {
    Write-Warning "ALERT: $($globalAdmins.Count) permanent Global Admins detected. Review required."
}
```

### Validate Conditional Access Coverage

```powershell
Connect-MgGraph -Scopes "Policy.Read.All"

$caPolicies = Get-MgIdentityConditionalAccessPolicy -All

Write-Output "=== CONDITIONAL ACCESS POLICIES ==="
foreach ($policy in $caPolicies) {
    Write-Output "Name: $($policy.DisplayName) | State: $($policy.State)"
}

# Check for legacy auth block policy
$legacyBlock = $caPolicies | Where-Object { $_.DisplayName -like "*legacy*" -and $_.State -eq "enabled" }
if ($legacyBlock) {
    Write-Output "✓ Legacy authentication block policy: ACTIVE"
} else {
    Write-Warning "✗ No active legacy authentication block policy found"
}
```

-----

## Microsoft Secure Score Assessment

|Category                       |Score Impact|Status  |
|-------------------------------|------------|--------|
|Require MFA for admins         |High        |Complete|
|Block legacy authentication    |High        |Complete|
|Enable PIM for privileged roles|High        |Complete|
|Enable SSPR                    |Medium      |Complete|
|Enable Identity Protection     |Medium      |Complete|
|Enable sign-in risk policies   |Medium      |Complete|

-----

## Audit Readiness Checklist

- [ ] All role assignments documented with business justification
- [ ] Conditional Access policies reviewed and tested quarterly
- [ ] PIM activation logs reviewed monthly
- [ ] No permanent Global Admin accounts except break-glass
- [ ] Break-glass account credentials stored securely (sealed envelope or vault)
- [ ] Break-glass account monitored with alert on any sign-in
- [ ] Offboarding runbook tested monthly with simulated leaver
- [ ] Audit log export configured and retention verified

-----

## SC-300 Exam Alignment

|Domain                                 |Topic                                               |
|---------------------------------------|----------------------------------------------------|
|Monitor and maintain Microsoft Entra ID|Monitor identity posture with Microsoft Secure Score|
|Govern access using Microsoft Entra ID |Implement and manage access governance              |

-----

## Key Concepts Demonstrated

- Policy inventory as a living governance document
- Validation scripts as automated compliance checks
- Microsoft Secure Score as a continuous posture benchmark
- Break-glass account strategy and monitoring
- Audit readiness as an operational discipline, not a one-time event
