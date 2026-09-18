# MVP Consultas — Functional Validation Notes

## Scope validated
- Backend .NET auth + consultas CRUD
- Angular login, shell, list, and form flows
- Integration via real browser and HTTP requests

## What passed
- `POST /api/auth/login` accepted the seeded admin credentials.
- Protected `/api/consultas` endpoints returned `401` without a bearer token.
- Authenticated `GET/POST/PUT/DELETE /api/consultas` worked end to end.
- Angular build succeeded and the browser showed the login and list UI without JS errors.

## High-value regression discovered
### Date-only / local-time mismatch
The backend currently interprets `data` + `hora` as UTC. In a `America/Sao_Paulo` browser session, a same-day future appointment such as `2026-07-24 13:30` was rejected as not future.

**Validation pattern:**
1. Record browser zone with `Intl.DateTimeFormat().resolvedOptions().timeZone` and `new Date().toString()`.
2. Submit a future same-day appointment from the UI/API.
3. If the backend rejects it, compare the DTO contract and the server-side date construction before approving.

## Auth UX / persistence lesson
If the UI claims session persistence or "remember me", confirm the behavior across:
- login
- reload
- direct navigation to a protected route
- logout / anonymous return

A login flow that only survives in-memory is a functional mismatch if the copy implies persistence.

## Reporting rule
A polished screen does not outweigh a blocking contract, timezone, or auth-state regression. Treat those as delivery blockers even when the visual QA looks strong.

## Session-specific notes
- In this run, the consultas form UI kept native date/time inputs at `0` in the accessibility tree after typing attempts; use the browser picker or API-based confirmation when you need to validate same-day future scheduling.
- A live API create attempt for a same-day future consultation (`2026-07-24 13:45` in `America/Sao_Paulo`) returned `400 Bad Request` even though the backend unit suite was green. When that happens, compare the exact browser payload, DTO shape, and timezone interpretation before approving.
- The login shell did not surface a logout button in the main consultation layout; for persistence validation, use the auth flow behavior itself (reload/direct-route/logout return) as the source of truth.
