# Angular edit-flow route validation notes

Session-derived notes for validating list → edit → save → list flows in Angular operational apps.

## When to use
- A row action looks clickable but the browser snapshot does not show route change after `browser_click`.
- The app uses Material buttons / cards in a dense list and there are multiple similar "Editar" actions on screen.
- You need to confirm that the edit flow actually navigates, saves, and persists.

## Reliable sequence
1. Log in and open the list page.
2. Click the specific row-level edit action for the target record.
3. Immediately verify navigation by checking the current path.
4. If the click appears to noop, inspect the live DOM button list and trigger the exact button element with a DOM click.
5. Edit a non-critical field, save, and confirm the success message / toast.
6. Return to the list, reopen the same record, and verify the edited value persisted.
7. Clear the console and confirm no JS errors appeared during the flow.

## Practical verification snippets
- Path check: `location.pathname`
- Button inventory: `Array.from(document.querySelectorAll('button')).map((b, i) => ({ i, text: b.textContent.trim(), disabled: b.disabled }))`

## Pitfalls
- A stale browser snapshot can make it look like the route never changed; always verify the pathname after the click.
- If there are multiple edit buttons, the first matching label may not be the intended row action.
- Prefer verifying persistence by reopening the edited record, not just by trusting the list toast.
