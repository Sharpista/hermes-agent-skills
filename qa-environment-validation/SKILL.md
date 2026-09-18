---
name: qa-environment-validation
description: Use when QA validates runtime integrations safely.
---

# QA de ambiente e integração

Use este workflow quando uma validação depende de banco hospedado, API de terceiro ou processo local iniciado em background.

## Procedimento

1. Carregue o arquivo de ambiente sem `set -x`, `printenv` ou impressão de valores.
2. Valide a presença da variável exata consumida pela aplicação e rejeite aliases/capitalizações duplicadas.
3. Classifique o formato sem revelar o conteúdo. Para Npgsql, a variável deve conter `Host`, `Port`, `Database`, `Username` e `Password`; uma URI aceita por `psql` não prova compatibilidade com o parser da aplicação.
4. Valide a conectividade usando exatamente a variável consumida pelo processo da aplicação, por exemplo `psql "$ConnectionStrings__LoLCoach" -c 'select 1'`, sem registrar a string.
5. Antes de iniciar o servidor, verifique a porta e elimine somente processos de teste stale conhecidos. Depois confirme o PID, a porta e um endpoint de readiness; não confie em notificação atrasada de processo.
6. Execute preflight CORS, payload inválido e payload válido. Para integrações com persistência, repita o payload e confirme a unicidade/upsert diretamente no banco.
7. Diferencie resultado de produto de bloqueio ambiental: erro de validação/contrato é bug; segredo ausente, formato incompatível, porta/autorização ou serviço externo indisponível é bloqueio de ambiente.
8. Encerre o processo próprio, confirme a porta livre e reporte evidências mascaradas, limitações e próximo passo.

## Segurança

- Nunca exponha connection strings, senhas, API keys ou argumentos completos de processo.
- Mantenha secrets fora do repositório e use permissões restritas, como `chmod 600` para arquivos locais.
- Não aceite `psql` executado com outra variável como evidência da configuração do backend.

## Sobreposição

Complementa a skill de orquestração: ela define os gates QA/review, enquanto esta skill concentra a validação de ambiente e integração.
