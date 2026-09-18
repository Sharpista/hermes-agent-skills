# Provider-Order Bug: provideRouter([]) Overwriting ActivatedRoute Stubs

## Context

Angular 21 project, standalone components, `TestBed.configureTestingModule()` with both `provideRouter([])` and a custom `ActivatedRoute` stub in the providers array.

## The Bug

6 tests failed with errors like:
- `Expected false to be true` (isEdit signal)
- `Expected spy ConsultaService.buscarPorId to have been called` (never called)
- `Expected '' to be 'João Silva'` (form fields empty)
- `Expected null to be 'Erro ao atualizar consulta.'` (error signal null)

All 6 tests were in `describe` blocks that set `routeParams = { id: '1' }` before `fixture.detectChanges()`, expecting the component to enter edit mode.

## Root Cause

In the `configureTestingModule()` helper:

```typescript
// WRONG — provideRouter([]) AFTER ActivatedRoute stub
providers: [
  { provide: ConsultaService, useValue: spy },
  { provide: ActivatedRoute, useValue: activatedRouteStub },
  provideHttpClient(),
  provideHttpClientTesting(),
  provideRouter([])    // ← overwrites ActivatedRoute stub!
]
```

`provideRouter([])` internally registers an `ActivatedRoute` provider. Since it appears **after** the custom stub in the array, Angular's DI last-wins policy causes the router's default `ActivatedRoute` to overwrite the stub. The default `ActivatedRoute` has empty route params, so `route.snapshot.paramMap.get('id')` always returns `null`.

## Diagnostic Path

1. **Isolated the test file** — ran `ng test --include='...'` to see only the spec failures.
2. **Created a minimal diagnostic spec** — a throwaway `diag.spec.ts` with just the TestBed setup and a single test that sets `routeParams = { id: '1' }` before `detectChanges()`.
3. **Added console.log** inside the test: `console.log('route.snapshot id =', component['route'].snapshot.paramMap.get('id'))` — it printed `null` when `'1'` was expected.
4. **Tested the fix** — moved `provideRouter([])` to the top of the providers array, before the `ActivatedRoute` stub. The diagnostic test passed.
5. **Applied the fix** to the real spec file and ran the full suite — 51/51 pass.

## Reproduction

```typescript
// Reproduces the bug — provideRouter([]) after stub nullifies it
providers: [
  { provide: ActivatedRoute, useValue: activatedRouteStub },
  provideRouter([])  // overwrites stub
]

// Fix — provideRouter([]) before stub, stub wins
providers: [
  provideRouter([]),  // registers default ActivatedRoute
  { provide: ActivatedRoute, useValue: activatedRouteStub }  // overwrites default
]
```

## Key Insight

The error messages pointed at component logic (form not filled, spy not called, signal false) but the actual bug was in DI configuration. When route params mysteriously return `null` despite a correct-looking stub, check provider order — `provideRouter()` must come **before** any custom `ActivatedRoute` provider.

## Verification

```bash
export CHROME_BIN="/home/alexandre/.cache/ms-playwright/chromium-1228/chrome-linux64/chrome"
node_modules/.bin/ng test --watch=false --browsers=ChromeHeadlessNoSandbox

# Result: TOTAL: 51 SUCCESS (0 FAILED)
```

## Files

- Spec file: `src/app/components/consulta-form/consulta-form.spec.ts`
- Component: `src/app/components/consulta-form/consulta-form.ts`
- Service: `src/app/services/consulta.service.ts`

## Generalization

This bug pattern applies to ANY Angular test that:
1. Uses `provideRouter()` (or `RouterTestingModule`)
2. Provides a custom `ActivatedRoute` stub
3. Expects route params to reach the component

The fix is always the same: `provideRouter()` first, custom `ActivatedRoute` stub after.
