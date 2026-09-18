# End-to-end 403 scenario for QA

Session learning:
- A functional 403 is easiest to validate when the backend exposes an authenticated endpoint that requires a role/claim the normal login does not grant.
- The login flow should continue issuing a valid JWT for the default user; the 403 must come from authorization, not from invalid credentials or expired tokens.

Recommended pattern:
1. Keep the existing JWT login unchanged.
2. Add a dedicated endpoint under an already-protected controller.
3. Protect it with a role policy, e.g. `Authorize(Roles = "Administrador")`.
4. Ensure the standard login token does not include that role claim.
5. Verify with an integration test that:
   - no token -> 401
   - valid token, wrong/missing role -> 403
   - valid token with role (if you later add one) -> 200

QA usage guidance:
- For end-to-end validation, call the endpoint with a valid bearer token from the normal login.
- Expect 403 and do not treat this as an auth failure; it is the intended authorization denial.

Pitfall:
- Do not fake 403 by returning it manually from the controller unless the product explicitly requires a custom business rule. Prefer a real authorization failure so middleware, policies, and frontend handling are exercised together.
