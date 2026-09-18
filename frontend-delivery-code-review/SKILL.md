---
name: frontend-delivery-code-review
description: "Review Angular/SPA frontend deliveries for environment wiring, component regressions, and release blockers."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [code-review, frontend, angular, spa, environment, api, release]
---

# Frontend Delivery Code Review

Use this skill to review Angular or similar SPA deliveries after implementation, especially when the change touches API endpoints, login/auth flow, shell/layout, list/detail forms, or visual cleanup.

## When to use

- The user asks for a technical review of a frontend delivery.
- The change updates environment config, proxy config, or API base URLs.
- The delivery includes login, shell, list, or form flows that may regress together.
- You need to decide whether the release is approvable with no further scope changes.

## Review order

1. **Environment wiring first**
   - Inspect `environment.ts` and `environment.prod.ts` together.
   - If a proxy config exists, inspect it with the environment files.
   - Verify the API base URL matches the intended deployment model.

2. **Auth flow second**
   - Confirm login, session restore, logout, guards, and interceptors agree on token/session handling.
   - Check redirect and returnUrl behavior for expired sessions and access denial.

3. **Core screens third**
   - Review shell, list, and form components together.
   - Ensure loading, empty, error, and success states remain coherent.
   - Check that visual cleanup did not remove required affordances or navigation paths.

4. **Contracts and data shaping**
   - Confirm request/response DTOs are aligned with backend expectations.
   - Check that response normalization still handles alternate shapes without hiding real defects.

5. **Verification evidence**
   - Prefer real build/test output or direct runtime smoke validation over assumptions.
   - If automated tests are blocked by workstation-specific setup, report that as a validation limitation, not a code defect.

## What to flag

- Production config still pointing to a localhost-only backend when the delivery is not explicitly local-only.
- Proxy and service base URLs out of sync.
- Auth/session handling that can silently leave the app in an inconsistent state.
- UI states that regress after cleanup: missing loading, empty, or error handling.
- Overly broad normalization that could mask API contract drift.
- Missing tests for a critical flow when the repo already has a test suite.

## What to avoid

- Do not invent blockers from environment-specific tool failures.
- Do not propose scope expansion beyond the requested frontend delivery.
- Do not reduce the review to style; prioritize behavior, maintainability, and release risk.

## Output format

- List files reviewed.
- Classify findings by severity.
- Separate code issues from validation limitations.
- End with one clear decision: `APROVADO`, `APROVADO COM RESSALVAS`, `REPROVADO`, or `BLOQUEADO`.

## Support files

- See `references/frontend-environment-review.md` for a concise checklist on Angular environment/proxy review.
