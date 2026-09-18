# Auth / configuration hardening notes

Session-derived review points for auth and configuration hardening in MVPs.

## Checklist
- Prefer `sessionStorage` over `localStorage` when the goal is to avoid long-lived token persistence. Still treat both as JS-accessible and XSS-exposed.
- Verify session restore rejects expired or malformed payloads and clears storage on failure.
- Ensure the same validity source powers login state, guards, and interceptors.
- Confirm auth defaults are not present in checked-in production config.
- Confirm required auth settings come from user-secrets or environment variables and startup validation fails fast.
- Flag production environment files that still point to `localhost` or dev-only CORS origins.
- Treat `HttpOnly` cookie migration as an architectural follow-up when the threat model requires stronger XSS resistance.

## Evidence that is worth collecting
- `dotnet user-secrets list`
- `appsettings.json`, `appsettings.Development.json`, and launch settings
- frontend auth service, interceptor, guard, and login flow
- test factory / harness configuration for injected auth env vars

## Review wording
- **Aprovado com ressalvas** if the app is functionally correct but still uses JS-accessible token storage or localhost production defaults.
- **Bloqueado/Reprovado** if auth secrets are hardcoded or startup accepts missing auth configuration.
