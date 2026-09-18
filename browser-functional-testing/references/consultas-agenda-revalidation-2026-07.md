# Consultas agenda revalidation lesson (2026-07)

## Context
During functional revalidation of the consultas scheduling flow after a frontend fix, the API path was confirmed stable while browser automation on native date/time inputs remained the fragile step.

## What held up
- Login succeeded and protected routes loaded normally.
- API smoke confirmed:
  - `GET /api/consultas` without token => `401`
  - authenticated create => `201`
  - duplicate slot => `409`
  - past date/time => `400`
  - persistence in list after create => OK
- Browser QA showed a clean UI and no JS console errors.

## Important lesson
- Native HTML5 date/time controls can remain the bottleneck in browser automation even when the underlying feature is healthy.
- If API checks pass but browser fill/save on `<input type="date">` / `<input type="time">` is inconclusive, treat that as an automation coverage gap first, not a product defect.
- Do not block technical review solely on that gap if the backend contract and persistence are already verified, but keep a manual browser pass as a final QA note.

## Recommended decision rule
- **Approve to technical review** when API + auth + persistence pass and the only open item is native date/time automation uncertainty.
- **Block** only if the browser reveals a real functional failure: bad payload, wrong validation, persistence mismatch, or console/runtime error.
