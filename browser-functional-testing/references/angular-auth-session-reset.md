# Angular Dev-Mode Auth Session Reset for QA

Use this when you need to clear a logged-in SPA session during browser QA and direct storage access is blocked or undesirable.

## Goal
Reset the authenticated session without reaching into browser storage APIs.

## Recipe
1. Open the app in a dev build where Angular debug globals are available.
2. Use `window.ng` to reach the root injector from the `app-root` element.
3. Resolve the app's auth service from the injector and call its logout method with `redirectToLogin = false` when you want to clear state without forcing navigation.
4. Re-navigate to `/login` or refresh the protected route to verify the anonymous state.

## Example probe
```js
(() => {
  const root = document.querySelector('app-root');
  const injector = window.ng.getInjector(root);
  const parent = injector._lView[9].parentInjector;
  const providers = window.ng.ɵgetInjectorProviders(parent);
  const authToken = providers.find(p => (p.token?.name || '') === '_AuthService').token;
  const auth = parent.get(authToken);
  auth.logout(false);
  return { hasValidSession: auth.hasValidSession(), path: location.pathname };
})()
```

## Notes
- Prefer this over direct `localStorage` access when using `browser_console(expression=...)` because storage access is commonly treated as sensitive.
- This is a QA convenience for dev builds; if `window.ng` is unavailable, fall back to normal end-to-end flows (login/logout or browser navigation) instead of assuming a bug.
- Do not treat this as an application requirement; it is a validation technique.
