# Lab 14 — App Registrations & API Permissions

Registered an application in Microsoft Entra ID and configured 
Microsoft Graph API permissions following least privilege principles.

## What was configured
- App registered: SC300-Lab-App (single tenant)
- Redirect URI: https://localhost/ (Web platform)
- Delegated permission: Mail.Read — read signed-in user's mail
- Delegated permission: User.Read — sign in and read user profile
- Application permission: User.Read.All — read all users without 
  signed-in user
- Admin consent granted tenant-wide for Boclair Industries

![API Permissions Granted](./api-permissions-granted.png)
