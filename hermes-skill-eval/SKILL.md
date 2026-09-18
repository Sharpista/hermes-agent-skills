---
name: hermes-skill-eval
description: Testar e melhorar skills Hermes com casos de ativação, não ativação, comportamento esperado e evidência comparável. Use ao criar ou revisar uma skill.
---

# Hermes skill evaluation

Uma skill só está pronta quando o agente a aciona no contexto correto e muda o resultado de forma observável.

## Ciclo

1. Declare intenção, usuários, perfis e sinais de ativação.
2. Crie casos positivos, negativos e ambíguos; inclua tarefas reais e uma tarefa parecida que não deveria ativar a skill.
3. Execute uma linha de base sem a skill e uma execução com ela, mantendo o mesmo contexto e ferramentas.
4. Compare aderência ao objetivo, evidência produzida, regressões, tempo, chamadas e tamanho da resposta.
5. Ajuste primeiro `description`, depois instruções, referências e scripts. Repita até o ganho ser claro.

## Critérios mínimos

- a descrição explica o que fazer e quando usar;
- nenhum caso negativo aciona a skill sem motivo;
- os casos positivos produzem a saída exigida;
- comandos e referências são executáveis no perfil alvo;
- limitações e riscos ficam registrados.

Registre os resultados em um cartão ou artefato temporário de avaliação. Não transforme um único exemplo bem-sucedido em regra global. Use `reflect` para decidir se a melhoria deve virar mudança permanente.
