---
name: browser-functional-testing
description: "Functional validation of web applications: API testing via curl, frontend testing via browser tools, known limitations, and reporting."
version: 1.0.0
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [testing, qa, functional-validation, api, browser, web-apps]
    related_skills: [dogfood, systematic-debugging]
---

# Browser Functional Testing: API + Frontend Validation

## Overview

This skill guides you through structured functional validation of full-stack web applications. You will test backend APIs via curl, validate frontend behavior via browser tools, verify integration, and produce a validation report with clear pass/fail status.

For narrow changes without a single canonical verification command, default to a temporary `/tmp/hermes-verify-XXXXXX.sh` harness as described in `references/ad-hoc-verification.md`.
- Put only the changed-behavior assertions in the script.
- Run it from the repo root.
- Pair it with the relevant build/test command.
- Remove the script afterward when possible.

For shell-level logout changes, see `references/ad-hoc-shell-logout-smoke.md` for the compact build + bundle-check + browser-loop pattern.
For JWT auth flows, use the compact checklist in `references/auth-jwt-validation.md`.
For fresh-login 403 validation, see `references/fresh-jwt-timing-403.md` when a just-issued token returns `401 invalid_token` on the first protected call and you need to separate token timing from true authorization failure.
For auth/session persistence regressions and "Lembrar de mim" semantics, see `references/auth-session-persistence-smoke.md`.
For Angular dev-mode session resets and logout probes, see `references/angular-dev-auth-injector-probe.md`.
For narrow production-hardening fixes, use `scripts/verify_frontend_hardening.sh` as the repeatable ad-hoc check: confirm `environment.prod.ts` is not pinned to localhost, production auth storage is constrained, and the build still succeeds.

**Smoke-test posture:** when a browser session can authenticate but the shell does not visibly expose logout, validate session state by behavior (login → protected route → logout → anonymous return) instead of trying to infer state from the current route alone.

Use this when:
- A user requests "validação funcional" or "functional testing" of a web app
- You need to validate MVP readiness before code review
- You need to test both API endpoints and UI flows systematically

## Inputs

The user typically provides:
1. **Backend URL** — e.g., `http://localhost:5052`
2. **Frontend URL** — e.g., `http://localhost:4200`
3. **Scope** — list of features/endpoints to validate
4. **Acceptance criteria** — what defines "approved"

## Workflow

### Phase 1: Start Servers (if needed)

If servers are not running, start them in background:

```bash
# Backend (adjust per stack)
cd /path/to/backend && dotnet run --urls=http://localhost:5052

# Frontend (adjust per stack)
cd /path/to/frontend && ng serve --port=4200
```

Use `terminal(background=true, notify_on_complete=false)` for long-lived servers.
Verify with `process(action='poll')` or `process(action='wait')`.

**Angular visual-QA fallback:** if the dev server cannot start, serve the built browser bundle from `dist/` with a simple static server and continue the visual review there. This keeps the QA loop moving while the build/serve issue is investigated separately.

See `references/angular-frontend-visual-qa.md` for the fallback workflow and what to capture in the report.

### Phase 2: Backend API Testing

Test each API endpoint systematically via curl:

| Endpoint Pattern | Test Cases |
|------------------|------------|
| `GET /api/resource` | Returns list, status 200 |
| `POST /api/resource` (valid payload) | Creates resource, returns ID |
| `POST /api/resource` (invalid payload) | Returns 400 with validation errors |
| `PUT /api/resource/{id}` (existing) | Updates resource, returns updated data |
| `PUT /api/resource/{id}` (non-existent) | Returns 404 |
| `DELETE /api/resource/{id}` (existing) | Deletes/cancels, returns 204 |
| `DELETE /api/resource/{id}` (non-existent) | Returns 404 |

**curl patterns:**

```bash
# GET
curl -s http://localhost:5052/api/consultas

# POST valid
curl -s -X POST http://localhost:5052/api/consultas \
  -H "Content-Type: application/json" \
  -d '{"field":"value",...}'

# POST invalid (empty fields)
curl -s -w "\nHTTP Status: %{http_code}\n" -X POST ... \
  -d '{"field":"","other":""}'

# PUT
curl -s -X PUT http://localhost:5052/api/consultas/{id} \
  -H "Content-Type: application/json" \
  -d '{"updated":"data"}'

# DELETE
curl -s -w "\nHTTP Status: %{http_code}\n" \
  -X DELETE http://localhost:5052/api/consultas/{id}
```

**Record for each test:**
- ✅ Pass or ❌ Fail
- HTTP status code
- Response summary (truncated if long)

### Phase 3: Frontend Testing

