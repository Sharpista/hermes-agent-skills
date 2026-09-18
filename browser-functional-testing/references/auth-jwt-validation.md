# JWT Auth Validation Notes

This reference captures a repeatable validation recipe for apps with backend JWT auth + frontend route protection.

## Observed pattern
- Backend exposes `POST /api/auth/login` returning `accessToken`, `expiresAt`, and user metadata.
- Protected API routes require `Authorization: Bearer <token>` and return `401` without it.
- Frontend uses a login page, an auth service/session store, a route guard, and an HTTP interceptor that injects the bearer token.
- Logout should clear the session and return the user to the login screen; protected routes should redirect back to login when session is absent.

## Validation recipe
1. **Login invalid**
   - POST login with wrong password.
   - Expect `401 Unauthorized` and a human-readable error payload.
2. **Login valid**
   - POST login with valid credentials.
   - Expect `200 OK` and a non-empty JWT.
3. **Missing token**
   - Call protected endpoints without `Authorization`.
   - Expect `401 Unauthorized`.
4. **Valid token**
   - Call protected endpoints with `Bearer <token>`.
   - Expect normal flow / `200` or `201` depending on the endpoint.
5. **Frontend route protection**
   - Open protected route without session.
   - Expect redirect to `/login` (or equivalent).
6. **Logout**
   - Trigger logout.
   - Expect UI to leave protected area and subsequent protected navigation to fail/redirect.

## Practical QA notes
- Prefer backend curl/HTTP validation for token semantics and frontend browser validation for redirect/UI behavior.
- If direct storage inspection is blocked or awkward, validate logout indirectly by:
  - confirming the UI returns to login,
  - refreshing / opening a protected route,
  - confirming the guard redirects to login,
  - and confirming protected API calls without a token return 401.
- Record the credential set used in the report so the flow is reproducible.
