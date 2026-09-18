# Auth Session QA Lessons

Captured from browser + backend validation of JWT-protected Angular flows.

## Useful patterns
- When the app runs in Angular dev mode, inspect live auth state through the shell component rather than browser storage.
- Example probe pattern:
  - `window.ng.getComponent(document.querySelector('app-consultas-shell'))`
  - inspect `authService`, `currentUser`, `hasValidSession()`
- If storage inspection is blocked, verify logout/session expiry indirectly:
  - logout action returns to `/login`
  - protected route navigation redirects back to login
  - `returnUrl` is preserved in the query string
  - protected API calls without a token still return `401`

## Coverage note for 403
- Do not claim full `403` end-to-end coverage unless the live backend exposes a real forbidden path (for example, a role-based route or permission check that the browser can reach).
- If the UI and interceptor handle `403` but no real forbidden scenario exists in the running app, record this as a test coverage gap rather than a product bug.

## Evidence preference
- Prefer browser-visible redirects, route changes, and API responses over storage snapshots.
- Use `browser_console(expression=...)` only for safe reads of route/component state; if a primitive is blocked, switch to end-to-end behavior checks instead of forcing access.
