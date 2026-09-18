# Session memory auth review notes

Use this when the frontend auth model intentionally keeps JWT/session state only in memory.

## Review questions
- Does login populate only in-memory state?
- Does logout clear in-memory state and leave no persisted token behind?
- Does initialization avoid reading from `localStorage` or `sessionStorage`?
- Are guard/interceptor checks based on live auth state rather than storage presence?
- Is losing auth on reload an accepted trade-off in the product decision?

## What to verify in tests
- Login succeeds in the active tab.
- A fresh service instance starts unauthenticated even if storage contains old auth data.
- `sessionStorage` and `localStorage` are both empty after login/logout flows.
- Any expiry timer still logs out the live tab.

## Review pitfall
A service constructor that silently restores from storage reintroduces the exact residual exposure this pattern is trying to remove.
