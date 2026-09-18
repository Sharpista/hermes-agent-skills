# MVC testing manifest-copy mismatch

Observed failure pattern during `dotnet test` from a repo root with nested test-project output paths:

- Build succeeds.
- Test host then fails copying `MvcTestingAppManifest.json` or `runtimeconfig.json` into a recursive `bin/Debug/net8.0/tests/<Project>/...` path.
- Re-running from the **test project directory** with `dotnet clean` first resolves the path confusion more reliably than tweaking output paths.

## Known-good command shape

```bash
cd /path/to/repo/tests/Your.Tests
dotnet clean -v minimal
dotnet test -v minimal
```

## Notes

- Prefer a fresh verification script under `/tmp/hermes-verify-*.sh` for ad-hoc validation.
- Treat the issue as a working-directory/output-path mismatch, not a product regression, unless the failure persists after cleaning from the test-project directory.
