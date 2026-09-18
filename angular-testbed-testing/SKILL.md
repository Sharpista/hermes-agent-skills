---
name: angular-testbed-testing
description: "Angular TestBed unit testing: provider order, ActivatedRoute stubs, HttpClient testing, and common Jasmine/Karma pitfalls."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [angular, testing, testbed, karma, jasmine, frontend]
    related_skills: [test-driven-development, systematic-debugging]
---

# Angular TestBed Testing

## Overview

Angular's `TestBed` is the central harness for unit testing components, services, and pipes. While `TestBed.configureTestingModule()` looks straightforward, provider registration order, route stubs, and HTTP interceptors silently interact in ways that cause tests to pass setup but fail assertions with confusing "never called" / "Expected null" errors.

This skill captures the pitfalls, patterns, and diagnostic techniques for writing reliable Angular tests.

## When to Use

- Writing or fixing Angular component/service unit tests (`*.spec.ts`)
- Debugging "spy never called" or "Expected null" failures in Angular tests
- Setting up `TestBed.configureTestingModule()` with route stubs or HTTP testing
- Angular 17+ standalone components with `provideRouter()` / `provideHttpClient()`

## Core Setup Pattern (Angular 17+ Standalone)

```typescript
import { TestBed, ComponentFixture } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { provideRouter, ActivatedRoute } from '@angular/router';
import { of } from 'rxjs';

describe('ComponentX', () => {
  let component: ComponentX;
  let fixture: ComponentFixture<ComponentX>;

  beforeEach(() => {
    const serviceSpy = jasmine.createSpyObj<Service>('Service', ['method1', 'method2']);
    const routeStub = { snapshot: { paramMap: { get: (k: string) => null } } };

    TestBed.configureTestingModule({
      imports: [ComponentX],         // standalone component
      providers: [
        provideRouter([]),           // FIRST — registers default ActivatedRoute
        { provide: Service, useValue: serviceSpy },
        { provide: ActivatedRoute, useValue: routeStub },  // AFTER provideRouter
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    });

    fixture = TestBed.createComponent(ComponentX);
    component = fixture.componentInstance;
  });

  afterEach(() => {
    TestBed.resetTestingModule();
  });
});
```

## Provider Order: The #1 Silent Killer

**`provideRouter([])` registers its own `ActivatedRoute` provider.** If your custom `ActivatedRoute` stub appears **before** `provideRouter([])` in the providers array, Angular's default `ActivatedRoute` overwrites your stub — silently, with no error.

### Symptom

Tests that set `routeParams = { id: '1' }` before `fixture.detectChanges()` find that `route.snapshot.paramMap.get('id')` returns `null`. The component never enters edit mode, `buscarPorId` is never called, form stays empty.

### Error patterns

- `Expected false to be true` (isEdit signal)
- `Expected spy XxxService.method to have been called` (service mock never invoked)
- `Expected '' to be 'SomeValue'` (form fields stay empty)
- `Expected null to be '1'` (route param returns null)

满天星 These look like logic bugs but are actually DI configuration bugs.

### Fix

Always place `provideRouter([])` **before** your custom `ActivatedRoute` stub:

```typescript
providers: [
  provideRouter([]),                                               // ← FIRST
  { provide: SomeService, useValue: spy },
  { provide: ActivatedRoute, useValue: activatedRouteStub },       // ← AFTER
  provideHttpClient(),
  provideHttpClientTesting()
]
```

### Why

Angular's DI uses last-wins for providers at the same token. `provideRouter([])` internally registers multiple providers including `ActivatedRoute`. If it appears after your explicit `{ provide: ActivatedRoute, useValue: stub }`, the router's default ActivatedRoute overwrites your stub.

## ActivatedRoute Stub Pattern

For components that read route params, use a mutable stub so individual tests can change params before `detectChanges()`:

```typescript
let routeParams: { id?: string } = {};

const activatedRouteStub = {
  snapshot: {
    paramMap: {
      get: (key: string) => routeParams[key as keyof typeof routeParams] ?? null
    }
  }
};

// In each test, before fixture.detectChanges():
routeParams = { id: '1' };
fixture.detectChanges();  // triggers ngOnInit → reads route param
```

**Key:** `ngOnInit` reads `route.snapshot.paramMap.get('id')` at detection time, not at construction time. Set `routeParams` **before** calling `fixture.detectChanges()`.

