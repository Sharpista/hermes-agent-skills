# Angular Dev-Mode Browser QA Notes (Consultas MVP, 2026-09-01)

## What mattered in this session
- The frontend dev server was already up on `http://127.0.0.1:4200` and the backend target for QA was `http://127.0.0.1:5053`.
- A quick config sanity check is important when there are multiple local backends. In this run, the Angular dev environment still pointed to `http://localhost:5052/api` while the QA target was `5053`.
- The app's login component can be inspected in dev mode via `window.ng.getComponent(document.querySelector('app-login'))`.

## Useful browser-first probe
When a submit click seems to do nothing, inspect the component directly:

```js
const c = window.ng.getComponent(document.querySelector('app-login'));
{
  value: c.form.getRawValue(),
  valid: c.form.valid,
  errors: c.form.errors,
  loading: c.loading(),
  erro: c.erro(),
  returnUrl: c.returnUrl(),
  auth: {
    hasValidSession: c.authService.hasValidSession(),
    token: c.authService.accessToken(),
    user: c.authService.currentUser(),
    expiresAt: c.authService.expiresAt()
  }
}
```

## Session-level takeaway
Use browser/dev-mode component state as the source of truth before labeling a login/navigation bug, especially when the UI is rendered but the route does not advance. Confirm the API base URL matches the intended backend before filing an integration defect.
