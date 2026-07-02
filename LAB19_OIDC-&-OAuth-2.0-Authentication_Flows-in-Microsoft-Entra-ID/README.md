# Lab 19 — OIDC & OAuth 2.0 Authentication Flows in Microsoft Entra ID

## Overview

This lab demonstrates end-to-end authentication flows using Microsoft Entra ID as the Identity Provider (IdP). It covers two OAuth 2.0/OIDC flow types — the Implicit Flow and the Authorization Code Flow — using a registered application in a live Entra tenant.

The lab maps directly to SC-300 blueprint objectives:
- Configure app authentication
- Plan for app registrations
- Configure API permissions
- Implement and manage Microsoft Entra user authentication

---

## Environment

- **Tenant:** Boclair Industries (BoclairIndustries.onmicrosoft.com)
- **App Registration:** SC300-Lab-App
- **Tools:** Microsoft Entra Admin Center, Browser, jwt.ms token decoder
- **Protocols:** OAuth 2.0, OpenID Connect (OIDC)

---

## Concepts Demonstrated

### Protocol Roles

| Protocol | Job | Output |
|---|---|---|
| OAuth 2.0 | Authorization — grants scoped access to a resource | Access token |
| OpenID Connect (OIDC) | Identity — proves who the user is | ID token (JWT) |

OIDC is layered on top of OAuth 2.0. Modern app sign-in uses both together: OAuth delivers the access token for API calls, OIDC delivers the ID token for identity.

### Flow Comparison

| | Implicit Flow | Authorization Code Flow |
|---|---|---|
| Steps | 1 | 2 |
| What comes back first | Token directly in browser URL | Authorization code (not a token) |
| Token delivery | In browser URL (less secure) | Private server-to-server exchange |
| Default in Entra | Off (must be explicitly enabled) | On (modern default) |
| Use case | Legacy browser apps | Modern web apps with a backend |

---

## Part 1 — App Registration Setup

### Step 1: Register the Application

Navigated to **Entra Admin Center → App Registrations → SC300-Lab-App**.

Confirmed:
- Supported account types: Single tenant (Boclair Industries only)
- Application (client) ID noted for use in flow URLs

### Step 2: Configure Redirect URI

In **Authentication blade → Redirect URI configuration**:

Added `https://jwt.ms` as a Web platform redirect URI.

**Why this matters:** The redirect URI must be pre-registered in Entra. If a request comes in with a redirect URI that doesn't match, Entra refuses to send tokens there — this is a core security control preventing token theft via a malicious redirect.

### Step 3: Create a Client Secret

In **Certificates & secrets → Client secrets**:

Created `SC300-LAB-SECRET` with 180-day expiration.

**Why this matters:** The client secret is the app's own credential — it proves to Entra that the token exchange request in Step 2 of the Authorization Code Flow is genuinely coming from the registered app, not an attacker who intercepted the authorization code.

**Security note:** The secret value is only visible once at creation time. After navigating away it is permanently masked. In production, certificates are preferred over client secrets for higher assurance.

---

## Part 2 — Implicit Flow (OIDC ID Token)

### What It Is

The implicit flow is an older OAuth 2.0 pattern where the ID token and/or access token are returned directly in the browser URL after authentication. It is disabled by default in modern Entra app registrations because tokens exposed in the browser URL are accessible to browser history, extensions, and logs.

### Configuration

In **Authentication blade → Settings → Implicit grant and hybrid flows**:

Enabled: **ID tokens (used for implicit and hybrid flows)**

This toggle must be explicitly enabled because Entra defaults to the more secure Authorization Code Flow.

### Step 1: Build the Authorization Request

Constructed the OIDC implicit flow URL manually:

```
https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/authorize
  ?client_id={client-id}
  &response_type=id_token
  &redirect_uri=https://jwt.ms
  &scope=openid profile email
  &nonce=12345
```

**Parameter breakdown:**

| Parameter | Purpose |
|---|---|
| `client_id` | Identifies which app is requesting sign-in |
| `response_type=id_token` | Requests an OIDC ID token directly (implicit flow) |
| `redirect_uri` | Must match registered URI — Entra sends the token here |
| `scope=openid profile email` | `openid` activates OIDC; `profile` and `email` request identity claims |
| `nonce` | Random value echoed back in token to prevent replay attacks |

### Step 2: Sign In and Decode the Token

Ran the URL in browser → authenticated with Boclair Industries credentials → redirected to jwt.ms with decoded ID token.

**First attempt result:** `AADSTS700054: response_type 'id_token' is not enabled`

This error confirmed that implicit flow is off by default — a security-by-default posture. Enabling the ID tokens toggle in Authentication settings resolved it.

### Step 3: Analyze the Decoded ID Token

The decoded JWT contained the following key claims:

