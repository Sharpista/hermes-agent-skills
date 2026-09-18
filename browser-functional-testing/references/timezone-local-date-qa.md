# Timezone / local-date QA pattern for agenda screens

Use this when validating filters or summaries such as **"Hoje"** on appointment lists.

## Goal
Confirm the UI buckets appointments by the browser's **local date**, not by UTC day boundaries.

## Quick checks
1. Inspect the browser timezone:
   - `Intl.DateTimeFormat().resolvedOptions().timeZone`
   - `new Date().toString()`
2. Compare against the live API payload:
   - Dates are usually `yyyy-MM-dd`
   - The list's `Hoje` count should match items whose date equals the browser-local calendar day
3. Verify the "next appointment" card still matches the first non-cancelled item after sorting by date + time.
4. Re-check visual consistency after toggling the `Hoje` filter and when the state becomes empty.

## Validation note from session
- Browser timezone observed: `America/Sao_Paulo`
- Local time observed: `Tue Jul 21 2026 16:58:39 GMT-0300`
- The app's date-only formatting used a midday anchor (`T12:00:00`) to avoid rollover near midnight.

## What to look for
- `Hoje` should drop to zero when no items match the browser-local date.
- Summary cards should remain coherent with the underlying API data.
- The list can show an empty state while the side card still shows a valid upcoming appointment.
- No layout shift, overlap, or cropped cards when the filter changes.

## Do not do
- Do not infer the day bucket from UTC alone.
- Do not treat a zero-count `Hoje` as a bug if the browser-local date does not match any payload date.
