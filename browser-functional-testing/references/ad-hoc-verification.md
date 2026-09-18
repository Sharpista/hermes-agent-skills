# Ad-hoc verification harness for targeted web-app changes

When a change is narrow and there is no single canonical verification command, use a temporary script under `/tmp` instead of improvising a long manual checklist.

## Pattern
1. Create the harness with `mktemp /tmp/hermes-verify-XXXXXX.sh`.
2. Put only the checks that validate the changed behavior into the script.
3. Run it from the repository root.
4. Include a small static assertion pass if useful, then the build/test commands.
5. For frontend visual/a11y fixes, prefer precise content checks for the changed text/classes/attributes plus a build, rather than a broad end-to-end sweep.
6. Treat build warnings separately from build failures; if the build exits 0 with a budget warning, report it as a warning, not as an unverified build.
7. Remove the script afterward if allowed.

## Reporting
- Call the result **ad-hoc verification** unless you truly ran the canonical suite.
- If cleanup is blocked, mention that explicitly and do not treat it as a functional failure.
- Keep the report factual: what was checked, what passed, what remains unverified.

## Good fit
- Angular routing/auth/interceptor work
- Small UI flows that need a fast regression check
- Changes where a single temp harness is clearer than a new permanent test file