| Claim | Value | Meaning |
|---|---|---|
| `aud` | Client ID | Token is valid only for this specific app |
| `iss` | login.microsoftonline.com/{tenant}/v2.0 | Entra identifying itself as the issuer/IdP |
| `email` | JairusRoss@Boclairindustries.com | Identity claim from OIDC profile scope |
| `name` | Jairus Ross | Identity claim from OIDC profile scope |
| `nonce` | 12345 | Echoed back — proves this token answers this specific request |
| `oid` | Object ID | Unique identifier for this user in Entra |
| `tid` | Tenant ID | Confirms token issued from Boclair Industries tenant |
| `ver` | 2.0 | Confirms v2.0 endpoint (modern OIDC-compliant) |

**Key observation:** The `email` and `name` claims are present because the `profile` and `email` scopes were requested. These are OIDC identity claims — this is the "who the user is" piece that OIDC adds on top of OAuth.

---

## Part 3 — Authorization Code Flow

### What It Is

The Authorization Code Flow is the modern, secure default for OAuth 2.0/OIDC. It separates the authentication process into two steps to keep tokens out of the browser entirely.

**Step 1:** User authenticates → Entra returns a short-lived, single-use **authorization code** in the browser URL (not a token).

**Step 2:** App's backend exchanges the code for tokens via a direct server-to-server POST request to Entra's token endpoint. Tokens never appear in a browser URL.

### Why It's More Secure Than Implicit Flow

| Risk | Implicit Flow | Authorization Code Flow |
|---|---|---|
| Token in browser URL | Yes — accessible to history, extensions, logs | No — code only, not a token |
| Code usable by attacker | N/A | No — code requires client secret to exchange |
| Token delivery | Browser | Server-to-server only |

### Step 1: Build the Authorization Code Request

```
https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/authorize
  ?client_id={client-id}
  &response_type=code
  &redirect_uri=https://jwt.ms
  &scope=openid profile email
  &response_mode=query
  &state=12345
```

**Key differences from implicit flow URL:**

| Parameter | Implicit Flow | Authorization Code Flow |
|---|---|---|
| `response_type` | `id_token` | `code` |
| `response_mode` | fragment (default) | `query` (returns code as URL parameter) |

### Step 2: Receive the Authorization Code

After authentication, browser redirected to:

```
https://jwt.ms/?code=1.AWEBcLDH...&state=12345&session_state=...
```

**Key observations:**
- jwt.ms page was **blank** — no token to decode because no token was returned
- The `code` value is a long opaque string — not a JWT, not decodable, not useful on its own
- `state=12345` echoed back exactly as sent — proves response matches the specific request
- The code expires in approximately 60 seconds — single use only

### Step 3: Token Exchange (Server-to-Server)

Step 2 requires a POST request to Entra's token endpoint:

```
POST https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token

Body:
  client_id={client-id}
  client_secret={secret}
  code={authorization-code}
  redirect_uri=https://jwt.ms
  grant_type=authorization_code
  scope=openid profile email
```

**CORS observation:** Attempting to make this POST request from a browser-based script failed with a CORS (Cross-Origin Resource Sharing) error. This is intentional and demonstrates the security model working correctly — browsers are explicitly blocked from making this call. Only a backend server can complete Step 2, which is exactly the point of the Authorization Code Flow.

**Expected response (server-side):**
```json
{
  "access_token": "eyJ...",
  "id_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "openid profile email"
}
```

Both the OAuth access token and the OIDC ID token are returned together in the private exchange.

---

## Key Takeaways

**On protocols:**
- OAuth 2.0 and OIDC are not alternatives — they work together. OAuth handles authorization (access tokens for API calls), OIDC handles identity (ID tokens proving who the user is).
- SAML and WS-Fed solve the same authentication problem but use a completely different architecture — XML-based signed assertions with no token economy. These are associated with AD FS and legacy federation, not modern app registrations.

**On flow security:**
- Implicit flow is disabled by default in Entra because tokens in browser URLs are a security risk. It must be explicitly enabled — and in production should generally be avoided.
- Authorization Code Flow keeps tokens out of the browser by design. The CORS error when attempting Step 2 from a browser is not a misconfiguration — it is the security model enforcing that token exchange must happen server-side.

**On app registration configuration:**
- Redirect URI lives in **App Registrations → Authentication blade** — this is where Entra validates that token responses are only sent to pre-approved destinations.
- Client secrets live in **Certificates & secrets** — they authenticate the app itself during Step 2 of the Authorization Code Flow.
- API permissions live in **App Registrations → API Permissions** — separate from authentication config.

---

## Exam Relevance (SC-300)

| Blueprint Objective | Where This Lab Covers It |
|---|---|
| Configure app authentication | Redirect URI, implicit grant toggle, client secret |
| Plan for app registrations | App registration structure, Authentication vs API Permissions blades |
| Implement and manage user authentication | OIDC sign-in flow, ID token claims, nonce validation |
| Configure API permissions | Scope selection (openid, profile, email) |

---

*Lab completed: July 2, 2026*
*Tenant: Boclair Industries (BoclairIndustries.onmicrosoft.com)*
*Lab series: github.com/Prediket07/IAM-labs-entra-id*
