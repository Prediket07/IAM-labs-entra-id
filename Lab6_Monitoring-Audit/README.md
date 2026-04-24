# Lab 6 — Identity Monitoring, Audit Logs & Sign-In Analysis

## Business Scenario

The security team has flagged unusual sign-in activity and requested that the IAM engineer establish a monitoring baseline for the tenant. Leadership also needs to demonstrate compliance — showing that all identity changes are logged and reviewable. As the IAM engineer, you are responsible for configuring audit log retention, reviewing sign-in anomalies, and building a repeatable process for identity monitoring.

-----

## Objective

Configure and utilize Microsoft Entra ID monitoring capabilities including Audit Logs, Sign-In Logs, and Identity-related reporting to establish an auditable identity monitoring baseline.

-----

## Tools Used

- Microsoft Entra ID Portal (Monitoring & Health)
- Microsoft Graph PowerShell SDK
- Log Analytics Workspace (Azure Monitor integration)
- Microsoft Graph API (for log export)

-----

## What Was Configured

- Reviewed and interpreted Audit Logs for identity lifecycle events
- Analyzed Sign-In Logs for failed authentications, MFA challenges, and risk events
- Configured diagnostic settings to export logs to Log Analytics Workspace
- Built PowerShell queries to extract targeted audit events
- Documented key log fields that matter for IAM investigations

-----

## Steps

### 1. Review Audit Logs (Portal)

- Navigated to **Entra ID > Monitoring > Audit Logs**
- Filtered by:
  - **Category:** UserManagement, GroupManagement, RoleManagement
  - **Date Range:** Last 7 days
  - **Initiated By:** Specific admin account
- Identified and documented key events: user creation, role assignments, password resets

### 2. Review Sign-In Logs

- Navigated to **Entra ID > Monitoring > Sign-In Logs**
- Filtered for:
  - Failed sign-ins (Status: Failure)
  - MFA required and completed events
  - Sign-ins from unfamiliar locations
- Reviewed **Conditional Access** column to confirm policy enforcement

### 3. Export Logs via PowerShell

```powershell
Connect-MgGraph -Scopes "AuditLog.Read.All", "Directory.Read.All"

# Pull audit logs for user management events in last 7 days
$startDate = (Get-Date).AddDays(-7).ToString("yyyy-MM-ddTHH:mm:ssZ")

Get-MgAuditLogDirectoryAudit -Filter "activityDateTime ge $startDate and category eq 'UserManagement'" |
  Select-Object ActivityDateTime, ActivityDisplayName, InitiatedBy, TargetResources |
  Export-Csv -Path ".\audit-report.csv" -NoTypeInformation
```

### 4. Pull Sign-In Failures

```powershell
# Get failed sign-ins in last 24 hours
$yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ssZ")

Get-MgAuditLogSignIn -Filter "createdDateTime ge $yesterday and status/errorCode ne 0" |
  Select-Object CreatedDateTime, UserDisplayName, UserPrincipalName, 
                IpAddress, Location, @{N="ErrorCode";E={$_.Status.ErrorCode}} |
  Export-Csv -Path ".\signin-failures.csv" -NoTypeInformation
```

### 5. Configure Diagnostic Settings (Log Export)

- Navigated to **Entra ID > Diagnostic Settings > Add Diagnostic Setting**
- Selected log categories: AuditLogs, SignInLogs, RiskyUsers, UserRiskEvents
- Configured export destination: Log Analytics Workspace
- Verified log ingestion in Log Analytics after 15 minutes

-----

## Outcome / Verification

- Audit log export CSV generated with all user management events for the review period
- Sign-in failure report identifying accounts with repeated failed authentications
- Diagnostic settings confirmed active — logs flowing to Log Analytics
- Established repeatable monitoring process documented for handoff

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                                |
|----------------------------------------------|-----------------------------------------------------|
|Monitor and maintain Microsoft Entra ID       |Monitor identity activity with audit and sign-in logs|
|Monitor and maintain Microsoft Entra ID       |Configure diagnostic settings and log export         |
|Implement authentication and access management|Investigate sign-in risk events                      |

-----

## Key Concepts Demonstrated

- Audit Logs vs. Sign-In Logs — different purposes, different data
- Log retention limits in Entra ID (7 days free tier, 30 days P1/P2) and why export matters
- PowerShell-based log extraction for compliance reporting
- Diagnostic settings as the bridge between Entra ID and Azure Monitor / SIEM
- Key sign-in error codes and what they indicate (50126 = invalid credentials, 50076 = MFA required, 53003 = Conditional Access block)
