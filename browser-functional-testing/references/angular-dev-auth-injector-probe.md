# Angular dev-mode auth probe for QA

Use this when validating SPA auth state in an Angular dev build and you want to avoid relying on browser storage inspection.

## Why this pattern
- It exercises the app's own auth service instead of mutating storage directly.
- It works well for memory-backed sessions and for confirming logout/expiry behavior.
- It is a QA probe, not an application requirement.

## Probe
```js
(() => {
  const root = document.querySelector('app-root');
  const injector = window.ng.getInjector(root);
  const parent = injector._lView[9].parentInjector;
  const providers = window.ng.ɵgetInjectorProviders(parent);
  const authToken = providers.find(p => (p.token?.name || '') === '_AuthService').token;
  const auth = parent.get(authToken);
  auth.logout(false);
  return {
    path: location.pathname,
    valid: auth.hasValidSession(),
    token: auth.accessToken(),
    expiresAt: auth.expiresAt(),
    user: auth.currentUser()
  };
})()
```

## Expected QA outcomes
- `valid` becomes `false` and session fields become `null` after logout.
- The current route does not necessarily change immediately when `redirectToLogin = false`.
- Re-navigating to a protected route should re-trigger the guard and redirect to login.
- A page reload on a protected route should land on `/login` when no session is active.

## Notes
- Prefer this probe when validating session reset, logout, and reload behavior in dev builds.
- Use the app's own route flow to confirm protection after the session is cleared.