## Testing Components with Signals (Angular 17+)

Angular signals (`signal()`, `computed()`) are read in templates via `detectChanges()`. In tests:

```typescript
it('should show edit mode', () => {
  routeParams = { id: '1' };
  serviceSpy.buscarPorId.and.returnValue(of(mockData));
  fixture.detectChanges();  // ngOnInit → carregarConsulta → signal updates

  expect(component.isEdit()).toBe(true);
  expect(component.consultaId()).toBe('1');
});
```

You generally don't need `fixture.autoDetectChanges(true)` for unit tests — explicit `detectChanges()` is more predictable.

## HttpClient Testing

For services that use `HttpClient`, provide both HTTP client and testing controller:

```typescript
TestBed.configureTestingModule({
  providers: [
    SomeService,
    provideHttpClient(),
    provideHttpClientTesting()
  ]
});

service = TestBed.inject(SomeService);
httpMock = TestBed.inject(HttpTestingController);

afterEach(() => {
  httpMock.verify();  // assert no outstanding requests
});
```

For component tests that inject a service which uses HttpClient, provide both:

```typescript
providers: [
  { provide: SomeService, useValue: spy },  // mock the service
  provideHttpClient(),                       // still needed for DI tree
  provideHttpClientTesting()
]
```

## Diagnostic Techniques

### Live previews backed by reactive forms

When a template shows a live preview or mirrored summary of a reactive form, do not derive the preview from `form.getRawValue()` inside `computed()` alone. Bridge `form.valueChanges` into a signal with `toSignal(..., { initialValue: form.getRawValue() })`, then compute the preview from that signal.

See `references/reactive-form-live-preview.md` for the minimal pattern and test shape.

### Isolate the failing test

```bash
# Run a single spec file
ng test --watch=false --browsers=ChromeHeadlessNoSandbox --include='path/to/file.spec.ts'
```

### Console-log inside the component

When the stub isn't reaching the component, add a temporary log:

```typescript
console.log('route.snapshot id =', component['route'].snapshot.paramMap.get('id'));
```

If this prints `null` when you expected `'1'`, your ActivatedRoute stub is being overwritten.

### Minimal reproduction

Create a throwaway diag spec with just the TestBed setup and a single test to isolate DI issues from test logic:

```typescript
describe('diag', () => {
  it('reads routeParams live', () => {
    routeParams = { id: '1' };
    fixture = TestBed.createComponent(MyComponent);
    fixture.detectChanges();
    expect(component.isEdit()).toBe(true);
  });
});
```

## Running Angular Tests (Karma + Chrome Headless)

### WSL / Linux without Chrome installed

```bash
export CHROME_BIN="/home/<user>/.cache/ms-playwright/chromium-<version>/chrome-linux64/chrome"
./node_modules/.bin/ng test --watch=false --browsers=ChromeHeadlessNoSandbox
```

### Focused ad-hoc verification for a subset of specs

When you only need to validate the changed auth/login specs, prefer including **directories** or explicit spec files one time each. A single comma-separated `--include='a,b,c'` string can be parsed as one unmatched pattern and yield **0 tests**.

Good:

```bash
./node_modules/.bin/ng test --watch=false --browsers=ChromeHeadlessNoSandbox \
  --include=src/app/services \
  --include=src/app/interceptors \
  --include=src/app/guards \
  --include=src/app/components/login
```

Also good:

```bash
./node_modules/.bin/ng test --watch=false --browsers=ChromeHeadlessNoSandbox \
  --include=src/app/services/auth.service.spec.ts \
  --include=src/app/interceptors/auth.interceptor.spec.ts
```

### Custom browsers config (karma.conf.js or angular.json)

```javascript
browsers: ['ChromeHeadlessNoSandbox'],
customLaunchers: {
  ChromeHeadlessNoSandbox: {
    base: 'ChromeHeadless',
    flags: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage']
  }
}
```

## Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| `provideRouter([])` after `ActivatedRoute` stub | Route params return null, spies never called | Move `provideRouter([])` before stub in providers array |
| `provideHttpClient()` missing | `NullInjectorError: No provider for HttpClient` | Add `provideHttpClient()` and `provideHttpClientTesting()` |
| `HttpTestingController.verify()` fails | Outstanding HTTP requests not flushed | Flush all expected requests in each test |
| `detectChanges()` not called | `ngOnInit` never runs, signals stay default | Call `fixture.detectChanges()` to trigger lifecycle |
| Route params set after `detectChanges()` | Component already initialized with empty params | Set `routeParams` before `detectChanges()` |
| TestBed not reset between tests | "Cannot configure the test module when already instantiated" | Add `afterEach(() => TestBed.resetTestingModule())` |
| **False coverage with `of()`** | Test name claims to test loading/saving state but only asserts final state | Use `Subject` or `cold()` for async timing control (see below) |
| **Redundant providers when service is spy'd** | Tests pass but with unnecessary DI noise | Remove `provideHttpClient` and `RouterTestingModule` when service is spy'd (see below) |
| **Focused `ng test --include` returns 0 tests** | Karma boots but executes no specs | Pass spec directories or repeat `--include` once per path; don't bundle multiple paths into one comma-separated string |
| Session-bearing auth services still use `localStorage` in tests | The hardening goal is not enforced | Assert the chosen store explicitly (`sessionStorage`) and add a regression check that the session key is not left in `localStorage` |

### False Coverage with Synchronous `of()`

**The #1 silent test-quality issue.** When a component sets `loading.set(true)` before an HTTP call and `loading.set(false)` in the `next` callback, a test using `of(data)` as the spy return **cannot observe the `loading=true` state** — `of()` is synchronous, so `loading` goes `true → false` in the same microtask tick, before any assertion can run.

**Symptom:** A test named "deve exibir estado de carregamento" only asserts `consultas().length === 2` (the final state), not `loading() === true`. It gives **false confidence** that loading state is tested.

**Same pattern for `saving` signals in form components:** `saving.set(true)` before `criar()` and `saving.set(false)` in `next` callback — `of()` completes synchronously and the `saving=true` window is unobservable.

**Fix — use `Subject` for manual timing control:**

```typescript
import { Subject } from 'rxjs';

it('deve exibir loading enquanto carrega', () => {
  const subject = new Subject<Consulta[]>();
  consultaServiceSpy.listar.and.returnValue(subject.asObservable());
  fixture.detectChanges(); // ngOnInit → loading=true, waiting for subject

  expect(component.loading()).toBe(true);  // ← now observable!

  subject.next(mockConsultas); // emit
  subject.complete();

  expect(component.loading()).toBe(false);
  expect(component.consultas().length).toBe(2);
});
```

**Reviewer heuristic:** any test that uses `of()` as a spy return AND has "loading" or "saving" in its name but only asserts the **final state** deserves scrutiny — it's likely false coverage. Either fix with `Subject`, rename the test to match what it actually tests, or remove it.

### Redundant Providers When Service Is Spy'd

When **mocking a service with `createSpyObj`** in a component test, the service's own dependencies (like `HttpClient`) are never instantiated. Including `provideHttpClient()` and `provideHttpClientTesting()` adds DI noise without benefit.

Similarly, **both `RouterTestingModule` (legacy) and `provideRouter([])` (modern)** register the router. Including both is redundant — prefer `provideRouter([])` for Angular 17+ standalone.

**Before (redundant):**
```typescript
TestBed.configureTestingModule({
  imports: [MyComponent, RouterTestingModule],  // ← legacy, redundant with provideRouter
  providers: [
    { provide: MyService, useValue: spy },
    provideHttpClient(),         // ← service is spy'd, HttpClient never used
    provideHttpClientTesting(),   // ← same
    provideRouter([])            // ← sufficient, no need for RouterTestingModule
  ]
});
```

**After (clean):**
```typescript
TestBed.configureTestingModule({
  imports: [MyComponent],
  providers: [
    { provide: MyService, useValue: spy },
    provideRouter([])           // ← router only
    // No HTTP providers needed — service is spy'd
  ]
});
```

**Exception:** Keep `provideHttpClient()` if the test also uses `HttpTestingController` to verify that the **real service** makes correct HTTP calls (not a spy'd service).

## Reference

- `references/provider-overlay-activatedRoute.md` — detailed case study of the provider-order bug with reproduction steps and fix.
- `references/auth-session-storage-hardening.md` — incremental JWT/session hardening pattern: move auth persistence to `sessionStorage`, keep restore/logout behavior, and assert the old store is not used.
