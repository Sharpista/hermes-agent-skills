# Fresh JWT timing when validating 403

Session note:
- In an end-to-end auth QA pass, a token obtained from a successful login may still be rejected immediately by a protected endpoint if the JWT `notBefore` / clock timing is a few seconds ahead of the follow-up request.
- The symptom can look like `401 Unauthorized` or `invalid_token` on the first protected call, even though the login itself succeeded.

Practical validation rule:
1. If login succeeds but the first protected call returns `401 invalid_token`, pause briefly and retry before concluding the auth path is broken.
2. Prefer browser-driven validation for the redirect/login part, then re-run the protected endpoint after the session has fully settled.
3. Only classify the `403` scenario after you have a confirmed valid token and the failure is clearly authorization-related, not token-validity timing.

Useful when:
- QA is proving a new role-protected endpoint exists solely to make a deterministic `403`.
- Backend and frontend are both correct, but the first manual curl lands too quickly after login.
