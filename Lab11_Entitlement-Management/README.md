# Lab 11 — Entitlement Management & Access Packages

## Business Scenario

A growing organization is struggling with uncontrolled access requests. Employees email IT directly to be added to groups and applications, there is no approval process, no record of why access was granted, and no one reviews whether users still need access after it’s been assigned. During a recent audit, the compliance team flagged this as a critical gap — access is being granted with no documentation, no expiration, and no oversight.

As the IAM engineer, you are tasked with implementing Microsoft Entra Entitlement Management to replace the ad-hoc access request process with a governed, self-service system that includes approval workflows, requestor justification, and periodic access reviews.

-----

## Objective

Design and implement a full Entitlement Management system in Microsoft Entra ID — creating a resource catalog, configuring an access package with an approval policy, and establishing quarterly access reviews — giving users a self-service way to request access while ensuring all access is approved, documented, time-limited, and regularly reviewed.

-----

## Tools Used

- Microsoft Entra ID Portal (Identity Governance)
- Entitlement Management (requires Entra ID P2)
- Microsoft 365 Admin Center
- MyAccess Portal (myaccess.microsoft.com)

-----

## Key Concepts

**Catalog** — A container that holds resources (groups, apps, SharePoint sites) that can be included in access packages. Think of it as a department store — resources must be added to the catalog before users can request them.

**Access Package** — A bundle of resources that users can request access to. When a user is approved for an access package, they are automatically added to the associated groups or granted app access.

**Policy** — Controls who can request the access package, who approves it, whether justification is required, and how long access lasts.

**Access Reviews** — Periodic reviews that force designated reviewers to confirm whether users still need their access. If access is no longer needed, it can be removed during the review cycle.

**Why this matters:** Groups control access to resources in Microsoft 365. When a user is added to a group through an access package, they instantly gain access to everything that group controls — SharePoint sites, applications, mailboxes, Teams channels. One approval, governed access to everything.

-----

## Architecture

```
User requests access via MyAccess Portal
            │
            ▼
    Access Package Policy
            │
    ┌───────┴────────┐
    │                │
Justification    Approval Request
required         sent to Jairus Ross
    │                │
    └───────┬────────┘
            │
    Approved/Denied
            │
            ▼
    User added to group
            │
            ▼
    Access to all group resources
            │
            ▼
    Quarterly access review
    (Jairus Ross reviews — keep or remove)
            │
            ▼
    Access expires after 365 days
    (user must re-request if still needed)
```

-----

## What Was Configured

### Step 1 — Created Resource Catalog

- Navigated to **Entra ID > Identity Governance > Entitlement Management > Catalogs**
- Created new catalog:
  - **Name:** Boclair Industries IT Resources
  - **Description:** Catalog containing IT resource access packages for internal users
  - **Enabled for users to request:** Yes
  - **Enabled for external users:** No

### Step 2 — Added Resource to Catalog

- Opened the Boclair Industries IT Resources catalog
- Navigated to **Resources > Add resources**
- Added **All Company** group (Microsoft 365 Group type)
- This group is the resource users will be granted membership to upon approval

### Step 3 — Created Access Package

- Navigated to **Access packages > New access package**
- Configured across all tabs:

**Basics:**

- Name: IT General Access Package
- Description: Provides access to general IT resources and the All Company group for new employees and internal requestors
- Catalog: Boclair Industries IT Resources

**Resource Roles:**

- Resource: All Company (Group and Team — Microsoft 365)
- Role: Member
- Result: Approved users become members of the All Company group

**Requests:**

- Who can get access: Users in directory (Alex Johnson, Sarah Chen)
- Who can request: Self + Admin
- Require approval: Yes
- Require requestor justification: Yes
- Approval stages: 1
- First approver: Jairus Ross (specific approver)
- Decision deadline: 14 days
- Require approver justification: Yes

**Requestor Information:**

- Custom question: “Why do you need access to the All Company group?”
- Answer format: Short text
- Required: Yes

**Lifecycle:**

- Access expires: After 365 days
- Users can request specific timeline: Yes
- Require access reviews: Yes
- Review frequency: Quarterly
- Duration: 25 days
- Reviewers: Specific reviewer(s) — Jairus Ross
- If reviewers don’t respond: No change
- Require reviewer justification: Yes

-----

## How the End-to-End Flow Works

### User Request Flow

1. Alex Johnson navigates to **myaccess.microsoft.com**
1. Finds “IT General Access Package” in available packages
1. Clicks Request and answers: “Why do you need access to the All Company group?”
1. Submits request with justification
1. Jairus Ross receives approval notification
1. Reviews request and justification, approves or denies within 14 days
1. If approved — Alex is automatically added to the All Company group
1. Alex now has access to all resources the All Company group controls

### Access Review Flow (Quarterly)

1. Every 90 days Jairus Ross receives an access review notification
1. Reviews each user who has active assignments from this access package
1. For each user: Approve (keep access) or Deny (remove access)
1. Must provide justification for each decision
1. Any denied access is automatically removed
1. Access also auto-expires after 365 days — users must re-request if still needed

-----

## Verification

- Catalog visible in **Identity Governance > Catalogs** ✓
- All Company group showing as resource in catalog ✓
- IT General Access Package created with 1 active policy ✓
- MyAccess portal link generated for user-facing requests ✓
- Access reviews configured — quarterly, Jairus Ross as reviewer ✓

-----

## Real-World Application

In an enterprise environment this same architecture scales to:

|Department |Access Package         |Resources Included                                       |
|-----------|-----------------------|---------------------------------------------------------|
|HR         |HR Systems Access      |HR group, Workday, HR SharePoint, Benefits portal        |
|Finance    |Finance Systems Access |Finance group, accounting software, financial reports    |
|IT         |IT Admin Tools Access  |IT group, admin tools, monitoring dashboards             |
|Legal      |Legal Department Access|Legal group, contract management system, legal SharePoint|
|Contractors|Vendor Temporary Access|Limited group, specific app only, 90-day expiration      |

Each package has its own approval policy, its own reviewers, and its own lifecycle — giving the organization complete control over who has access to what, for how long, and why.

-----

## SC-300 Exam Alignment

|Domain                                |Topic                                    |
|--------------------------------------|-----------------------------------------|
|Govern access using Microsoft Entra ID|Plan and implement entitlement management|
|Govern access using Microsoft Entra ID|Create and manage catalogs               |
|Govern access using Microsoft Entra ID|Create and manage access packages        |
|Govern access using Microsoft Entra ID|Implement and manage access reviews      |
|Govern access using Microsoft Entra ID|Manage the lifecycle of external users   |

-----

## Key Concepts Demonstrated

- Catalog as the governance container for all requestable resources
- Access packages as the self-service mechanism replacing ad-hoc IT requests
- Approval workflows with justification as the accountability control
- Time-limited access (365 days) as a security baseline — no permanent access without re-justification
- Quarterly access reviews as the ongoing governance mechanism
- Group membership as the actual access control mechanism — one approval grants access to everything the group controls
- MyAccess portal as the end-user interface for self-service access requests
- Separation between who can REQUEST access and who can APPROVE it
