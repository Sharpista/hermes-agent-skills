---
name: application-auth-review
description: "Review application authentication and authorization changes across backend and frontend for security, integration, and maintainability."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [code-review, security, auth, jwt, frontend, backend, review]
---

# Application Auth Review

Use this skill when reviewing login, JWT/session handling, auth guards/interceptors, protected endpoints, or any backend/frontend authentication change.

## Primary goals

1. Verify the auth model is secure enough for the stated threat model.
2. Verify backend and frontend agree on issuer, audience, claims, expiry, and 401 behavior.
3. Verify the UX for login/logout/expiry is coherent.
4. Verify tests cover the failure modes that matter.

## Review workflow

### 1) Map the auth flow end-to-end

Identify:
- login endpoint(s)
- token/session issuance
- where the token is stored
- how requests attach auth
- how protected routes reject unauthenticated users
- how 401 responses are handled and surfaced
- how logout/session expiry is triggered

### 2) Backend security checks

Check for:
- secrets or default credentials committed in code or config
- weak signing keys or hardcoded development values that could reach production
- JWT validation configured with issuer, audience, signature, and lifetime checks
- auth middleware registered before authorization and controller mapping
- protected endpoints actually decorated/configured as protected
- rate limiting or abuse controls are present where login or protected APIs are brute-force sensitive
- error responses that avoid leaking sensitive auth details

### 3) Frontend security checks

Check for:
- token storage choice and exposure to XSS
- whether JWT/session state is intentionally memory-only or persisted, and whether that matches the threat model
- session restore logic and expiry handling
- guard/interceptor alignment with the login flow
- returnUrl validation before redirect
- logout clearing both in-memory and persisted auth state
- any hidden constructor/init path that silently restores auth from browser storage

If the design is memory-only, see `references/session-memory-auth.md` for the review checklist.

### 3b) Auth/config hardening checks

When the change is about auth hardening or startup config, explicitly verify:
- whether the session is stored in `sessionStorage` or `localStorage`, and whether that matches the stated threat model
- whether restore logic rejects expired or malformed sessions and clears persisted state on failure
- whether the same validity source is used by the service, guard, and interceptor
- whether auth defaults are absent from checked-in prod config and come from user-secrets/env vars instead
- whether startup validation fails fast when required auth settings are missing
- whether production environment files still point to `localhost` or dev-only CORS origins
- whether the frontend keeps long-lived JWTs out of `localStorage` in hardened production builds, while still allowing a dev/test path for session persistence when that is part of the scenario
- whether 401/403 responses are emitted as `ProblemDetails` and are compatible with the frontend's error handling
- whether JWT bearer event hooks use APIs available in the target ASP.NET Core SDK; if an overload is missing, serialize explicitly instead of depending on a newer helper
- whether login and authenticated routes both have rate limiting, and whether tests assert the 429 path

See `references/auth-config-hardening.md` for the compact review checklist and evidence to gather.
See `references/jwt-hardening-401-403-rate-limit.md` for session-specific notes and pitfalls from the JWT/HTTPS/rate-limiting hardening pass.

### 4) Integration checks

Confirm:
- frontend sends the same bearer token that backend validates
- token expiry and clock skew assumptions are compatible
- 401 handling is consistent across pages, guards, and HTTP services
- refresh/login flows do not create redirect loops
- UI filters or summaries based on "Hoje" / current date are recomputed safely (avoid module-scope snapshots that go stale after midnight)

### 5) Test quality checks

Prefer concrete tests for:
- valid login
- invalid login
- unauthorized access to protected endpoints
- authenticated CRUD path
- expired token/session handling
- guard redirect and interceptor 401 behavior
- controller/integration tests that explicitly authenticate when endpoints are protected
- rate-limit coverage for login or other brute-force-sensitive endpoints, including a 429 assertion
- at least one real authorization-denial path that returns 403 from the framework (for example, a role/claim-protected endpoint hit with a valid token that lacks the required role)

See `references/end-to-end-403.md` for the minimal pattern used to create a predictable QA-validatable 403 without disturbing the existing login/401/429 flows.

If browser QA passes but backend controller tests suddenly return `401 Unauthorized`, first verify whether the test harness is missing authentication rather than assuming the application regressed.

See `references/time-sensitive-ui-and-auth-qa.md` for session-derived notes on midnight rollover risk, authenticated test clients, and dev-only auth hardening reminders.

## Severity guidance

- **High**: secrets, auth bypass, missing auth enforcement, unsafe token handling with clear exploit path
- **Medium**: inconsistent 401 behavior, fragile session restore, insufficient validation, missing tests for critical branches
- **Low**: naming, duplication, minor UX issues, refactoring opportunities

## Output expectations

For auth reviews, list:
- reviewed files
- findings by severity
- decision: Approved / Rejected / Blocked
- concrete fix directions for the responsible agent

## Pitfalls

- Do not treat `localStorage` as harmless; call out the XSS exposure explicitly.
- Do not assume a login page implies endpoint protection; verify the protected controllers.
- Do not accept a JWT config that is correct only in development if it can ship unchanged.
- Do not stop at backend validation; check frontend interceptor/guard alignment.
- Do not count existing tests as sufficient unless they cover auth failure paths too.
- Do not treat a fresh wave of 401s in backend tests as a product defect until you confirm the test client is authenticated.
- Do not confuse token-validity timing with authorization: if a newly issued JWT comes back as `401 invalid_token` on the first protected call, wait briefly and retry before deciding the role-protected `403` path is broken.
- If valid login returns 200 but the browser stays on the login page or the next protected request fails immediately, inspect token issuance for an overly strict `notBefore`/clock-skew combination before blaming the frontend guard.
- Do not miss time-sensitive UI snapshots: if a "Hoje" filter or dashboard summary is anchored once at module load, note the midnight rollover risk as a low-severity residual even after the timezone fix.
- Do not overlook memory-only auth designs: a service that still restores from `sessionStorage` or `localStorage` defeats the security goal even if login/logout appear to work.
- If production moved away from `localStorage` but still uses `sessionStorage`, treat that as a risk reduction, not a full mitigation; call out the remaining XSS-readability exposure explicitly.

## Compact checklist

- Login success and invalid-login behavior match the UX claim.
- Guard redirects unauthenticated users to login with a sane return URL.
- Interceptor attaches the bearer token to non-login requests.
- Session restore clears expired or malformed state, or is absent entirely when the design is memory-only.
- Backend validates issuer, audience, signature, and lifetime.
- Protected endpoint tests include a valid authenticated client.
- A 401 in test output is triaged as auth coverage before being called a functional regression.