Use `references/serenepath-angular-material-qa.md` for the exact visual checkpoints and decision rule (build + login + protected route + list + form).
Use `references/serenepath-angular-material-form-preview-regression.md` for the live-preview regression pattern and the QA takeaway: polished layout does not compensate for stale mirrored form state.
Use `references/live-preview-form-qa.md` for the quick checklist when a form has a mirrored preview / summary panel.
Use `references/mvp-consultas-functional-validation.md` for the compact consultations MVP checklist, the date/timezone regression pattern, the auth-persistence validation sequence discovered in this session, and the visible-logout smoke flow.
Use `references/consultas-auth-agenda-smoke.md` for the exact end-to-end sequence that was verified here: login → protected-route denial without token → future same-day create in São Paulo → list/update/cancel persistence → logout → direct-route anonymous return → non-admin 403 check.
Use the same end-to-end order that proved useful here for final MVP passes: login → protected-route denial without token → future same-day create in São Paulo → list/update/cancel persistence → logout from the shell → direct-route anonymous return.
Use `references/angular-edit-flow-route-validation.md` for the row-action edit smoke test: confirm pathname after clicking Edit, use a DOM-click fallback if the snapshot click appears to noop, then verify save + persistence by reopening the record.
Use `references/timezone-local-date-qa.md` when validating date-only business rules such as "Hoje", next-appointment ordering, or day-boundary behavior.
Use `references/contract-drift-live-qa.md` for the live-payload-vs-DTO confirmation sequence when backend tests are green but the running API still rejects create/edit payloads.
Use `references/live-frontend-backend-origin-and-build-checks.md` when browser QA and API tests disagree about login/CRUD behavior.
Use `references/angular-dev-api-proxy-smoke.md` when the Angular dev server should hit a validated local backend: prefer a relative `/api` environment entry plus `proxy.conf.json` and confirm the actual request target in the browser resource timing.
Use `references/frontend-visual-a11y-review.md` for the compact revalidation checklist when a UI was already approved visually and later changed for accessibility or maintenance.
Use `references/angular-dev-mode-browser-qa-notes.md` for Angular dev-mode browser probing, especially when a submit click appears to noop or the local frontend API base URL may not match the intended backend.

**Session-specific lesson:** if backend tests pass but the browser shows a dev-server overlay type error, reopen in a clean session and confirm whether the error still reproduces before filing a product bug; don't treat stale overlay state as authoritative. Likewise, if the backend accepts a DTO contract in tests but live UI validation fails around same-day appointments, re-check timezone handling before treating it as a UI issue. Do not approve a login screen that says the session is persistent unless reload/direct-route behavior actually matches that claim.

When validating protected auth flows, check both role-based endpoints and anonymous endpoints: a valid login is not enough if the admin-only route still returns 403 or the anonymous list route does not redirect/deny as expected.

When a feature is organized as a parent shell with child routes, verify both the shell chrome and the child navigation: the shared header/actions should remain visible while moving between list and form routes, and the route transitions should not break the protected flow.


