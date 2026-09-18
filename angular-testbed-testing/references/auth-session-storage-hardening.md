# Auth session storage hardening (Angular)

Use this pattern when reducing JWT/session exposure without changing the backend.

## Incremental choice
- Prefer `sessionStorage` over `localStorage` for MVP hardening when the app must keep browser-refresh restore in the current tab.
- Keep login/logout flow unchanged.
- Keep `hasValidSession()` / expiry behavior unchanged.

## Test expectations
- Login writes the session to `sessionStorage`.
- Service initialization restores from `sessionStorage`.
- Logout removes the stored session.
- Expired sessions are cleared and do not remain persisted.
- Add one assertion that `localStorage` is not used for the session key, to prevent regression back to the more exposed store.

## Ad hoc verification
When a repo has no obvious single test command for the exact change, create a temporary script under `/tmp` with a `hermes-verify-` prefix via `tempfile`, run only the focused spec plus the build, then remove the script if possible.

Treat this as targeted verification, not as a claim that the full suite is green.
