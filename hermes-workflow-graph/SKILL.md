---
name: hermes-workflow-graph
description: Modelar uma demanda como nós, dependências, gates e transições verificáveis sobre o Kanban Hermes. Use em trabalhos multi-etapa ou com correções iterativas.
---

# Hermes workflow graph

O Kanban continua sendo a fonte de verdade. Use este grafo para explicitar a ordem e as condições de avanço:

`backlog -> planned -> implementing -> validating -> reviewing -> approved -> completed`.

Cada nó deve declarar objetivo, responsável, entradas, artefato produzido, verificador e condição de saída. Cada transição deve ter uma evidência observável. Se QA reprovar, retorne a `implementing` com uma tarefa corretiva; se a revisão reprovar, retorne ao responsável técnico e preserve o achado.

Não avance por tempo decorrido ou por relato do agent. Não crie um segundo sistema de tarefas fora do Kanban. Limite ciclos, registre bloqueios e permita somente transições compatíveis com dependências concluídas.
