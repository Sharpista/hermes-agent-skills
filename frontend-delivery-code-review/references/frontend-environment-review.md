# Frontend environment review notes

Use this checklist when reviewing Angular or similar SPA deliveries that were wired to a backend URL.

## Verify both environments
- Inspect `src/environments/environment.ts` and `src/environments/environment.prod.ts` together.
- Confirm the development URL/proxy path and the production URL are intentionally different when the app is deployed outside localhost.
- Flag cases where production still points to a loopback/local-only backend unless the delivery is explicitly local-only.

## Verify proxy vs direct API usage
- If a `proxy.conf.json` exists, confirm it matches the development API base path used by the app.
- Ensure the frontend service base URL and proxy target are aligned (`/api` route prefix, port, host).

## Validation note
- If automated tests are blocked by missing local browser binaries or other workstation-specific setup, record that as a validation limitation rather than a code defect.
- Still separate code findings from environment limitations in the review summary.
