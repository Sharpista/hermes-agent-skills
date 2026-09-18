# Auth Session Hardening QA — August 2026

## What this session proved
Use the **same browser session** to validate the full auth chain after backend JWT fixes:
1. Login with valid credentials.
2. Confirm redirect into the protected area (not just a 200 from the API).
3. Confirm invalid credentials keep the user on the login screen with a coherent inline error.
4. Hit a protected endpoint without a token and verify **401**.
5. Hit a protected admin-only endpoint with a non-admin token and verify **403**.
6. Exercise rate limiting on login and verify **429**.
7. Logout and confirm a direct navigation to the protected route returns to login.

## Evidence pattern to record
- Browser snapshot after valid login shows the protected shell and logged-in identity.
- Browser snapshot after invalid login shows the login alert/error message.
- curl or API probe output for 401/403/429 should be captured alongside browser evidence.
- If the frontend and backend disagree, trust the live browser flow only after confirming the running frontend is talking to the expected backend origin.

## QA takeaway
Backend JWT success is necessary but not sufficient. For hardening approval, prove the **browser redirect**, **protected-route access**, **logout reset**, and **anonymous return** in one real session.
