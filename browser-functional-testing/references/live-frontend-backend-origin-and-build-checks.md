# Live frontend/backend origin and build checks

## When to use
Use this note during manual browser QA when the API works in curl/tests but the UI login or CRUD flow fails in the browser.

## Checklist
1. Confirm the browser is pointed at the intended frontend instance and port.
2. Confirm the frontend build currently running is the one you just changed; do not trust an older dev-server tab or a stale process on another port.
3. Confirm `environment.apiUrl` matches the backend origin you are actually running.
4. Confirm backend CORS allows the frontend origin you are using for QA.
5. If API tests pass but the browser flow fails, capture the browser console and the network/response status before blaming the UI component.
6. If the browser login succeeds at the API level but not in the UI, treat origin mismatch/CORS/stale process as the first hypothesis.

## Session note
In this session, the QA pass initially hit a stale frontend process on another port, then a browser login failure that was caused by the frontend origin not matching the backend CORS policy. The durable lesson is to validate the running origin/build pair before concluding a functional regression.
