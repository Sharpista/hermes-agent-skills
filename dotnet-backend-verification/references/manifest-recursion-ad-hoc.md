# Manifest recursion ad-hoc verification notes

Session pattern:
- `dotnet build <project>.csproj -v minimal` passed.
- `dotnet test` from the repo root hit a recursive `MvcTestingAppManifest.json` copy path like:
  - `bin/Debug/net8.0/tests/<Project>/bin/Debug/net8.0/tests/<Project>/...`
- The working recovery was:
  1. `dotnet clean` the API project and the test project.
  2. Run `dotnet build` from the API project root.
  3. `cd` into the test project directory before `dotnet test`.

Reusable shape:
```bash
ROOT=/path/to/repo
TEST_DIR="$ROOT/tests/<Project>"
rm -rf "$ROOT/bin" "$ROOT/obj" "$TEST_DIR/bin" "$TEST_DIR/obj"
cd "$ROOT" && dotnet build <project>.csproj -v minimal
cd "$TEST_DIR" && dotnet test <tests>.csproj -v minimal --filter "..."
```

Use this when the test harness starts copying manifests into nested `tests/<Project>/...` paths instead of failing on the actual code under test.
