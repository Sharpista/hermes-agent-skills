# Time-sensitive .NET backend verification

Use this pattern when a backend bug depends on `DateTime`, `DateTimeOffset`, UTC conversion, or a business timezone.

## Deterministic setup
- Create a fixed clock for the test host.
- If the app depends on `TimeProvider`, register a test double in the `WebApplicationFactory` container.
- Remove the existing `TimeProvider` registration before adding the fixed instance.
- Use a fixed `UtcNow` that makes the failing scenario reproducible.

## What to assert
- Business input parsed as local business time, not as UTC by accident.
- Persisted instant matches the expected UTC conversion.
- Response payload renders the expected local date/time fields.
- Boundary cases near the current time use the fixed clock, not the real wall clock.

## Practical notes
- Prefer one focused regression test over broad end-to-end coverage.
- If the bug is about creation/update/listing consistency, assert all three with the same clock setup.
- Keep the repro script small and runnable from `/tmp` when you need ad-hoc verification.
