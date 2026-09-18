---
name: verification-planning
description: Planejar evidências para mudanças não triviais antes da implementação. Use quando houver múltiplas camadas, risco de regressão ou aceitação ambígua.
---

# Verification planning

Antes de alterar código, transforme cada resultado esperado em uma cadeia verificável:

`afirmação -> artefato observado -> comando ou inspeção -> critério de aprovação`.

## Procedimento

1. Liste as afirmações que precisam ser verdadeiras depois da mudança.
2. Classifique cada uma como comportamento, integração, segurança, operação ou documentação.
3. Escolha a evidência mais barata que realmente possa falsificar a afirmação: teste, build, lint, consulta, inspeção de arquivo ou fluxo manual.
4. Registre pré-condições, dados de teste, limites e o que ainda permanece incerto.
5. Coloque o plano no cartão Kanban ou na handoff antes de delegar quando a mudança atravessar perfis.

Não use “testes passaram” como evidência universal. Relacione cada comando ao risco que ele cobre e marque explicitamente verificações não executadas.

## Saída mínima

```text
Afirmação: ...
Evidência: ...
Critério: ...
Limite/incerteza: ...
```

Depois da implementação, compare o resultado ao plano e atualize o cartão com evidências observadas, não apenas intenções.
