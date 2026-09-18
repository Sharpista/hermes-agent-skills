# Session auth/hardening QA notes (2026-08)

## What was verified
- Backend build + tests can be green while browser login still needs separate confirmation.
- API evidence collected:
  - `POST /api/auth/login` valid -> 200 + token
  - invalid login -> 401 `application/problem+json`
  - protected route without token -> 401
  - admin-only route with non-admin token -> 403
  - login rate limiting -> 429 on repeated attempts
- Frontend build can succeed independently of auth-flow correctness.

## Workflow lesson
- Do not approve auth hardening from backend success alone.
- In the browser, verify the full chain in the same session:
  1. invalid login shows the expected error;
  2. valid login leaves `/login` and reaches a protected route;
  3. direct navigation to a protected route is blocked when anonymous;
  4. logout clears access and returns to anonymous state.

## Pitfall
- If the SPA stays on the login page after a valid credential attempt, treat that as a frontend/integration blocker until the redirect/session state is confirmed.
- If the browser seems to show stale state, refresh/reopen the session before classifying the auth issue.

## Evidence format
Record both API and browser results. If the browser login cannot be confirmed, mark the QA as blocked even when backend API tests are green.
