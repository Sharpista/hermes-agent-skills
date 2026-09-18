# Shell logout + auth/session review notes

Use this note when reviewing Angular SPAs with a protected shell/header and visible logout.

## Review sequence
1. Confirm the protected shell is part of the guarded route tree, not only the child page.
2. Verify the logout control is rendered on protected pages where users actually operate.
3. Check the auth chain together:
   - login response stores token + expiry + user
   - session restore happens on reload/direct navigation
   - guard blocks anonymous access
   - interceptor adds the bearer token to API calls
   - logout clears storage/signals and redirects away from protected routes
4. Re-check list/form flows after logout to ensure anonymous access is blocked again.

## Review pitfall
A polished protected page is not enough. If the logout action is hidden outside the active shell, or the guard/interceptor still accepts a stale session, treat it as an auth regression even if the rest of the UI looks correct.
