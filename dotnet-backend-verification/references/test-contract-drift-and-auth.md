# Test contract drift and auth setup

Use this note when backend CI failures look like behavior regressions but may actually be stale tests.

## What to check first

1. Read the production service/controller code that the test targets.
2. Search adjacent tests in the same branch stack for the same contract.
3. Verify the domain model/DTO values and HTTP status codes the code currently emits.
4. If the controller is protected by `[Authorize]` or a fallback auth policy, make the integration test client authenticate instead of bypassing auth.

## Patterns seen in this session

- `ConsultaServiceTests` expected:
  - `Agendada`, but the service now returns `Pendente`.
  - old validation messages for missing date/time.
  - `Hora` with seconds to be rejected, but the service accepts it.
- `ConsultasControllerIntegrationTests` got `401 Unauthorized` until the test client logged in and sent a bearer token.
- `DELETE`/cancel behavior returned `200 OK`, so tests expecting `204 NoContent` were stale.

## Rule of thumb

If the implementation and the surrounding branch stack agree, update the test contract. Do not bend production code to satisfy an outdated assertion unless you have confirmed the product contract really changed.
