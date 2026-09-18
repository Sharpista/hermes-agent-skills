---
name: hermes-skill-improvement
description: Melhorar uma skill Hermes em ciclo controlado com baseline, hipótese, casos de teste e comparação antes/depois. Use quando uma skill falhar, acionar errado ou produzir instruções inconsistentes.
---

# Hermes skill improvement

1. Escolha uma skill e fixe o commit baseline.
2. Colete exemplos reais de ativação, não ativação e falha.
3. Formule uma hipótese sobre descrição, instrução, referência ou script.
4. Faça a menor alteração possível.
5. Execute casos comparáveis antes/depois e avalie trigger, aderência, evidência, regressões, tempo e tamanho da resposta.
6. Mantenha a mudança somente quando o ganho for claro; registre o resultado no commit.

Não reescreva várias skills por preferência estética, não use um único exemplo como prova e não guarde dados sensíveis dos prompts de avaliação. Use `hermes-skill-eval` para os casos e `reflect` para decidir se o padrão deve virar regra global.
