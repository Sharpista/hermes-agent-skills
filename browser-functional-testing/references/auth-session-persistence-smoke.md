# Auth session persistence smoke

Use this checklist when validating login flows where the UI has a "Lembrar de mim" option or the reviewer reports that auth is lost after reload/direct navigation.

## What to verify

1. Login succeeds and the app redirects to the protected route.
2. Refresh the page on the protected route.
   - Expected: the user remains authenticated if the session is still valid.
3. Navigate directly to the protected route in the same browser/tab.
   - Expected: the guard/interceptor still sees a valid session.
4. Toggle "Lembrar de mim" and repeat the login.
   - Expected when enabled: the session survives browser restart because it is restored from persistent browser storage.
   - Expected when disabled: the session should still survive reload in the current browser session, but should not be treated as a cross-restart promise unless the implementation explicitly uses persistent storage.
5. Log out.
   - Expected: in-memory auth state and persisted browser storage are both cleared.

## UI copy guidance

- Avoid promising "sessão persistente" unless the implementation truly restores auth from browser storage.
- Prefer wording like:
  - "A sessão fica disponível neste navegador"
  - "Lembrar de mim neste navegador"
  - "Salva no dispositivo" only when persistent storage is actually used.

## Common regression pattern

A login component can appear correct while auth still disappears after reload because the app only keeps the token in memory.
In that case, verify the service layer first:

- does the auth service restore state during construction?
- does it persist on login?
- does logout clear both memory and storage?
- do guard/interceptor checks read the restored state, not just a fresh component field?
