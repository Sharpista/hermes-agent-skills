# Test auth scheme for integration verification

Use this pattern when a WebApplicationFactory-based integration suite is failing with `401 Unauthorized` because the real JWT flow depends on environment/time state that is irrelevant to the behavior under test.

## What happened in this session

- The legacy backend integration suite (`ConsultasControllerIntegrationTests`) used the real auth pipeline.
- The tests also froze `TimeProvider` to make date validation deterministic.
- That combination caused token validation/login behavior to drift and the suite started failing with `401` before the controller behavior could be exercised.

## Preferred fix

Inject a dedicated test authentication scheme in the test host:

1. Keep the real production auth in the app.
2. In the test-only `WebApplicationFactory`, register a fake authentication handler.
3. Return a principal with the minimal claims/roles needed by the endpoint under test.
4. Keep the SQLite in-memory DB and fixed time provider if they are relevant to the business behavior.
5. Verify the changed behavior with a focused `dotnet test --filter` run against the affected integration class.

## Why this is better than editing the app auth

- It preserves the production security pipeline.
- It isolates the test from token expiry/issuer/audience mismatch.
- It makes the failure mode obvious: the test host auth setup is wrong, not the business code.

## Minimal handler shape

- `AuthenticationHandler<AuthenticationSchemeOptions>`
- `HandleAuthenticateAsync()` returns `AuthenticateResult.Success(ticket)`
- Claims should include only what the endpoint requires, e.g. `Name`, `Role`, `Email`


## PR #9 case study

- The active backend CI suite lived under `saas_consulta_online_backend/tests/SaasConsultaOnlineBackend.Tests`, not the legacy `saas_consulta_online_backend.tests` folder.
- The real failure combined contract drift (`Agendada` vs `Pendente`) with auth drift in the integration host.
- The minimal fix was to align the assertions with the current backend contract and wire a test auth scheme/client so the integration tests exercise controller behavior instead of failing on `401`.
- Verification used both a focused integration run and a broader backend run; both passed after the update.
