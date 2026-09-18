# Temporary verification script and manifest recursion workaround

Use this pattern when validating a .NET backend change with focused tests:

1. Create a temp script under `/tmp` with an OS-safe `hermes-verify-` prefix, for example via `mktemp /tmp/hermes-verify-XXXXXX.sh`.
2. Put the exact `dotnet clean`, `dotnet build`, and `dotnet test` commands in the script so the verification is repeatable.
3. Prefer running the script from the **test project directory** when `dotnet test` starts copying `MvcTestingAppManifest.json` or `runtimeconfig.json` into a recursive path like `bin/Debug/.../tests/<Project>/...`.
4. Clean both API and test projects inside the script before retrying custom output paths.
5. Add a shell trap or explicit cleanup so the temp script is removed after the run.
6. Report the result as **ad-hoc verification** unless you actually ran the full suite end-to-end.

Observed symptom:
- `MvcTestingAppManifest.json` copy attempted into a recursive `bin/Debug/net8.0/tests/<TestProject>/...` path when `dotnet test` was launched from the wrong directory.

This reference is intentionally short and operational; it exists to preserve the exact repeatable fix, not to mirror the full .NET docs.
