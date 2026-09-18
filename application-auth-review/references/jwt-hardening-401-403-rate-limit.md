# JWT / HTTPS / rate limiting hardening notes

Session-derived checklist for backend auth hardening in ASP.NET Core.

## What to verify
- JWT validation:
  - issuer
  - audience
  - signing key
  - lifetime / zero clock skew when appropriate for the test surface
- 401 vs 403:
  - `401 Unauthorized` for missing / invalid / expired bearer token
  - `403 Forbidden` for authenticated users missing the required role/claim
- Response shape:
  - prefer `application/problem+json` + `ProblemDetails` for auth failures
  - keep messages generic enough not to leak token details
- HTTPS:
  - `UseHttpsRedirection()` enabled outside test environments
  - `UseHsts()` enabled outside development/test if the app is expected to run behind HTTPS
- Rate limiting:
  - login endpoint limited by IP or equivalent partition key
  - authenticated endpoints limited enough to reduce abuse without blocking normal UI use
- Frontend compatibility:
  - Angular should continue sending the same bearer token
  - no new redirect loops on 401/403

## Pitfall encountered
- When customizing `JwtBearerEvents`, do not assume every SDK exposes the same `WriteAsJsonAsync` overloads.
  - If a helper overload is missing, serialize explicitly with `JsonSerializer.Serialize(...)` and write the response body manually.
  - Keep the response content type explicitly set to `application/problem+json`.

## Test expectations
- Assert `401` for expired token and no token.
- Assert `403` for a valid token without the admin role.
- Assert at least one `429 Too Many Requests` path for login or another sensitive endpoint.
- In test factories, keep a deterministic auth user/token source so `401` failures are auth failures, not test data drift.
