# Lab 13 — Identity Protection & Risk Policies

## Business Scenario

The security team has received an alert that several user credentials from the organization may have been exposed in a third-party data breach. Additionally, the SOC team has flagged suspicious sign-in patterns including logins from anonymous IP addresses and impossible travel events. The current environment has no automated response to these threats — every investigation is manual.

As the IAM engineer, you are tasked with implementing Microsoft Entra Identity Protection to automatically detect risky sign-ins and compromised accounts, and configure risk-based policies that respond to threats in real time without requiring manual intervention for every event.

-----

## Objective

Configure Microsoft Entra Identity Protection by enabling sign-in risk and user risk policies, establish a break-glass emergency access account, set policies to Report-only mode for safe testing, and review the Risky Users and Risky Sign-ins reports to understand how risk detections are surfaced and managed.

-----

## Tools Used

- Microsoft Entra ID Portal (Identity Protection)
- Conditional Access (for risk-based policies)
- Microsoft Entra ID P2 (required for Identity Protection)
- Risky Users and Risky Sign-ins reports

-----

## Key Concepts

**Sign-in Risk**
A probability score that a specific authentication attempt was not performed by the legitimate user. Detections include anonymous IP address, impossible travel, malware-linked IP, unfamiliar sign-in properties, and more.

**User Risk**
A probability score that a user account is compromised. Detections include leaked credentials found on the dark web, patterns of suspicious activity, and confirmed compromise by an administrator.

**Risk Levels**
Both sign-in risk and user risk are scored as Low, Medium, or High. Policies respond to risk levels, not individual detections.

**Risk Detection vs Risk Level**

- A **risk detection** is a specific suspicious event (e.g., impossible travel, anonymous IP)
- A **risk level** is the aggregated score based on one or more detections
- Multiple detections can combine to push a risk level higher
- Think of detections as evidence and risk level as the verdict

**Sign-in Risk Policy**
Automatically responds when a sign-in is flagged as suspicious. Common configurations:

- Medium or above → Require MFA
- High → Block access

**User Risk Policy**
Automatically responds when a user account is flagged as compromised. Common configurations:

- High → Require password change
- High → Block access until remediated

**Break-Glass Account**
An emergency access account excluded from all Conditional Access and risk policies. Exists to ensure at least one admin can always sign in, even if a misconfigured policy locks everyone else out. Should be monitored with sign-in alerts.

**Report-Only Mode**
Policies in Report-only mode evaluate every sign-in and log what WOULD have happened if enforced — without actually blocking or requiring anything. Used to safely test policy impact before enabling enforcement.

-----

## Architecture

```
User attempts sign-in
        │
        ▼
Microsoft Entra Identity Protection
        │
   Evaluates risk signals:
   - Anonymous IP?
   - Impossible travel?
   - Leaked credentials?
   - Unfamiliar location?
        │
        ▼
Risk level assigned (Low / Medium / High)
        │
   ┌────┴────┐
   ▼         ▼
Sign-in    User
Risk       Risk
Policy     Policy
   │         │
   ▼         ▼
Require    Require password
MFA or     change or
Block      Block access
```

-----

## What Was Configured

### Step 1 — Created Break-Glass Account

Before enabling any risk policies, a break-glass emergency access account was created and excluded from all policies to ensure lockout prevention.

- Created dedicated admin account: `breakglass@BoclairIndustries.onmicrosoft.com`
- Assigned Global Administrator role
- Excluded from all Conditional Access policies
- Sign-in alerts configured — any use of this account triggers immediate notification

### Step 2 — Configured Sign-In Risk Policy

Navigated to **Entra ID > Protection > Identity Protection > Sign-in risk policy**

|Setting           |Value                                    |
|------------------|-----------------------------------------|
|Users             |All users (excluding break-glass account)|
|Sign-in risk level|Medium and above                         |
|Access control    |Require MFA                              |
|Policy state      |Report-only (safe testing mode)          |

**Why Medium and above:** Low risk events are common and often false positives. Starting enforcement at Medium reduces noise while catching genuine threats.

### Step 3 — Configured User Risk Policy