1. **Navigate:** `browser_navigate(url="http://localhost:4200")"
2. **Snapshot:** `browser_snapshot()` to see interactive elements
3. **Console check:** `browser_console()` for JS errors

**Test checklist:**

| UI Element/Flow | What to Verify |
|-----------------|----------------|
| List/Grid view | Data loads from API, columns correct |
| Navigation buttons | Click through to forms/detail pages |
| Forms | Field labels, required indicators, validation messages |
| Form submission (valid) | Success message, redirect, data persists |
| Form submission (invalid) | Error messages displayed |
| Edit flow | Loads existing data, allows changes, saves |
| Delete/Cancel | Confirmation (if any), list updates |
| Loading states | Spinners/messages during async ops |
| Error states | User-friendly messages on API errors |

**Important — Known Limitation: HTML5 Date/Time Inputs**

Native `<input type="date">` and `<input type="time">` elements **cannot be automated** via `browser_type`. The accessibility tree exposes spinbuttons, but typing into them does not set values.

Session note: see `references/consultas-agenda-revalidation-2026-07.md` for the revalidation lesson where the backend/API path passed, but browser automation on native date/time fields remained the last fragile step.

**Workarounds:**
1. Use the picker UI: click "Show date picker" button, then click grid cells in the calendar
2. For comprehensive validation, **recommend manual testing** for flows requiring date/time input
3. Document this as an **automation limitation**, not an application bug

See "Known Pitfalls" section below for details.

### Phase 4: Integration Verification

Verify frontend ↔ backend integration:

1. **Data flow:** Create/edit via UI → verify in API response
2. **Persistence:** Refresh page → data still present (SQLite/DB working)
3. **Error handling:** Backend error (e.g., 404, 500) → frontend displays friendly message
4. **Console:** No uncaught JS errors during normal flows
5. **Auth loop:** login → access protected route → logout → protected route blocked again
6. **Origin/build sanity:** if the browser result disagrees with curl/API tests, confirm the running frontend instance, backend base URL, and CORS origin before diagnosing the component.

### JWT Auth Validation Add-on

When the app includes JWT auth, validate both layers:
- **Backend:** `POST /api/auth/login` with valid credentials returns a token; invalid credentials return `401`.
- **Protected endpoints:** requests without `Authorization: Bearer <token>` return `401`.
- **Frontend:** route guards should redirect anonymous users to `/login`, and logout should clear session state so protected routes are blocked again.
- **Browser-first hardening rule:** do not approve based on token issuance alone. For a real hardening pass, the browser must show the full sequence in the same session: valid login → protected shell → logout → anonymous return to login, plus invalid-login messaging on the login screen.
- **Anonymous re-entry check:** after logout, a direct visit to a protected route should bounce back to login in the same browser context.
- **Angular SPA smoke tip:** when a protected route appears blocked during QA, inspect the live Angular component/service state first (for example via `window.ng.getComponent(...)` in dev mode) before concluding the route is broken. A successful navigation call is not proof that the guard will allow entry if the auth service still reports an invalid session. See `references/angular-dev-mode-protected-route-smoke.md` for the compact probe sequence.
- **Contract-shape smoke tip:** when create/edit fails but the page looks fine, compare the browser payload fields to the backend DTO names immediately; payload drift is a blocking functional defect, not a presentation issue.
- **Session restore:** for auth backed by browser storage, verify restore after refresh/direct navigation in the same browser context; if the UI exposes "Lembrar de mim", test both the default session-only behavior and the persistent path separately.
- **QA session reset tip:** if you need to force the SPA back to an anonymous state during browser QA, prefer app-level logout via Angular debug injector/service access over direct storage mutation. See `references/angular-auth-session-reset.md`.
- **Auth hardening checklist:** see `references/auth-session-hardening-qa.md` for the short end-to-end validation sequence and evidence pattern.
- **Session note:** see `references/auth-session-hardening-qa-2026-08.md` for the exact login/401/403/rate-limit/logout evidence pattern validated in this session.

Use `references/auth-jwt-validation.md` for a compact checklist and evidence pattern.
Use `references/shell-logout-auth-review.md` when the UI introduces a visible logout in a protected shell/header and you need to verify the full auth chain end-to-end.
Use `references/auth-session-qa-lessons.md` for session-specific auth QA patterns captured from real browser validation (Angular dev-mode probes, storage-access fallbacks, and 403 coverage gaps).
Use `references/session-auth-hardening-qa-2026-08.md` for the specific lesson that backend/API success is not enough; valid browser login must still prove redirect, protected-route access, logout/anonymous return, and rate limiting in the same browser session.

### Phase 5: Report Generation

Produce a structured report with:

1. **Status:** `Aprovado` / `Reprovado` / `Aprovado com Ressalvas` / `Bloqueado`
2. **Tested scenarios:** Table of all tests with pass/fail
3. **Bugs found:** For each:
   - Severity (Crítico, Alto, Médio, Baixo)
   - Steps to reproduce
   - Expected vs actual
   - Screenshot reference (if applicable)
4. **Recommendation:** "Pode avançar para code-reviewer?" with justification

**Report format:**

```markdown
# Relatório de Validação Funcional - [Nome do Sistema]

## 1. Status: APROVADO / REPROVADO / APROVADO COM RESSALVAS

## 2. Cenários Testados

### Backend (API)
| Cenário | Status | Evidência |
|---------|--------|-----------|
| GET /api/... | ✅ | Retorna lista em JSON |
| POST /api/... | ✅ | Cria recurso, retorna ID |
| ... | ... | ... |

### Frontend (UI)
| Cenário | Status | Observação |
|---------|--------|------------|
| Listagem carrega | ✅ | Dados da API exibidos |
| Formulário valida | ✅ | Mensagens de erro visíveis |
| ... | ... | ... |

## 3. Bugs/Problemas Encontrados

### [Nome do Problema]
- **Severidade:** [Crítico/Alto/Médio/Baixo]
- **Descrição:** ...
- **Passos para reproduzir:** ...
- **Resultado esperado:** ...
- **Resultado atual:** ...

## 4. Recomendação

**[Pode/Não pode] avançar para code-reviewer.**

