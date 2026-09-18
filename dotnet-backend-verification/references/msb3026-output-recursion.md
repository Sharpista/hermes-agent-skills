# MSB3026 output-recursion notes

Session pattern:
- `dotnet test` on a nested test workspace started copying `MvcTestingAppManifest.json` into paths like:
  - `.../artifacts/tests/Debug/net8.0/artifacts/tests/Debug/net8.0/...`
  - `.../bin/Debug/net8.0/tests/<Project>/bin/Debug/net8.0/tests/<Project>/...`
- The warning was `MSB3026` while copying `MvcTestingAppManifest.json`.

Root cause:
- The test project inherited a recursive output location from the workspace layout.
- Cleaning alone was not enough; the build kept nesting into its own output tree.

Working fix:
- Set `BaseOutputPath` to a directory that is definitely outside the repo/workspace tree when the project is prone to recursive copy behavior.
- Keep the path short and non-nested; a temp location under `/tmp` worked reliably in this session.
- Do not move `BaseIntermediateOutputPath` unless needed; changing both can introduce duplicate-assembly-attribute noise if intermediate state is not cleaned consistently.

Verification shape:
- Run `dotnet test` from the test-project directory after the output-path change.
- Confirm the path in the final output no longer contains repeated `tests/<Project>/...` segments.
- Treat `MSB3026` as resolved only when the final test run completes cleanly with no copy warning.

Pitfall:
- If the project already has stale `bin/obj` state, the first run may still emit path noise from old outputs. Re-run after moving to a fresh output root before concluding the fix is ineffective.
