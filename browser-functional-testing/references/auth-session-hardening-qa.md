# Auth Session Hardening QA

Use this checklist when validating SPA auth changes that switch persistence strategy or tighten session handling.

## What to verify
1. **Login works** with valid credentials.
2. **Protected route opens** immediately after login.
3. **Same-tab refresh restores session** when the stored session is still valid.
4. **Logout clears session state** and returns the app to anonymous behavior.
5. **Expired session is rejected** on the next check or request.
6. **401 handling is coherent**: the app redirects to login or shows an anonymous state without leaving stale auth data behind.

## Evidence to collect
- Browser snapshot showing the protected route after login.
- Console output with no uncaught JS errors during the flow.
- Visible redirect back to `/login` after logout or expiry.
- If available, unit tests that cover restore/expiry/logout edge cases.

## Practical notes
- Prefer end-to-end behavior over direct storage inspection when browser safety blocks `browser_console(expression=...)`.
- For `sessionStorage`-based auth, verify **same-tab** restore; do not assume another tab shares the session.
- A valid login that cannot reach a protected route is a functional failure, even if the UI looks polished.
