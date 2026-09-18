# Reactive form live preview: signals + `toSignal`

## When this matters

Use this pattern when a component shows a live summary/preview of a reactive form and the preview must update as the user types.

## Root cause to remember

`computed(() => this.form.getRawValue())` is **not** reactive by itself.
`FormGroup` mutations happen outside Angular signals, so a `computed` that reads `getRawValue()` can stay stale.

## Reliable pattern

Derive a signal from `form.valueChanges` and use that signal inside the preview computed:

```ts
import { computed, signal } from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';

readonly form = this.fb.nonNullable.group({
  pacienteNome: ['', Validators.required],
  observacoes: ['']
});

private readonly formValue = toSignal(this.form.valueChanges, {
  initialValue: this.form.getRawValue()
});

readonly preview = computed(() => {
  const value = this.formValue();
  return {
    pacienteNome: value.pacienteNome || 'Paciente não informado',
    observacoes: value.observacoes || 'Sem observações adicionais'
  };
});
```

## Test strategy

- Call `fixture.detectChanges()` to trigger `ngOnInit()`.
- Use `form.patchValue(...)` to simulate typing.
- Assert the computed preview after the patch.
- If formatted dates are locale-aware, assert the actual helper output used by the app instead of assuming a raw `dd/MM/yyyy` shape.

## Pitfalls

- `computed` over `form.getRawValue()` stays stale.
- `valueChanges` does not emit the initial snapshot unless you seed it with `initialValue`.
- Tests that only assert form values do **not** prove the preview is wired correctly.
