# Live Preview Form QA Checklist

Use this when validating Angular forms with a mirrored preview / summary panel.

## Checklist
1. Open the protected route and authenticate.
2. Fill the mirrored fields one at a time.
3. After each field update, confirm the preview changes immediately and matches the typed value.
4. Verify the preview area preserves layout: no overlap, clipping, or misalignment with the form.
5. Check that required-field validation still appears when dependent inputs are incomplete.
6. If native date/time controls are part of the form, treat automation issues as a tooling limitation unless the UI itself is visibly broken.
7. Capture a browser screenshot/vision pass for the final visual state.

## Evidence pattern
- Snapshot after each meaningful change.
- Vision pass for alignment/density.
- Console check for JS errors.
- Record whether preview correctness and validation correctness were both observed.
