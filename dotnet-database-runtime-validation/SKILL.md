---
name: dotnet-database-runtime-validation
description: Use when validating .NET PostgreSQL runtime connections.
---

# Validação de banco em runtime .NET

Use este workflow quando uma API .NET usa PostgreSQL/Npgsql, especialmente com Supabase, e a validação precisa distinguir conectividade do cliente `psql` de funcionamento real da aplicação.

## Procedimento

1. Descubra a configuração consumida pelo código e preserve o nome exato da variável. Para `ConnectionStrings:LoLCoach`, a variável de ambiente esperada é `ConnectionStrings__LoLCoach`; não substitua por variantes apenas por convenção visual.
2. Leia secrets somente de armazenamento seguro. Nunca imprima a variável, inclua-a em argumentos visíveis, grave-a no repositório ou deixe-a em logs. Garanta `chmod 600` no `.env` local.
3. Verifique o formato exigido pelo consumidor. Se o Npgsql da aplicação espera keywords, use `Host=...;Port=...;Database=...;Username=...;Password=...;`; não conclua que `postgresql://...` funciona só porque `psql` o aceita.
4. Valide em camadas: conectividade básica com `psql` e `select 1`; inicialização do processo .NET; endpoint real com payload válido; e repetição quando houver requisito de upsert/persistência.
5. Separe bloqueio de ambiente de bug funcional. Um `500` de inicialização/conexão deve bloquear QA e gerar correção de configuração antes de revisão; não o classifique como sucesso parcial do endpoint.
6. Após corrigir configuração, mate somente processos de teste stale, valide a porta e reinicie a aplicação a partir do build atual. Confirme status HTTP e shape da resposta para evitar testar uma instância antiga.
7. Só libere code review após QA repetir o cenário funcional que estava bloqueado e registrar evidência de sucesso.

## Regras de segurança

- Não use `set -x`, `printenv`, `env` sem filtro ou comandos que revelem secrets.
- Não versionar `.env`, connection strings, chaves Riot, tokens ou credenciais.
- Ao reportar, mostre somente nome da variável, formato mascarado, status/exit code, host mascarado e resultado funcional.

## Pitfalls generalizáveis

- `psql` aceitar uma URI não prova que o Npgsql aceitará a URI: são parsers diferentes; teste o mesmo valor no runtime .NET ou normalize para keywords.
- Nomes de variáveis de ambiente precisam corresponder à chave de configuração realmente lida pela aplicação: uma variável presente com nome alternativo pode ser efetivamente ausente.
- Conectividade TCP ou `select 1` não prova persistência: o endpoint pode falhar em migration, schema, autenticação ou upsert; sempre execute o caminho funcional real.
- Não avance QA com um `500` causado por configuração: a chave Riot ou um `200` de serviço externo não compensam a falha local de persistência.
