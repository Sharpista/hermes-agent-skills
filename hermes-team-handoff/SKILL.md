---
name: hermes-team-handoff
description: "Executar cards Hermes e entregar evidências por commit."
---

# Contrato comum da equipe Hermes

Use ao receber, delegar, validar ou encerrar um card de desenvolvimento. Identificadores de perfis: `orquestrador`, `dev-backend`, `dev-frontend`, `dev-database`, `qualidade`, `code-reviewer`, `github-profile`, `devops`.

## Entrada e propriedade

Leia o card no board indicado e as instruções do repositório antes de editar. Extraia objetivo, escopo/exclusões, aceite, dependências, dono, workspace/branch, SHA candidato e autorizações. Para migrações compartilhadas, defina um único autor e um revisor; não gere duas migrations concorrentes para a mesma mudança.

```bash
hermes kanban --board <board> show <task_id>
git -C <workspace> status --short
git -C <workspace> rev-parse HEAD
git -C <workspace> merge-base --is-ancestor <sha-candidato> HEAD
```

Substitua placeholders antes de executar. A contenção do commit deve ser comprovada; registre também alterações não commitadas, pois HEAD sozinho não identifica uma árvore suja. Não reverta trabalho alheio. Se faltar a implementação no workspace de QA/review, bloqueie por dependência/workspace em vez de validar a base vazia.

## Delegação e ciclo de execução

Trabalho de outro perfil vai pelo Kanban, com `--assignee` usando o nome canônico. Crie ou reutilize um card; `--parent` define dependências, mas não incorpora commits. `--skill` carrega explicitamente skills instaladas/compartilhadas com o perfil. Para criação idempotente, reutilize uma `--idempotency-key` por tarefa lógica.

```bash
hermes kanban --board <board> create "<título>" --assignee <perfil> --workspace worktree:<repo-absoluto> --branch <branch> --body "<contrato completo>"
hermes kanban --board <board> comment <task_id> --author <perfil> "<resultado ou bloqueio com evidência>"
hermes kanban --board <board> complete <task_id> --summary "<entregável, SHA, verificações e limitações>"
hermes kanban --board <board> block <task_id> "<impedimento e condição de retomada>"
```

Consulte `--help` para flags adicionais. `--branch` exige workspace worktree; prioridade é numérica. Card criado não prova worker executando: confira runs/claim/diagnóstico em `show`. Não use `reclaim` repetidamente enquanto um processo continua ativo. Não execute também `hermes -p ... -z`, cron ou `delegate_task` para o mesmo card.

Para pedir decisão ao orquestrador, comente no card (e no parent pertinente), com alternativas e responsável. Não abra uma sessão paralela do orquestrador. Ao terminar um run despachado, feche o protocolo com `complete` ou `block` conforme o resultado e o contrato do card; um exit 0 sem encerramento não prova entrega. Se o encerramento for recusado, reporte a recusa e não altere diretamente o banco do board nem enfraqueça o contrato para contorná-la.

## Evidência e estados

Registre para cada verificação: comando/cenário, workspace, branch, SHA e estado de alterações locais, ambiente, horário, código de saída/resultado e artefato quando houver.

| Resultado | Significado |
|---|---|
| executado: passou/falhou | Comando ou cenário realmente executado, com resultado observado |
| não executado | Motivo explícito: ambiente, credencial, dependência ou fora do escopo |
| análise estática | Inspeção de código/documentação; não equivale a teste funcional |

Separe passed, failed e skipped. Mock não comprova serviço real; build não comprova fluxo ponta a ponta; teste ad hoc não é a suite completa. Nunca copie contagens de outro run como se fossem atuais. QA executa os cenários de aceite; revisão inspeciona o diff e verifica evidências para o mesmo candidato, executando verificações adicionais quando houver lacuna ou risco concreto. Um novo SHA ou ambiente diferente pode exigir revalidação; não repita tudo sem motivo.

## Saída e limites

Entregue resumo, arquivos, SHA, evidências, veredito e pendências com dono. Veredito de QA/review: `Aprovado`, `Reprovado` ou `Bloqueado`. Aprovação depende dos critérios verificados; ambiente indisponível gera bloqueio da validação pendente, não aprovação por simulação.

Implementação concluída não encerra automaticamente a demanda: qualidade e revisão ainda devem ocorrer. QA/reviewer não corrigem código da aplicação sem autorização. Push, merge, deploy, publicação de tags/releases, alterações de secrets e descarte de trabalho respeitam autorizações específicas já concedidas; não peça novamente para o mesmo escopo nem extrapole. Nunca force push ou publique credenciais.
