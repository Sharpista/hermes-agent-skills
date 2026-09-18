---
name: dotnet-backend-verification
description: Verify .NET/ASP.NET Core backend changes with focused builds/tests and ad-hoc scripts when a canonical command is unclear.
---

# .NET backend verification workflow

Use this skill when validating backend changes in a .NET solution, especially API/service/controller work that needs real execution evidence.

## Triggers
- Backend service, controller, repository, or integration-test changes
- Need to prove a behavior change rather than just describe it
- The canonical test command is unclear or too broad for the current change

## Workflow
1. Identify the smallest behavior slice that proves the change.
2. Prefer a deterministic regression test for the exact symptom; for time-sensitive bugs, fix the clock in tests rather than relying on wall time.
3. Create a focused temporary verification script under `/tmp` with an OS-safe `hermes-verify-` filename prefix (for example via `mktemp /tmp/hermes-verify-XXXXXX.sh`).
4. Put the exact build/test commands in that script so the verification is repeatable and easy to re-run.
5. If the project has stale build artifacts or odd output-path history, clean the API and test projects first inside the script.
6. Run the script from the relevant test-project directory when manifest/output copying gets weird.
7. If `dotnet test` starts copying `MvcTestingAppManifest.json` or `runtimeconfig.json` into a recursive `bin/Debug/.../tests/<Project>/...` path, re-run from the test project directory first; only then consider output-path overrides.
8. When a repository contains more than one backend test project or test workspace, inspect the solution and each `.csproj` first to identify the active suite; legacy folders can remain in the tree and should not be assumed to be the CI target.
9. Add a shell `trap` or explicit cleanup so the temp script removes itself when the run ends.
10. If the script is only for ad-hoc verification, delete it when finished and keep the report explicitly labeled as **ad-hoc verification**, not suite-green.
11. When a change is behavior-specific (for example config/CORS/auth edge cases), prefer a targeted regression check over a broad suite run unless broader coverage is needed to prove the fix.
12. Before changing implementation to satisfy a failing test, compare the production code, nearby tests, and the broader branch stack to detect test/contract drift.
13. For auth failures in integration tests (`401`/`403`), prefer an authenticated test client or a dedicated test auth scheme in the test host instead of disabling authorization in the app under test.
14. If a WebApplicationFactory suite uses a fake/fixed time provider and JWT suddenly starts failing, inspect the test host auth wiring before changing production auth; the failure is often in test setup.
15. When the CI failure is scoped to one class or one behavior slice, run the smallest focused `dotnet test --filter` that exercises that slice first, then broaden only if the regression is ambiguous.
16. If the failure is about a status label or HTTP code, search the repo for the canonical contract first (domain model, DTOs, sibling tests, frontend contract) before assuming the backend is wrong.
17. After a successful run from the solution root, if build output shows path-recursion noise but the project-directory run is clean, prefer the clean project-directory command as the canonical verification shape.

## Script guidance
- Prefer `bash` scripts for deterministic backend verification.
- Keep the script short and single-purpose.
- Example shape:
  - `dotnet build <project>.csproj -v minimal`
  - `dotnet test <tests>.csproj --filter "..." -v minimal`
- Use an explicit workspace path inside the script rather than assuming shell state.

## Pitfalls
- SQLite/EF Core translation issues can appear only at runtime even when the query compiles.
  - If a predicate does not translate, materialize the narrow projected data first and compare in memory.
- When integration tests start returning `401 Unauthorized` for endpoints that should be reachable in the test host, check the `WebApplicationFactory` auth/test-scheme setup before changing business logic. A red test may be a missing test auth override, not a controller regression.
- When a repository contains more than one backend test project, inspect the solution and each `.csproj` first to identify the active suite; legacy folders can remain in the tree and should not be assumed to be the CI target.
- When a test failure is about a status label or HTTP code, compare the app contract, sibling tests, and CI logs before changing production code. If the active contract already moved, update stale tests instead of forcing the old expectation back into the app.
- When testing a single behavior, do not assume the full suite is green unless you actually ran it.
- If the workspace contains pre-existing build artifacts or stale test output, isolate verification commands to the target project/tests and clean both the API and test projects inside the script first.
- If `dotnet test` starts copying `MvcTestingAppManifest.json` or `runtimeconfig.json` into a recursive `bin/Debug/.../tests/<Project>/...` path, rerun from the test project directory after cleaning before trying custom output-path overrides.
- If `MSB3026` shows repeated output segments for `MvcTestingAppManifest.json`, treat it as an output-root recursion bug, not a copy-time fluke. Move `BaseOutputPath` to a truly out-of-tree location first; only adjust intermediate output paths if you also plan to clean them, because mixed overrides can surface duplicate assembly-attribute errors.

## Support files
- `references/manifest-recursion-ad-hoc.md` — concise notes on the clean/build/test flow, the manifest-copy recursion symptom, and the working verification shape used in this session.
- `references/msb3026-output-recursion.md` — session notes on `MSB3026`, repeated `MvcTestingAppManifest.json` paths, and the safe fix of moving `BaseOutputPath` out of tree.
- `references/multi-workspace-test-consolidation.md` — the canonical decision rule and verification shape when a repo has both a legacy test folder and a newer nested test workspace.
- `references/test-auth-scheme-integration.md` — the test-auth-scheme pattern for `WebApplicationFactory` suites that fail with `401` under fixed time/JWT setup.
- `references/test-contract-drift-and-auth.md` — PR #9 notes on multiple backend test projects, contract drift (`Agendada` vs `Pendente`), and the integration-auth fix used to remove 401s.

## Reporting
- State what was verified, how it was verified, and whether it was targeted or suite-wide.
- If verification is partial, say so explicitly.
- Mention any workaround applied during verification, especially ORM/provider translation fixes.

## Reference material
- See `references/ad-hoc-verification.md` for the temporary-script pattern and the SQLite/EF Core translation workaround used in this session.
- See `references/temp-script-and-manifest-recursion.md` for the exact temp-script pattern, cleanup trap, and the recursive `MvcTestingAppManifest.json` workaround used in this session.
- See `references/test-auth-scheme-integration.md` for the test-auth-scheme pattern used to fix 401s in integration verification.
- See `references/test-contract-drift-and-auth.md` for the PR #9 case study covering contract drift and auth wiring.
