# Lab 16 — Conditional Access Named Locations

**Platform:** Microsoft Entra ID  
**Tenant:** Boclair Industries  
**Engineer:** Jairus Ross  
**Date Completed:** May 2026

-----

## Scenario

Boclair Industries needs to enforce location-based access controls to reduce the risk of unauthorized sign-ins from untrusted networks. As the IAM Engineer, I was tasked with creating a trusted named location representing the company headquarters IP address, then building a Conditional Access policy that requires MFA for any sign-in originating outside that trusted location.

-----

## Objectives

- Create a named location in Entra ID representing a trusted IP range
- Mark the location as trusted
- Build a Conditional Access policy using the named location as a condition
- Verify the policy is configured correctly in report-only mode before enforcement

-----

## Steps Performed

### Step 1 — Create a Named Location

Navigated to: **Entra ID → Security → Conditional Access → Named locations**

Clicked **+ IP ranges location** and configured:

- **Name:** Boclair Industries HQ
- **IP ranges:** Current public IP address in CIDR /32 format
- **Marked as trusted location:** Yes

Saved the named location successfully.

> **Why this matters:** Named locations define trusted network boundaries. Marking a location as trusted allows Conditional Access policies to differentiate between sign-ins from known safe networks vs unknown or risky ones.

-----

### Step 2 — Create a Conditional Access Policy

Navigated to: **Entra ID → Security → Conditional Access → Policies → + New policy**

Configured the policy with:

- **Name:** Require MFA Outside HQ
- **Users:** All users
- **Target resources:** All cloud apps
- **Conditions → Locations:** Excluded “Boclair Industries HQ” (trusted), included “Any location”
- **Grant:** Require multi-factor authentication
- **Enable policy:** Report-only (for safe testing)

Saved the policy successfully.

> **Why this matters:** Excluding the trusted HQ location means users signing in from the office IP are not prompted for MFA. Anyone signing in from anywhere else — home, coffee shop, foreign country — must complete MFA. This enforces Zero Trust principles without adding friction for on-site users.

-----

### Step 3 — Verify Policy Configuration

Used the **Conditional Access What If tool** to simulate sign-ins:

- Simulated sign-in from trusted HQ IP — policy did not apply MFA requirement
- Simulated sign-in from unknown location — policy applied MFA requirement

Confirmed policy behavior matched expected design.

> **Why this matters:** The What If tool validates policy logic before enabling enforcement, preventing accidental lockouts or unintended access grants.

-----

## Key Concepts Demonstrated

- **Named locations:** Define trusted IP ranges or countries used as conditions in Conditional Access policies
- **Trusted location flag:** Marks a named location as trusted — used by Identity Protection and Conditional Access to assess sign-in risk
- **Location condition in CA:** Policies can include or exclude specific named locations to apply controls only where needed
- **Report-only mode:** Allows testing of CA policy impact without enforcing it on real users — best practice before going live
- **What If tool:** Simulates sign-in scenarios to validate which CA policies would apply — critical troubleshooting tool
- **Zero Trust principle:** Never trust, always verify — location-based MFA enforcement is a direct application of this model

-----

## Tools Used

- Microsoft Entra Admin Center
- Conditional Access — Named Locations
- Conditional Access — Policies
- Conditional Access — What If tool

-----

## Outcome

Successfully created a trusted named location for Boclair Industries HQ and built a Conditional Access policy enforcing MFA for all sign-ins originating outside the trusted network. Lab demonstrates real-world location-based access control implementation aligned with Zero Trust security principles.
