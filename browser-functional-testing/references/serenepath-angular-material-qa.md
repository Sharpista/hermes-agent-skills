# SerenePath / Angular Material QA Notes

Use this checklist when validating the SerenePath phase of an Angular Material frontend.

## Validation sequence
1. Confirm the frontend build succeeds before UI review.
2. Open the login screen and inspect the overall polish first, not just form controls.
3. After login, validate the protected route renders the actual app shell and not a stale redirect state.
4. Review the list screen for tone: cards, chips, spacing, and hierarchy should read as clinical/serene rather than admin-table.
5. Review the form screen for density and composition: two-column structure, clear hierarchy, and a calm preview sidebar.
6. Decide final QA status from the weakest link. A visually strong UI still fails if auth or CRUD contracts are blocked.

## Visual checkpoints
- Filled cards with soft elevation and rounded corners.
- Muted neutral surfaces with restrained accent colors.
- Dense data rendered as cards/chips instead of grid/table chrome.
- Consistent iconography and typography between list and form.
- No harsh alert colors or cramped action rows.

## Auth checkpoint
- Verify valid credentials against the live backend, not assumptions from the UI copy.
- If the login fails, treat it as a blocking functional defect even if the page looks polished.
- When the backend contract or seeded credentials are uncertain, confirm the API response before approving the frontend.

## Contract drift checkpoint
- If a form visually looks correct but the create/edit request fails, compare the frontend payload shape to the backend DTO before judging the UI.
- Treat missing/renamed fields as a functional blocker, not a styling issue.
- In this session, the frontend form sent `data` + `hora` while the backend required `DataHorario`; the API returned 400 and CRUD was effectively blocked.
- In list and preview cards, placeholder text such as `undefined` usually indicates data mapping or response-shape drift and should be recorded as a bug.

## Evidence to capture in reports
- Build output.
- Login screen screenshot/observation.
- Post-login protected route screenshot.
- List screen visual assessment.
- Form screen visual assessment.
- Console errors, if any.
- API request/response for at least one create or edit path when validating forms.
