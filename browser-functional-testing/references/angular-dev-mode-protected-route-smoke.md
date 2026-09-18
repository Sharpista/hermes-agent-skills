# Angular dev-mode protected-route smoke

Session note for frontend QA when the browser is on a trusted local dev build and backend access is limited.

## Useful probe pattern
1. Open the login page.
2. Use `window.ng.getComponent(document.querySelector('app-login'))` to inspect the live component.
3. If needed, inspect the injected auth service state via the component instance.
4. Confirm the guard behavior by navigating to a protected route and observing whether the SPA returns to `/login?returnUrl=...`.
5. Validate that `hasValidSession()` and the router URL agree with the visible screen.

## Practical takeaway
- Protected-route redirects can be verified without a live backend response if the shell and guard logic are already running in the browser.
- For local QA, prefer checking component/service state and visible route behavior over mutating storage directly.
- Always re-check with `browser_snapshot()` after a navigation or state change; a successful navigation call alone is not proof of the rendered state.
