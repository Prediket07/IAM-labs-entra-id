# Lab 14 — App Registrations & API Permissions

## Business Scenario

A development team needs to integrate a custom internal application with Microsoft 365 services. The app needs to read user profiles and send emails on behalf of signed-in users. Additionally, a background automation service needs to run nightly reports by querying Microsoft Graph without any user present. As the IAM engineer, you are responsible for registering both applications, configuring the appropriate permission types, managing authentication credentials, and ensuring only authorized users can access each app.

-----

## Objective

Register applications in Microsoft Entra ID, configure delegated and application permissions against Microsoft Graph, manage client secrets and certificates, implement admin consent, and control app access through the Assignment Required setting.

-----

## Tools Used

- Microsoft Entra ID Portal (App Registrations)
- Microsoft Entra ID Portal (Enterprise Applications)
- Microsoft Graph API
- PowerShell + Microsoft Graph PowerShell SDK

-----

## Key Concepts

**App Registration vs Enterprise Application**

- **App Registration** — the blueprint. Defines what the app is, what permissions it needs, and how it authenticates. Created once, lives in the home tenant.
- **Enterprise Application (Service Principal)** — the instance. Automatically created when an app registration is created. This is what you assign users to and manage access with.
- Think of it as: App Registration = recipe, Enterprise Application = the meal served in your tenant.

**Delegated Permissions**
Used when an application acts on behalf of a signed-in user. The app inherits the user’s permissions — it can only do what the signed-in user is allowed to do. Always used when a user is present.

**Application Permissions**
Used when an application acts as itself with no user present. Used for background services, daemons, and automation scripts that run without a signed-in user.

**Client Secret vs Certificate**

- **Client Secret** — a password for the application. Has an expiration date and must be rotated before expiry.
- **Certificate** — more secure alternative. Preferred in production environments.

**Admin Consent**
Authorization granted by an administrator on behalf of the entire organization for sensitive API permissions. Required when permissions exceed what a standard user can consent to themselves.

-----

## Architecture

```
User-Facing App                    Background Service App
      │                                      │
      │ Delegated Permissions                │ Application Permissions
      │ (acts on behalf of user)             │ (acts as itself)
      ▼                                      ▼
Microsoft Graph API            Microsoft Graph API
      │                                      │
      ▼                                      ▼
Returns data user               Returns data app
is allowed to see               is permitted to access
```

-----

## What Was Configured

### App Registration 1 — User-Facing Application

**Registration:**

- Navigated to **Entra ID > App Registrations > New Registration**
- Name: `Boclair Industries Internal App`
- Supported account types: Single tenant
- Redirect URI: Web — `https://localhost` (for testing)

**API Permissions — Delegated:**

- Added Microsoft Graph delegated permissions:
  - `User.Read` — read signed-in user’s profile
  - `Mail.Send` — send email on behalf of signed-in user
- Granted admin consent for the organization

**Authentication:**

- Configured client secret with 12-month expiration
- Documented expiration date for rotation reminder

**Enterprise Application — Access Control:**

- Navigated to Enterprise Applications > Boclair Industries Internal App
- Set **Assignment Required** to **Yes**
- Assigned specific users: Alex Johnson, Sarah Chen

-----

### App Registration 2 — Background Service (No User)

**Registration:**

- Name: `Boclair Industries Automation Service`
- Supported account types: Single tenant
- No redirect URI (no user sign-in required)

**API Permissions — Application:**

- Added Microsoft Graph application permissions:
  - `User.Read.All` — read all user profiles
  - `Mail.Read` — read mail in all mailboxes
- Granted admin consent (required for application permissions)

**Authentication:**

- Configured client secret for service authentication
- Documented that this app authenticates with its own credentials — no user involved

-----

## Key Configuration Details

### Application IDs

|Field                  |Purpose                                                        |
|-----------------------|---------------------------------------------------------------|
|Application (Client) ID|Unique identifier for the app — used in authentication requests|
|Directory (Tenant) ID  |Unique identifier for the Entra ID tenant                      |
|Object ID              |Internal Entra ID identifier for the app registration object   |

### Permission Types Comparison

|Scenario                                  |Permission Type|User Present?|
|------------------------------------------|---------------|-------------|
|App reads signed-in user’s calendar       |Delegated      |Yes          |
|App sends email as signed-in user         |Delegated      |Yes          |
|Nightly script reads all user profiles    |Application    |No           |
|Background service processes all mailboxes|Application    |No           |

### Client Secret Lifecycle

1. Create secret with defined expiration (6 or 12 months)
1. Document expiration date
1. Before expiration: create new secret
1. Update application configuration to use new secret
1. Verify application works with new secret
1. Delete old secret

-----

## Admin Consent

Admin consent was granted for both applications from the API Permissions blade. This is required because:

- Delegated permissions like `Mail.Send` are sensitive and require organizational approval
- Application permissions always require admin consent — users cannot consent on behalf of the organization for app-level access

Without admin consent, users receive a consent error when attempting to sign in to the app.

-----

## Verification

- Both app registrations visible in **Entra ID > App Registrations > All Applications** ✅
- API permissions configured and admin consent granted (green checkmark) ✅
- Client secrets created with documented expiration dates ✅
- Assignment Required set to Yes on Enterprise Applications ✅
- Authorized users assigned to user-facing app ✅
- Unauthorized users confirmed blocked ✅

-----

## SC-300 Exam Alignment

|Domain                                      |Topic                                              |
|--------------------------------------------|---------------------------------------------------|
|Implement access management for applications|Register applications in Microsoft Entra ID        |
|Implement access management for applications|Configure API permissions                          |
|Implement access management for applications|Manage app credentials (secrets and certificates)  |
|Plan and implement workload identities      |Configure service principals and managed identities|

-----

## Key Concepts Demonstrated

- App Registration as the identity blueprint vs Enterprise Application as the access control layer
- Delegated vs Application permissions — when to use each based on whether a user is present
- Admin consent as the organizational authorization gate for sensitive permissions
- Client secret lifecycle management — creation, rotation, and deletion
- Assignment Required as the critical setting for restricting app access
- Application (Client) ID and Directory (Tenant) ID — what each identifies and why both are needed
- Certificates as the preferred alternative to client secrets in production
