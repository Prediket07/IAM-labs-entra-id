# Lab 20 — Break Glass Account Configuration and Emergency Access Management

## Overview

This lab demonstrates the configuration of emergency access (break glass) accounts in Microsoft Entra ID, following Microsoft's best practice guidance for maintaining tenant access during identity infrastructure failures. Two break glass accounts were created, configured, and hardened in a live Entra ID tenant.

The lab maps directly to SC-300 blueprint objectives:
- Plan and implement privileged access
- Implement and manage emergency access accounts
- Monitor and maintain Microsoft Entra ID

---

## Environment

- **Tenant:** Boclair Industries (BoclairIndustries.onmicrosoft.com)
- **License:** Microsoft 365 E5
- **Tools:** Microsoft Entra Admin Center
- **Accounts created:** Break Glass 1, Break Glass 2

---

## Why Break Glass Accounts Exist

Break glass accounts are emergency access accounts used only when normal administrative access is unavailable — for example, when:

- Conditional Access policies are misconfigured and locking out all admins
- MFA infrastructure is broken or unreachable
- A federated domain fails, blocking all federated sign-ins
- A Global Administrator account is compromised and all others are locked out

Without break glass accounts, a misconfigured CA policy or identity infrastructure failure could permanently lock all administrators out of the tenant with no recovery path.

---

## Design Principles

| Principle | Reason |
|---|---|
| Cloud-only accounts (onmicrosoft.com domain) | Independent of custom domain federation — works even if federated domain fails |
| Global Administrator — Active, Permanent | No PIM activation required — must work when MFA and PIM may be broken |
| Excluded from ALL Conditional Access policies | CA policy failures are the most common reason break glass is needed |
| NOT subject to MFA | MFA infrastructure failure is exactly when break glass accounts are needed |
| Long, complex passwords stored offline | Credentials must be accessible without cloud infrastructure |
| Two accounts minimum | Redundancy — if one is compromised, the other provides recovery |
| Monitored — any sign-in triggers alert | Normal operations should never require break glass sign-in |

---

## Part 1 — Account Creation

### Break Glass 1
- **Display name:** Break Glass 1
- **UPN:** Break.glass.1@BoclairIndustries.onmicrosoft.com
- **Domain:** onmicrosoft.com (cloud-only, independent of custom domain)
- **User type:** Member
- **Created:** July 7, 2026

### Break Glass 2
- **Display name:** Break Glass 2
- **UPN:** Break.Glass.2@BoclairIndustries.onmicrosoft.com
- **Domain:** onmicrosoft.com (cloud-only, independent of custom domain)
- **User type:** Member
- **Created:** July 7, 2026

### Why onmicrosoft.com Domain

In production environments, break glass accounts must use the tenant's onmicrosoft.com domain rather than any custom domain. Custom domains are tied to DNS and potentially AD FS federation configuration. If domain federation fails — the most common emergency scenario — accounts on the custom domain may be unable to authenticate. The onmicrosoft.com domain is built into Entra itself and remains functional regardless of custom domain, DNS, or federation state.

### Password Requirements

Break glass account passwords must be:
- At minimum 16 characters
- Complex (uppercase, lowercase, numbers, symbols)
- Stored offline in a physically secure location (not in a digital password manager that requires cloud authentication to access)
- Known to at least two trusted administrators

---

## Part 2 — Role Assignment

Both accounts were assigned **Global Administrator** as an **Active, Permanent** assignment directly in Entra ID (not via PIM eligible assignment).

**Navigation:** Users → Break Glass account → Assigned roles → Add assignments → Global Administrator → Active → No expiration

### Why Active and Not Eligible

PIM eligible assignments require the user to activate the role through a process that may involve MFA, approval workflows, and PIM infrastructure — all of which could be unavailable during the exact emergency where break glass access is needed.

Active, permanent assignment means the role is always on with no activation step required.

| Assignment Type | Activation Required | Works During MFA Outage | Works During PIM Issues |
|---|---|---|---|
| PIM Eligible | Yes | No | No |
| Active Permanent | No | Yes | Yes |

---

## Part 3 — Conditional Access Exclusions

Both break glass accounts were excluded from all Conditional Access policies in the tenant.

**Policies updated:**

| Policy | State | Exclusions Added |
|---|---|---|
| Require MFA Outside Trusted Office | Report-only | Break Glass 1, Break Glass 2 |
| Require MFA Outside US | Report-only | Break Glass 1, Break Glass 2 |
| SC300-Lab-SignIn-Risk-Policy | Report-only | Break Glass 1, Break Glass 2 |
| SC300-Lab-User-Risk-Policy | Report-only | Break Glass 1, Break Glass 2 |

