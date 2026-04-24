# Lab 4 — Enterprise Application Access & SSO Integration

## Business Scenario

The organization is onboarding a new SaaS application and needs to integrate it with Microsoft Entra ID to provide Single Sign-On (SSO) for employees. IT has received requests from three departments wanting access to different applications. As the IAM engineer, you are responsible for registering the enterprise apps, configuring SSO, and ensuring that only authorized users and groups can access each application.

-----

## Objective

Configure enterprise application access in Microsoft Entra ID, implement Single Sign-On, restrict application access to authorized groups, and verify that unauthorized users are correctly denied access.

-----

## Tools Used

- Microsoft Entra ID Portal (Enterprise Applications)
- Microsoft Entra ID App Gallery
- PowerShell + Microsoft Graph PowerShell SDK
- SAML / OIDC SSO configuration

-----

## What Was Configured

- Added applications from the Entra ID App Gallery
- Configured SSO (SAML-based and OIDC-based)
- Enabled user assignment requirement to restrict app access
- Assigned users and groups to applications
- Configured application-level permissions and consent settings
- Verified SSO flow and access denial for unauthorized users

-----

## Steps

### 1. Add Enterprise Application from Gallery

- Navigated to **Entra ID > Enterprise Applications > New Application**
- Searched App Gallery and added test application
- Set application name and confirmed creation

### 2. Configure User Assignment Requirement

- Navigated to application **Properties**
- Set **Assignment Required** to **Yes** — critical step that blocks all users by default until explicitly assigned
- Set **Visible to Users** based on whether the app should appear in MyApps portal

### 3. Configure SSO

- Navigated to **Single Sign-On** blade
- Selected SSO method (SAML or OIDC depending on application)
- For SAML:
  - Configured Entity ID and Reply URL (ACS URL)
  - Downloaded Federation Metadata XML for application-side configuration
  - Set user attribute mappings (email, display name, department)

### 4. Assign Users and Groups

```powershell
Connect-MgGraph -Scopes "AppRoleAssignment.ReadWrite.All", "Group.Read.All"

# Get service principal for the application
$sp = Get-MgServicePrincipal -Filter "DisplayName eq 'AppName'"

# Assign a group to the application
$group = Get-MgGroup -Filter "DisplayName eq 'GroupName'"

New-MgGroupAppRoleAssignment -GroupId $group.Id `
  -PrincipalId $group.Id `
  -ResourceId $sp.Id `
  -AppRoleId "00000000-0000-0000-0000-000000000000"
```

### 5. Verify Access Control

- Signed in as assigned user → SSO successful, application accessible
- Signed in as unassigned user → access denied with “Need approval” or “Not authorized” message
- Confirmed sign-in activity in **Entra ID > Sign-in Logs**

-----

## Outcome / Verification

- Application accessible via MyApps portal (myapps.microsoft.com) for assigned users
- Unassigned users correctly blocked at sign-in
- SSO working — users not prompted for separate application credentials
- Application assignments visible and auditable in Entra ID

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                       |
|----------------------------------------------|--------------------------------------------|
|Implement authentication and access management|Plan and implement SSO                      |
|Plan and implement workload identities        |Manage enterprise applications              |
|Implement access management for applications  |Configure app assignments and access control|

-----

## Key Concepts Demonstrated

- Enterprise app vs. app registration — understanding the distinction
- Assignment Required setting as a critical access control gate
- SAML vs. OIDC SSO — when each is used
- Group-based application assignment for scalable access management
- MyApps portal as the end-user access interface
