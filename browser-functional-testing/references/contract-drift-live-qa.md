# Contract-drift live QA notes

Session lesson:
- A backend test suite can pass while the live running API still rejects the frontend payload.
- In this session, `POST /api/consultas` returned `400 Bad Request` with `DataHorario é obrigatório` when called with the frontend's `data` + `hora` payload.
- The backend tests were green because they exercised the DTO/service path, but the live app still required the contract to be confirmed against the running instance.

Recommended workflow:
1. Login and capture a bearer token from the live API.
2. Send the exact payload the frontend emits.
3. Compare the request body field names with the DTO and any model-binding / validation messages from the live response.
4. If create/edit fails, verify both the browser payload and the live endpoint before concluding the UI is at fault.
5. Record whether the failure is a contract mismatch, validation rule, or environment mismatch.

Signals worth calling out in reports:
- `400` with validation detail naming a missing server-only field.
- UI build success but create/edit still blocked in the browser.
- API tests green while live payload shape is still rejected.
