---
name: hermes-systematic-debugging
description: Diagnosticar falhas por observação, hipótese, teste e verificação. Use quando o comportamento observado divergir do esperado ou uma correção exigir várias tentativas.
---

# Hermes systematic debugging

Não comece editando. Primeiro reproduza ou delimite o problema, capture a saída relevante e separe fato observado de hipótese.

## Ciclo

1. Descreva o comportamento esperado e o observado.
2. Reproduza com o menor caso confiável e registre ambiente, entrada e resultado.
3. Liste hipóteses ordenadas por poder explicativo e custo de teste.
4. Teste uma hipótese por vez com a menor mudança ou inspeção possível.
5. Verifique a causa no nível correto e confirme que a correção não só mascara o sintoma.
6. Execute regressão relacionada e registre o que permanece desconhecido.

Não faça alterações especulativas em lote, não trate um erro secundário como causa sem evidência e não repita comandos destrutivos automaticamente. Use `loop-engineering` para limitar tentativas e `verification-planning` para vincular cada teste ao risco coberto.