Justificativa: ...
```

## Tools Reference

| Tool | Purpose |
|------|---------|
| `terminal` | Start servers, run curl commands |
| `process` | Manage background server processes |
| `browser_navigate` | Go to frontend URL |
| `browser_snapshot` | Get DOM accessibility tree |
| `browser_click` | Click buttons, links |
| `browser_type` | Fill text inputs (not date/time!) |
| `browser_console` | Check for JS errors |
| `browser_vision` | Screenshot + visual inspection |

### Known Pitfalls

### Date-only lists must be validated in local time, not UTC

For appointment/agenda screens where the backend stores `yyyy-MM-dd` dates and the UI exposes a filter like "Hoje", validate the bucket against the browser's local timezone and the app's local-date logic. Confirm all three layers line up:
1. Browser local zone (`Intl.DateTimeFormat().resolvedOptions().timeZone` and `new Date().toString()`).
2. API payload date strings (`yyyy-MM-dd`) and the UI's local-date comparison.
3. Visible summaries / "next appointment" ordering after switching the filter.

If the app formats date-only values, prefer a midday anchor (`T12:00:00`) or an explicit local-date helper to avoid UTC rollover near midnight. See `references/timezone-local-date-qa.md` for a compact validation pattern.

### Visual polish does not override a blocking auth failure

When a SerenePath-style frontend looks visually strong but valid credentials do not complete login, record the delivery as **Reprovado**. Do not let good spacing, cards, or Material styling hide a blocked entry flow; the weakest functional link determines the QA decision.

### Visual polish does not override stale form mirrors or preview cards

If a reactive form renders correctly but a live preview / summary card does not update when fields change, treat it as a functional defect. Confirm the mirror reflects typed state before approving a SerenePath / Angular Material form. A strong layout plus broken state propagation is still **Reprovado**.

### Visual polish does not override API contract drift

If the UI looks polished but a create/edit request fails with a validation error, compare the outgoing payload to the backend DTO before approving. A form that sends the wrong field names or shape is functionally blocked even if its layout is good.

If list or preview content renders placeholder text such as `undefined`, treat it as a data-mapping or response-shape bug and confirm the DTO/model names on both sides.


### HTML5 Native Date/Time Inputs

`<input type="date">` and `<input type="time">` are common in clinical forms and deserve a specific QA path.

**Preferred sequence:**
1. Try the native picker UI first when the page exposes it.
2. If the picker is not practical, focus the control and use a browser-console expression to assign `document.activeElement.value`.
3. Dispatch both `input` and `change` events.
4. Re-read the page with `browser_snapshot` or `browser_vision` to confirm the displayed value and the mirrored preview/state.
5. Only fall back to manual testing if the app logic still cannot be driven reliably.

**Pitfall to avoid:**
- Do not assume typed text reached the control just because the command succeeded. Always verify the rendered value and any live preview/summary card.
- For date-only business rules, validate against the app's local date logic, not just the raw field value.

**When to use this pattern:**
- Forms with appointment dates, times, or same-day scheduling rules
- Edit flows where the record loads correctly but the save action still rejects the payload

See `references/browser-native-input-workarounds.md` for the compact workaround recipe.

**Do NOT report as a bug:** If the control is behaving like a normal HTML5 date/time input and the workaround succeeds, treat this as an automation limitation rather than a product defect.

**Decision rule:** if the API contract, auth flow, persistence, and console are all green, but date/time entry still cannot be completed reliably in-browser, mark the QA result as `Aprovado com ressalvas` and send the delivery forward with a manual browser confirmation note instead of blocking technical review.

### browser_console Expression Evaluation May Be Blocked

**Problem:** Some configurations block `browser_console(expression="document.querySelector(...)")` for sensitive DOM operations.

**Symptoms:** Error: "Blocked: browser_console(expression=...) tried to use sensitive browser JavaScript primitive"

**Workaround:**
- Use `browser_console()` without expression for logs/errors
- Use `browser_snapshot` for DOM inspection and UI state
- For auth/session questions, prefer end-to-end verification (login, route access, logout, protected API call) over storage introspection
- If an inspection expression is blocked, switch to snapshot/vision or inspect the live Angular component/service via `window.ng.getComponent(...)` in trusted dev sessions instead of repeatedly retrying the same query
- If you need to confirm a protected-route redirect, re-check the rendered snapshot after navigation; the final URL/route state alone is not enough when guards are involved

### Session-specific note: active-element form filling

See `references/browser-native-input-workarounds.md` for the exact pattern used on native date/time fields.

### Backend May Not Be Ready Immediately

**Problem:** After starting a server, immediate curl/browser requests may fail with connection refused.

**Workaround:**
- Use `process(action='wait', timeout=15)` to wait for server startup
- Look for "Now listening on:" or "Application started" in output
- Retry curl if first attempt fails

## Related Skills

- `dogfood` — Exploratory QA testing (bug hunting, evidence collection)
- `systematic-debugging` — Root cause analysis when tests fail
- `dotnet-xunit-testing` — Backend unit/integration tests for .NET
- `angular-testbed-testing` — Frontend unit tests for Angular
