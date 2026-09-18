# Frontend visual / accessibility revalidation

Use this checklist when a frontend phase was already visually approved and later changed for accessibility, maintenance, or shared-design cleanup.

## Review goals

- Re-check the previous findings against the current implementation.
- Separate corrected issues from any new technical risks.
- List the files reviewed in the final response.
- Classify findings by severity.
- End with an explicit decision: **Approved**, **Rejected**, or **Blocked**.
- State whether the phase can be closed or still needs correction.

## Fast re-check list

- Keyboard focus is visible on all interactive elements.
- Forced-colors / high-contrast overrides exist where needed.
- Disabled or placeholder actions do not use broken links such as `href="#"`.
- Active navigation remains clickable; avoid `pointer-events: none` on selected routes.
- Shared visual tokens live in one place instead of being duplicated in components.
- Empty/loading/error states remain readable and accessible after refactors.
- Build success is not treated as proof of accessibility or runtime correctness.
- If a test command fails before assertions execute, classify it as tooling/setup, not a product regression.

## Suggested report shape

- Reviewed files: `...`
- Findings:
  - Blocker: `...`
  - High: `...`
  - Medium: `...`
  - Low: `...`
- Decision: `Approved | Rejected | Blocked`
- Phase status: `Can close` / `Needs correction`
