# Ad-hoc shell logout smoke pattern

Use this when an Angular operational shell needs a visible logout control and there is no single canonical test covering the behavior.

## What to verify

1. The shell header exposes a visible logout action in the authenticated view.
2. Clicking logout calls the app’s existing `AuthService.logout()` path.
3. The service clears session state and redirects to `/login`.
4. The post-build artifact contains the new shell action so the change is actually compiled.
5. A quick browser smoke test confirms the UI returns to the login route after logout.

## Recommended ad-hoc script shape

Create a temporary script under `/tmp` with an OS-safe prefix, for example via `mktemp /tmp/hermes-verify-XXXXXX.sh`.

The script should:

- run the frontend build
- inspect the generated bundle for the new logout/session symbols or labels
- fail fast if the expected artifact is missing
- print a short success line on completion

This is ad-hoc verification, not suite green.

## Notes

- Prefer the app-level logout button over direct storage mutation when smoke-testing auth state.
- If browser JS storage introspection is blocked, validate behavior end-to-end instead of forcing it.
- When the logout action is in the shell header, a login → protected route → logout → `/login` loop is the cleanest proof.
