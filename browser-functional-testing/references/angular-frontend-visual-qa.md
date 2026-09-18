# Angular Frontend Visual QA — session notes

Use this when validating Angular + Material frontends against a visual reference and the dev server is unavailable or misconfigured.

## Practical fallback for visual inspection

If `ng serve` cannot start, a static build can still be used for visual QA:

1. Build the app (`npm run build` or equivalent).
2. Serve the browser output directory from `dist/` with a simple static server.
3. Open the app in the browser and continue the visual review.

This is a QA fallback only. Do not confuse it with fixing the underlying build/serve issue.

## What to check on the page

- Overall feel: system/monitor or dashboard, not landing page.
- Hierarchy: clear heading, content blocks, actions, and breathing room.
- Visual language: calm clinical palette, restrained decoration, no glassmorphism overload.
- Component consistency: Material cards, buttons, chips, inputs, spacing.
- Responsiveness: desktop/tablet/mobile without wrap or collapse issues.
- Accessibility basics: labels, focus affordance, readable contrast.

## Angular-specific QA note

When testing forms that use native date/time inputs:

- `browser_type()` may not reliably populate `<input type="date">` / `<input type="time">`.
- Prefer picker interaction if the UI exposes it.
- If the flow cannot be automated cleanly, document it as an automation limitation rather than a product bug.

## Evidence pattern

For each screen, capture:

- route / scenario
- approved aspects
- visual deviations
- severity
- functional vs visual classification

Keep the report concise and explicit about whether the issue blocks code review.