Navigated to **Entra ID > Protection > Identity Protection > User risk policy**

|Setting        |Value                                    |
|---------------|-----------------------------------------|
|Users          |All users (excluding break-glass account)|
|User risk level|High                                     |
|Access control |Require password change                  |
|Policy state   |Report-only (safe testing mode)          |

**Why High only:** User risk policies are more disruptive than sign-in risk policies. Requiring password changes for Medium risk would generate too many helpdesk tickets during initial rollout. Starting at High targets only confirmed or near-confirmed compromises.

### Step 4 — Reviewed Risk Reports

**Risky Sign-ins Report**

- Navigated to **Identity Protection > Risky sign-ins**
- Reviewed detection type, risk level, risk state, and IP address for each flagged event
- Confirmed report-only policies showing “Would have required MFA” in the results

**Risky Users Report**

- Navigated to **Identity Protection > Risky users**
- Reviewed risk level, risk detail, and last risky sign-in for flagged accounts
- Available admin actions from this report:
  - **Confirm user compromised** — escalates risk to High, triggers policy response
  - **Dismiss user risk** — clears the risk flag for confirmed false positives
  - **Reset password** — forces immediate password change

-----

## Risk Detection Types — SC-300 Reference

|Detection                    |Type        |Description                                                       |
|-----------------------------|------------|------------------------------------------------------------------|
|Anonymous IP address         |Sign-in risk|Sign-in from Tor browser or anonymous proxy                       |
|Impossible travel            |Sign-in risk|Sign-in from two locations impossible to reach in the elapsed time|
|Unfamiliar sign-in properties|Sign-in risk|Sign-in from location/device not seen before for this user        |
|Malware-linked IP            |Sign-in risk|Sign-in from IP known to communicate with malware servers         |
|Leaked credentials           |User risk   |Username/password found in dark web breach data                   |
|Azure AD threat intelligence |Both        |Microsoft internal signals indicating compromise                  |

-----

## Break-Glass Account Strategy

|Requirement          |Configuration                                               |
|---------------------|------------------------------------------------------------|
|Account type         |Cloud-only Global Administrator                             |
|MFA                  |Not enrolled in standard MFA — uses alternative verification|
|CA policy exclusion  |Excluded from ALL Conditional Access policies               |
|Risk policy exclusion|Excluded from sign-in and user risk policies                |
|Password             |Complex, stored securely offline (sealed envelope or vault) |
|Monitoring           |Alert configured for any sign-in event                      |
|Usage                |Emergency only — misconfigured policy lockout recovery      |

-----

## Report-Only vs Enforced — When to Switch

|Phase   |State       |Purpose                                 |
|--------|------------|----------------------------------------|
|Week 1-2|Report-only |Observe impact, identify false positives|
|Week 3  |Review logs |Confirm policy behavior is correct      |
|Week 4  |Switch to On|Full enforcement begins                 |

Switching directly to On without Report-only testing risks locking out legitimate users. Always test first.

-----

## Verification

- Sign-in risk policy created targeting Medium and above → Require MFA ✅
- User risk policy created targeting High → Require password change ✅
- Both policies in Report-only mode for safe testing ✅
- Break-glass account created and excluded from all policies ✅
- Risky Sign-ins and Risky Users reports reviewed ✅

-----

## SC-300 Exam Alignment

|Domain                                        |Topic                                          |
|----------------------------------------------|-----------------------------------------------|
|Implement authentication and access management|Plan and implement Identity Protection         |
|Implement authentication and access management|Implement risk-based Conditional Access        |
|Implement authentication and access management|Investigate and remediate risk detections      |
|Implement authentication and access management|Configure break-glass emergency access accounts|

-----

## Key Concepts Demonstrated

- Sign-in risk vs user risk — different triggers, different policy responses
- Risk detection vs risk level — evidence vs verdict
- Break-glass account as a critical operational safety control
- Report-only mode as a mandatory testing step before policy enforcement
- Risky Users report as the operational interface for manual risk remediation
- Impossible travel as a sign-in risk detection — not user risk
- Confirmed compromise vs dismiss user risk — two distinct admin actions with different outcomes
