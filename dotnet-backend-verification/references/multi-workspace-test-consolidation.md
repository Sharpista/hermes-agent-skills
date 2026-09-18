# Multi-workspace test consolidation

This note captures the recurring pattern from the session where a backend repo contained both a legacy test tree and a newer nested test workspace.

## What to inspect first
- `git rev-parse --show-toplevel`
- `git status --short --branch`
- Solution file(s): confirm which `.sln` includes the active backend/test project.
- Every `.csproj` under both the legacy and nested test folders.

## Canonical decision rule
- Pick one test workspace and treat it as the source of truth.
- Prefer the workspace already wired into the active solution and CI path.
- Leave the legacy folder only if it is intentionally preserved for history; otherwise migrate the useful tests and remove the duplicate project files.

## Migration shape
- Move the test bodies into the canonical workspace.
- Keep namespaces aligned so discovery remains stable.
- Update the test project reference to the backend project with the shortest safe relative path.
- If test infrastructure exists in the newer workspace, reuse it instead of creating a second factory/auth setup.

## Verification shape
- Run the test project from its own directory first:
  - `dotnet clean`
  - `dotnet test -v minimal`
- Only then run the solution-level test command if needed for broader confidence.
- If solution-level output shows recursive `MvcTestingAppManifest.json` or similar path duplication but the project-directory run is clean, keep the project-directory run as the canonical proof.

## Pitfalls
- Do not assume the oldest folder is the active CI target.
- Do not keep both workspaces “just in case”; that recreates ambiguity and doubles maintenance.
- If integration tests start returning 401/403 after test consolidation, inspect the shared factory/auth wiring before altering production authorization.

## Related support
- `references/ad-hoc-verification.md`
- `references/temp-script-and-manifest-recursion.md`
- `references/test-auth-scheme-integration.md`
