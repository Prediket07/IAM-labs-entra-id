# Lab 16 — Conditional Access Named Locations

**Platform:** Microsoft Entra ID  
**Tenant:** Boclair Industries  
**Engineer:** Jairus Ross  
**Date Completed:** May 25, 2026

---

## Scenario

Boclair Industries needs to enforce location-based access controls to reduce 
the risk of unauthorized sign-ins from untrusted networks. As the IAM Engineer, 
I implemented two phases of location-based Conditional Access — first restricting 
access by country, then tightening controls to a specific trusted office IP range.

---

## Objectives

- Create a Countries-based named location and enforce MFA outside the US
- Create an IP ranges named location marked as trusted
- Build a second CA policy enforcing MFA outside the trusted office IP
- Exclude the admin account from policies to prevent lockout

---

## Steps Performed

### Phase 1 — Country-Based Location Control

**Named Location: Boclair Industries HQ**
- Type: Countries
- Countries selected: United States
- Trusted: No (Countries type cannot be marked trusted)

**CA Policy: Require MFA Outside US**
- Users: All users
- Target resources: All resources
- Network — Include: Any network or location
- Network — Exclude: Boclair Industries HQ
- Grant: Require MFA
- State: On

> **Why this matters:** Country-based location control is a broad first layer — 
blocking or challenging sign-ins from outside approved geographies. Useful for 
organizations that only operate in specific countries.

---

### Phase 2 — IP Range Trusted Location Control

**Named Location: Boclair Trusted Office**
- Type: IP ranges
- IP range: 104.28.103.102/32
- Marked as trusted location: Yes

**CA Policy: Require MFA Outside Trusted Office**
- Users: All users
- Excluded users: JairusRoss@Boclairindustries.com
- Target resources: All resources
- Network — Include: Any network or location
- Network — Exclude: Boclair Trusted Office
- Grant: Require MFA
- State: On

> **Why this matters:** IP-based trusted locations are more precise than 
country-based controls. Marking the location as trusted also feeds into 
Identity Protection risk scoring — sign-ins from trusted IPs carry lower 
risk. The admin exclusion prevents self-lockout, a real-world best practice.

---

## Key Concepts Demonstrated

- **Countries vs IP ranges:** Two distinct named location types — countries 
  for broad geographic control, IP ranges for precise network-level control
- **Trusted location flag:** Only available on IP ranges type — lowers risk 
  score in Identity Protection for sign-ins from that network
- **Layered CA policies:** Multiple policies can coexist and stack — each 
  evaluated independently at sign-in
- **Admin exclusion:** Always exclude at least one admin account from CA 
  policies to prevent lockout
- **Zero Trust:** Never trust, always verify — location-based MFA is a 
  direct application of this model

---

## Tools Used

- Microsoft Entra Admin Center
- Conditional Access — Named Locations
- Conditional Access — Policies

---

## Outcome

Successfully implemented two phases of location-based Conditional Access. 
Phase 1 enforces MFA outside the United States. Phase 2 enforces MFA outside 
the trusted office IP range. Both policies active in BoclairIndustries tenant. 
Lab demonstrates layered, real-world location-based access control aligned 
with Zero Trust principles.
