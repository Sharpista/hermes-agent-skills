# Browser Native Input Workarounds

Session-derived notes for QA of forms with native date/time controls.

## What worked in practice
- For `<input type="date">` and `<input type="time">` controls that `browser_type` cannot reliably populate, focus the native input and then use a browser-console expression against `document.activeElement` to assign `value` and dispatch both `input` and `change` events.
- Example pattern:
  1. focus the input in the browser
  2. set `document.activeElement.value = '2026-07-24'` or `'09:30'`
  3. dispatch `input` and `change`
  4. confirm the displayed value with a snapshot and, for mirrored forms, check the preview/summary card too

## When to use
- Appointment scheduling fields
- Same-day or future-date business rules
- Edit flows where the form loads but save still rejects the payload

## Caution
- Some browser-console expressions are blocked when they inspect sensitive form state. If that happens, use snapshots/visual inspection for read-only validation and reserve console evaluation for trusted, necessary mutations on the active element.
- Do not treat a successful typing command as proof the control accepted the value; verify the rendered state before continuing.
