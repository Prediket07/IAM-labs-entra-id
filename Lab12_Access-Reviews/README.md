# Lab 12 — Access Reviews (Standalone Group Review)

## Business Scenario

During a quarterly security audit, the compliance team discovered that several users retained membership in critical groups long after changing departments or leaving the organization. There was no formal process to periodically verify that group memberships were still appropriate. This created both a security risk and a compliance gap.

As the IAM engineer, you are tasked with implementing a recurring Access Review for the All Company group — establishing a formal, auditable process that requires a designated reviewer to confirm or deny each member’s continued need for access every quarter, with automatic enforcement of decisions.

-----

## Objective

Configure a standalone recurring Access Review in Microsoft Entra ID Governance that reviews all members of the All Company group quarterly, requires reviewer justification for every decision, automatically applies results, and sends completion notifications to the IAM team.

-----

## Tools Used

- Microsoft Entra ID Portal (Identity Governance)
- Access Reviews (requires Entra ID P2)
- Microsoft 365 Admin Center

-----

## Key Concepts

**What is an Access Review?**
An Access Review is a scheduled process that asks designated reviewers to confirm whether users still need their current access. It prevents access accumulation — the gradual buildup of permissions users no longer need — which is one of the most common security risks in enterprise environments.

**Standalone vs. Entitlement Management Access Reviews:**

- **Standalone** (this lab) — directly reviews membership of a specific group or app, independent of any access package
- **Entitlement Management** (Lab 11) — tied to an access package lifecycle, reviews users who received access through a specific package

Both approaches are used in enterprise environments depending on how access was originally granted.

**Auto-apply results:**
When enabled, denied access is automatically removed when the review period ends. Without this setting, reviewer decisions are just recommendations — someone still has to manually act on them. Auto-apply makes the review enforceable.

**Decision helpers:**
The “No sign-in within 30 days” helper automatically flags users who haven’t signed in recently, giving reviewers data-driven insight into potentially unnecessary access.

-----

## What Was Configured

- Created a standalone Access Review targeting the All Company group
- Scope set to All users (not just guests)
- Reviewer: Jairus Ross (specific reviewer)
- Recurrence: Quarterly, starting 04/25/2026, never ending
- Duration: 14 days per review cycle
- Auto-apply results enabled — denied access automatically removed
- Decision helper enabled: flag users with no sign-in in 30 days
- Justification required for every reviewer decision
- Email notifications and reminders enabled
- Completion notification sent to Jairus Ross
- Custom reviewer instructions added to notification email

-----

## Configuration Details

### Review Type

|Setting       |Value                           |
|--------------|--------------------------------|
|What to review|Teams + Groups                  |
|Review scope  |Select Teams + Groups (specific)|
|Group         |All Company                     |
|User scope    |All users                       |

### Reviewers

|Setting           |Value                       |
|------------------|----------------------------|
|Select reviewers  |Selected user(s) or group(s)|
|Reviewer          |Jairus Ross                 |
|Multi-stage review|No                          |

### Recurrence

|Setting          |Value     |
|-----------------|----------|
|Duration         |14 days   |
|Review recurrence|Quarterly |
|Start date       |04/25/2026|
|End              |Never     |

### Settings

|Setting                         |Value      |
|--------------------------------|-----------|
|Auto apply results to resource  |Yes        |
|If reviewers don’t respond      |No change  |
|End of review notification      |Jairus Ross|
|No sign-in within 30 days helper|Enabled    |
|Justification required          |Yes        |
|Email notifications             |Enabled    |
|Reminders                       |Enabled    |

-----

## How the Review Process Works

### When a Review Cycle Starts

1. Entra ID automatically initiates the review on the scheduled date
1. Jairus Ross receives an email notification with a link to the review
1. Email includes custom instructions: confirm or deny each member with justification

### During the Review Period (14 days)

1. Reviewer navigates to **myaccess.microsoft.com** or the Access Reviews portal
1. Reviews each member of the All Company group one by one
1. For each user, reviewer sees:
- User’s name and sign-in activity
- Flag if user hasn’t signed in within 30 days
- Option to Approve or Deny with required justification
1. Reviewer submits decisions before the 14-day deadline

### When the Review Period Ends

1. Auto-apply executes all reviewer decisions automatically
1. Denied users are removed from the All Company group immediately
1. Approved users retain their membership unchanged
1. Completion notification sent to Jairus Ross
1. Full audit trail recorded in Entra ID audit logs

### If Reviewer Doesn’t Respond

- Setting: No change — access is maintained until the reviewer acts
- This is the conservative default — access is never removed without an explicit decision

-----

## Difference Between This Lab and Lab 11

|Feature     |Lab 11 (Entitlement Management)       |Lab 12 (Standalone)                            |
|------------|--------------------------------------|-----------------------------------------------|
|Review type |Tied to access package lifecycle      |Direct group membership review                 |
|Triggered by|Access package expiration cycle       |Scheduled recurrence                           |
|Scope       |Users who requested via access package|All group members regardless of how they joined|
|Best for    |Governed self-service access          |Ongoing compliance review of any group         |

In a real enterprise both approaches run simultaneously — access packages handle new requests while standalone reviews audit existing memberships.

-----

## Verification

- Access review visible in **Identity Governance > Access Reviews > Group and app** tab ✅
- Resource: Group — All Company ✅
- Status: Not started (will activate on scheduled start date) ✅
- Review configured with quarterly recurrence, 14 day duration ✅
- Auto-apply enabled — decisions enforced automatically ✅

-----

## SC-300 Exam Alignment

|Domain                                |Topic                            |
|--------------------------------------|---------------------------------|
|Govern access using Microsoft Entra ID|Plan and implement access reviews|
|Govern access using Microsoft Entra ID|Monitor access review activity   |
|Govern access using Microsoft Entra ID|Manage the lifecycle of access   |

-----

## Key Concepts Demonstrated

- Access reviews as the primary tool for preventing access accumulation
- Standalone access review vs. entitlement management access review — when to use each
- Auto-apply as the critical setting that makes reviews enforceable vs. advisory
- Decision helpers — using sign-in data to inform access decisions
- Quarterly recurrence as a common enterprise compliance cadence
- Justification requirement as the accountability mechanism for every access decision
- “No change” as the safe default when reviewers don’t respond — access is never removed without explicit action
- Full audit trail of all review decisions for compliance reporting
