# Lab 15 — B2B External Collaboration

**Platform:** Microsoft Entra ID  
**Tenant:** Boclair Industries  
**Engineer:** Jairus Ross  
**Date Completed:** May 2026

-----

## Scenario

Boclair Industries needs to onboard a partner company contact as a guest user for collaboration. As the IAM Engineer, I was tasked with configuring external collaboration settings, restricting invitations to approved domains, inviting an external guest user, and verifying the guest account was provisioned correctly.

-----

## Objectives

- Configure External Collaboration Settings to restrict guest invite permissions
- Apply domain-based collaboration restrictions
- Invite an external B2B guest user via the Entra admin center
- Verify guest user account type and UPN format

-----

## Steps Performed

### Step 1 — Configure External Collaboration Settings

Navigated to: **Entra ID → Users → User Settings → Manage external collaboration settings**

Configured the following:

- **Guest user access:** Guest users have limited access to properties and memberships of directory objects
- **Guest invite settings:** Member users and users assigned to specific admin roles can invite guest users
- **External user leave settings:** Allowed external users to remove themselves from the organization
- **Collaboration restrictions:** Set to “Allow invitations only to the specified domains” — added **gmail.com** as the approved domain

> **Why this matters:** Restricting invite permissions prevents unauthorized guest invitations. Domain allowlisting ensures only approved partner organizations can be onboarded as guests.

-----

### Step 2 — Invite External Guest User

Navigated to: **Entra ID → Users → New user → Invite external user**

Configured the invite with:

- **Email:** JairusrossIAM@gmail.com
- **Display name:** Test Guest User
- **Message:** “You have been invited to collaborate with Boclair Industries”
- **Redirect URL:** MyApplications portal (auto-populated)

Invitation sent successfully — confirmation toast received.

-----

### Step 3 — Verify Guest Account

Navigated to: **Entra ID → Users → All users**

Confirmed:

- **Display name:** Test Guest User
- **User type:** Guest (not Member)
- **UPN format:** JairusrossIAM_gmail.com#EXT#@boclairindustries.onmicrosoft.com
- Directory count increased from 6 to **7 users**

> **Why this matters:** The #EXT# UPN format confirms the account is a federated B2B guest identity, not an internal member account. Guest user type ensures limited directory access per the configured restrictions.

-----

### Step 4 — Reset Collaboration Settings

After completing the lab, collaboration restrictions were reset to **“Allow invitations to be sent to any domain”** to avoid impacting future lab work.

-----

## Key Concepts Demonstrated

- **B2B vs B2C:** B2B allows external partners to access your tenant using their own credentials. B2C is a separate service for customer-facing app identities.
- **Guest user access restrictions:** Controls how much of the directory guest users can browse — configured to limited access.
- **Domain allowlisting:** Restricts invitations to approved domains only — new invitations blocked, existing guests unaffected.
- **#EXT# UPN format:** All B2B guest accounts receive an external UPN in the format: `email_domain#EXT#@yourtenant.onmicrosoft.com`
- **Guest Inviter role:** Minimum role required to send B2B invitations — no full User Admin needed.

-----

## Tools Used

- Microsoft Entra Admin Center
- External Identities — External Collaboration Settings
- Entra ID Users blade

-----

## Outcome

Successfully configured B2B external collaboration settings, applied domain restrictions, invited and verified an external guest user. Lab demonstrates real-world IAM governance of external identity onboarding in Microsoft Entra ID.