**Navigation:** Protection → Conditional Access → Policies → [Policy] → Users or agents → Exclude → Users and groups → Add both break glass accounts → Save

### Why CA Exclusion Is Critical

The most common scenario requiring break glass access is a misconfigured Conditional Access policy that blocks all administrative sign-ins. If break glass accounts are subject to CA policies, they will be blocked by the same policy that caused the emergency — defeating their entire purpose.

Break glass accounts must be excluded from every CA policy without exception, including MFA requirements, location restrictions, device compliance, and risk-based policies.

---

## Part 4 — Monitoring Configuration

### Identity Protection — Users at Risk Detected Alerts

Configured to send email alerts when any user is detected at High risk level.

**Navigation:** ID Protection → Settings → Users at risk detected alerts

| Setting | Value |
|---|---|
| Alert on user risk level | High |
| Recipients | Jairus Ross (JairusRoss@BoclairIndustries.onmicrosoft.com) |
| Custom recipient | JairusRossIAM@gmail.com |

### Identity Protection — Weekly Digest

Configured to send weekly summary of identity risk activity.

**Navigation:** ID Protection → Settings → Weekly digest

| Setting | Value |
|---|---|
| Send weekly digest emails | Yes |
| Recipients | Jairus Ross (Global Administrator) |

### Monitoring Gap — Azure Subscription Required

Full break glass monitoring best practice requires routing Entra sign-in logs to an Azure Log Analytics workspace and creating an alert rule that triggers immediately when either break glass account signs in — regardless of risk level. This provides real-time alerting on any break glass usage, not just high-risk detections.

**Navigation (production):** Monitoring & health → Diagnostic settings → Add diagnostic setting → Send to Log Analytics workspace → Configure alert rule on break glass UPN in sign-in logs

This configuration requires an Azure subscription separate from Microsoft 365 E5. In this lab environment, Identity Protection alerts serve as the compensating control. In a production deployment, both Log Analytics alerting and Identity Protection alerts would be configured together.

---

## Part 5 — Operational Procedures

### When to Use Break Glass Accounts

Break glass accounts should only be used when:
- All normal Global Administrator accounts are locked out
- CA policies are blocking all administrative access
- MFA infrastructure is unavailable and blocking all admin sign-ins
- A federated domain failure prevents normal authentication

### After Break Glass Use

Any use of a break glass account should trigger an immediate incident response process:
1. Investigate why normal access failed
2. Remediate the root cause
3. Review sign-in logs for the break glass account
4. Rotate the break glass account password immediately after use
5. Document the incident

### Ongoing Maintenance

- **Quarterly:** Verify both accounts can still sign in (test in a controlled, documented manner)
- **Quarterly:** Confirm both accounts are still excluded from all CA policies
- **Quarterly:** Verify passwords are accessible to designated administrators
- **Annually:** Rotate passwords even if accounts haven't been used
- **Any time:** Immediately after a new CA policy is created, verify break glass exclusions are present

---

## Key Takeaways

Break glass account configuration demonstrates several core IAM principles tested in SC-300:

- **Least privilege vs. emergency access tradeoff:** Break glass accounts are intentionally over-privileged (permanent Global Admin, no MFA) because their entire value is availability during infrastructure failures.
- **CA policy exclusions are not optional:** A break glass account subject to CA policies is not a break glass account — it's just another account that will fail during the same emergency.
- **onmicrosoft.com domain is the production standard:** Cloud-only accounts on the built-in domain are independent of any federation failure, custom domain issue, or DNS outage.
- **Monitoring is the counterbalance:** The security risk of permanent Global Admin accounts with no MFA is mitigated by ensuring any sign-in triggers an immediate alert. Accounts that should never be used must be heavily monitored.

---

## Exam Relevance (SC-300)

| Blueprint Objective | Where This Lab Covers It |
|---|---|
| Plan and implement privileged access | Global Admin assignment, Active vs Eligible decision |
| Implement emergency access accounts | Full break glass account creation and hardening |
| Configure Conditional Access exclusions | All 4 CA policies updated with break glass exclusions |
| Monitor and maintain Entra ID | Identity Protection alerts, weekly digest, Log Analytics gap documented |
| Plan for identity infrastructure resilience | onmicrosoft.com domain rationale, federation failure scenarios |

---

*Lab completed: July 7, 2026*
*Tenant: Boclair Industries (BoclairIndustries.onmicrosoft.com)*
*Lab series: github.com/Prediket07/IAM-labs-entra-id*
