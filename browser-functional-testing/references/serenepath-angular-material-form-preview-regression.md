# SerenePath Angular Material form preview regression note

Session context:
- Frontend: `/home/alexandre/repositorios/my_app/saas_consulta_online_frontend`
- Route validated: `/consultas/nova`
- Console during validation: no JS errors.

Observed issue:
- The form page rendered cleanly and accepted typed values in the main text fields.
- The right-hand preview card did **not** update after typing into:
  - Nome do paciente
  - Nome do profissional
  - Observações
- It kept showing default placeholders such as:
  - `Paciente não informado`
  - `Profissional não selecionado`
  - `Data e hora pendentes`
  - `Sem observações adicionais`

QA implication:
- In SerenePath / Angular Material forms, a visually polished layout is not enough.
- If the page advertises a live preview or mirrored summary, it must reflect typed state immediately.
- Treat stale mirrored state as a functional regression, not a cosmetic nit.

Automation note:
- Native `input[type="date"]` and `input[type="time"]` remain awkward for browser automation; use snapshot/vision to assess their state and do not classify the automation gap itself as an app bug.
