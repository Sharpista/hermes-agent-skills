---
name: hermes-verification-gate
description: Fazer a verificação final antes de concluir uma tarefa ou cartão Kanban. Use sempre que uma implementação estiver pronta para ser reportada como concluída.
---

# Hermes verification gate

Antes de declarar conclusão, confirme quatro elementos:

1. critério de aceite identificado;
2. comando, inspeção ou fluxo manual executado;
3. resultado observado e comparado ao critério;
4. limitações, riscos residuais e verificações não executadas registrados.

Escolha a verificação proporcional ao risco. Releia os arquivos alterados, execute os testes relevantes e faça um smoke test quando houver integração ou UI. “Código compilou” não prova comportamento funcional; “teste passou” não cobre riscos que o teste não exercitou.

Se algum elemento faltar, mantenha o cartão aberto, marque-o bloqueado ou peça a evidência necessária. Não invente resultados e não converta uma intenção futura em aprovação.
