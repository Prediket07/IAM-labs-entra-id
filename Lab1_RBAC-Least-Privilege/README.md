# Lab 1 — RBAC & Least Privilege Access

## Business Scenario

A mid-size organization has been operating with too many users holding Global Administrator rights — a common security risk identified during an internal audit. As the IAM engineer, you are tasked with implementing Role-Based Access Control (RBAC) using the principle of least privilege. Each user should have only the permissions required to perform their specific job function, and no more.

-----

## Objective

Implement Role-Based Access Control in Microsoft Entra ID by assigning built-in roles at the appropriate scope, removing excessive permissions, and verifying that users can perform their required tasks without over-privileged access.

-----

## Tools Used

- Microsoft Entra ID Portal
- Azure Portal (for Azure RBAC scope)
- PowerShell + Microsoft Graph PowerShell SDK

-----

## What Was Configured

- Reviewed existing role assignments and identified over-privileged accounts
- Assigned scoped Entra ID built-in roles (User Administrator, Helpdesk Administrator, Security Reader)
- Demonstrated the difference between Entra ID roles and Azure RBAC roles
- Verified access boundaries — confirmed users could not perform actions outside their assigned role
- Documented role assignment rationale per user

-----

## Steps

### 1. Audit Existing Role Assignments

```powershell
Connect-MgGraph -Scopes "RoleManagement.Read.Directory"

# List all active role assignments
Get-MgRoleManagementDirectoryRoleAssignment -All | 
  Select-Object PrincipalId, RoleDefinitionId, DirectoryScopeId
```

### 2. Assign Least Privilege Roles (Portal)

- Navigated to **Entra ID > Roles and Administrators**
- Assigned roles based on job function:

|User            |Role Assigned               |Justification            |
|----------------|----------------------------|-------------------------|
|Helpdesk User   |Helpdesk Administrator      |Password resets only     |
|HR Admin        |User Administrator          |User lifecycle management|
|Security Analyst|Security Reader             |Read-only security data  |
|IT Manager      |Authentication Administrator|MFA management           |

### 3. Assign Role via PowerShell

```powershell
# Get role definition ID for "User Administrator"
$role = Get-MgDirectoryRole | Where-Object {$_.DisplayName -eq "User Administrator"}

# Assign role to user
$params = @{
    "@odata.type" = "#microsoft.graph.unifiedRoleAssignment"
    RoleDefinitionId = $role.RoleTemplateId
    PrincipalId = "<user-object-id>"
    DirectoryScopeId = "/"
}
New-MgRoleManagementDirectoryRoleAssignment -BodyParameter $params
```

### 4. Verify Access Boundaries

- Signed in as Helpdesk Administrator → confirmed ability to reset passwords, confirmed inability to delete users or modify roles
- Signed in as Security Reader → confirmed read-only access to Identity Protection, confirmed no ability to modify policies

-----

## Outcome / Verification

- Zero non-admin users holding Global Administrator rights
- Each user role-tested and confirmed operating within least privilege boundaries
- Role assignments documented and auditable via Entra ID audit logs
- Audit log entry confirmed for each role assignment event

-----

## SC-300 Exam Alignment

|Domain                                    |Topic                           |
|------------------------------------------|--------------------------------|
|Implement identities in Microsoft Entra ID|Manage and assign roles         |
|Plan and implement workload identities    |Apply least privilege principles|

-----

## Key Concepts Demonstrated

- Principle of least privilege in a real organizational context
- Difference between built-in roles and custom roles
- Entra ID roles vs. Azure RBAC roles (directory vs. resource scope)
- PowerShell-based role assignment for repeatable, auditable provisioning
