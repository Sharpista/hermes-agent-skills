# Time-sensitive UI + auth QA notes

Session-derived reminders for auth/consultation reviews:

- If QA validates a "Hoje" filter or summary, check whether the date anchor is computed once at module load. A module-scope `TODAY` constant is fine for a short-lived page session, but it can drift after midnight if the screen stays open.
- A good residual-risk callout is usually low severity, not a blocker, when the local-time fix is otherwise correct and tested.
- For backend auth integration tests, confirm there is a helper that explicitly authenticates the test client before protected endpoint calls. A `401` in tests is often missing test auth coverage, not a product regression.
- When the frontend stores JWT session state in `localStorage`, mention XSS exposure as a production hardening note even if the MVP flow is consistent.
- Dev-only auth defaults (issuer/audience/signing key/demo user) should be called out as environment hardening items, not as functional defects, unless they can reach production unchanged.
