---
name: hermes-tdd
description: Aplicar desenvolvimento orientado por testes para comportamentos determinísticos e regressões reproduzíveis. Use quando o critério puder ser expresso como teste automatizado.
---

# Hermes TDD

Use o ciclo red, green, refactor:

1. escreva o menor teste que expressa o comportamento esperado;
2. execute e confirme que falha pela razão certa;
3. implemente a mudança mínima para passar;
4. execute o teste e as regressões relacionadas;
5. refatore preservando os testes.

Prefira testes de comportamento a testes que espelham a implementação. Para integrações, use fixtures e contratos estáveis; para UI, combine teste de componente com fluxo browser quando o risco atravessar a tela. Se não houver uma forma confiável de testar primeiro, documente a razão e use `verification-planning` para definir outra evidência.
