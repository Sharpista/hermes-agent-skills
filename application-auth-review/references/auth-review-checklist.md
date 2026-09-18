# Auth / JWT code-review checklist

Session-derived heuristics for reviewing login + JWT changes in full-stack apps.

## Backend
- Verify secrets are not committed to source control (`SigningKey`, default admin creds, API keys).
- Prefer environment variables or secret stores; fail startup in non-dev when auth config is missing.
- Ensure protected endpoints actually require auth (`[Authorize]`, auth middleware order, CORS does not bypass auth).
- Check 401/403 responses are consistent and do not leak sensitive details.
- Test login success, login failure, unauthorized access, and token-protected CRUD paths.

## Frontend
- Avoid storing bearer tokens in `localStorage` unless the threat model explicitly accepts XSS exposure.
- Confirm login, guard, and interceptor agree on the same session-expiry behavior.
- On 401, redirect or reauthenticate consistently; do not convert auth failures into generic app errors.
- Validate `returnUrl` before redirecting after login.
- Add tests for: valid login, invalid login, expired token, guard redirect, interceptor 401 handling.

## Review focus
- Security: secret handling, token storage, XSS exposure.
- Integration: backend token claims/issuer/audience vs frontend expectations.
- Maintainability: centralize auth session logic in one service and keep interceptors thin.
