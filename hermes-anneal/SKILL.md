---
name: hermes-anneal
description: Limpar código produzido ou alterado por agents após a funcionalidade passar, removendo duplicação, complexidade e desvios de convenção sem mudar o comportamento. Use antes do code review final.
---

# Hermes anneal

Faça uma revisão de manutenção baseada no diff e nas convenções do repositório. Procure duplicação, abstrações prematuras, branches impossíveis, tratamento silencioso de erro, comentários que substituem design, nomes inconsistentes e lógica espalhada.

Preserve comportamento e contratos. Faça uma mudança de cada vez, execute testes/regressões após cada grupo pequeno e pare quando a melhoria marginal deixar de compensar o risco. Não transforme limpeza em refatoração arquitetural sem plano próprio.

Relate o que foi removido, simplificado ou mantido, quais verificações passaram e que dívida técnica permanece. Use `hermes-architecture-review` quando a limpeza atravessar fronteiras de módulo.
