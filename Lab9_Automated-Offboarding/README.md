# Lab 9 – Automated User Offboarding

This lab demonstrates automated identity lifecycle management using Microsoft Entra ID and Azure Automation.

## Objective

Simulate an HR termination event that automatically disables a user account using an Azure Automation runbook.

## Technologies Used

- Microsoft Entra ID
- Azure Automation
- PowerShell
- Microsoft Graph
- Managed Identity
- Webhooks

## Workflow

HR System → Webhook → Azure Automation Runbook → Microsoft Graph → Disable User

## Runbook Actions

1. Authenticate to Microsoft Graph using Managed Identity
2. Retrieve the user
3. Disable the account
4. Revoke sign-in sessions

## Result

The automation successfully disabled the user:

Alicia.benton@boclairindustries.com
