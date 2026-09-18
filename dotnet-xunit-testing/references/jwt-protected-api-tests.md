# JWT-protected API tests (session note)

Use this pattern when the ASP.NET Core API now requires Bearer auth on existing endpoints:

1. Call `/api/auth/login` with known test credentials.
2. Read `accessToken` from the JSON response.
3. Attach `Authorization: Bearer <token>` to the `HttpClient`.
4. Assert the unauthenticated request returns `401` before testing the happy path.

Example contract used in this session:

```json
POST /api/auth/login
{ "email": "admin@consulta.local", "senha": "Admin@123" }
```

Expected response shape:

```json
{
  "accessToken": "...",
  "expiresAt": "2026-07-13T22:36:20.2895807+00:00",
  "user": {
    "id": "11111111-1111-1111-1111-111111111111",
    "nome": "Administrador",
    "email": "admin@consulta.local"
  }
}
```

## Small but useful test reminders

- Keep a dedicated integration test for `401` without a token; don't rely only on the happy path.
- If the API uses date/time parsing, prefer explicit invariant parsing in the service and include a valid future timestamp in the test payload.
- For auth-backed controller tests, isolate the login step so the token setup is obvious and reusable.
