# Ad-hoc backend verification pattern

This note captures the session-specific pattern that proved useful for the consultation backend MVP.

## Temporary script pattern
- Create a short-lived script in `/tmp` with a `hermes-verify-` filename prefix.
- Put the exact `dotnet clean`, `dotnet build`, and `dotnet test` commands in the script.
- Prefer a focused test filter over a broad suite when validating a targeted backend change.
- Clean up the script after use when possible.

## What worked here
- `dotnet clean SaasConsultaOnlineBackend.csproj -v minimal`
- `dotnet clean tests/SaasConsultaOnlineBackend.Tests/SaasConsultaOnlineBackend.Tests.csproj -v minimal`
- `dotnet test tests/SaasConsultaOnlineBackend.Tests/SaasConsultaOnlineBackend.Tests.csproj --filter "Consultas_ComToken_AceitaContratoDataHoraDoFrontendParaCriarListarECancelar" -v minimal`
- `dotnet build SaasConsultaOnlineBackend.csproj -v minimal`

## Output-path / manifest-copy pitfall
- When stale `bin/obj` artifacts caused a nested `MvcTestingAppManifest.json` copy path, the recovery path was:
  1. `dotnet clean` both projects
  2. rerun the focused test from the test project directory
  3. avoid custom `BaseOutputPath` overrides unless diagnosing output-path behavior specifically

## EF Core / SQLite translation workaround
- A conflict-check query using `DateTime.Add(...)` inside the provider-side predicate failed to translate under EF Core + SQLite.
- The fix was to project the needed `DateTime` values first with `ToListAsync`, then compare overlap in memory.

## Reporting rule
- Call this **ad-hoc verification** unless a full suite run was actually executed and observed passing.
