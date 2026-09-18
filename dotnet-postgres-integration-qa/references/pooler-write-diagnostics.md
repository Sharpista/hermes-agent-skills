# Diagnóstico de escrita em pooler PostgreSQL

Use esta sequência para separar configuração, autenticação e falha de escrita sem modificar dados persistentes.

1. Carregue a configuração em shell limpo e valide silenciosamente a presença dos campos `Host`, `Port`, `Database`, `Username` e `Password`.
2. Confirme que não existem duas variáveis com o mesmo nome semântico em capitalização diferente; em Linux, ambas podem chegar ao processo.
3. Teste TCP e autenticação separadamente. Se `pg_isready` passar e a autenticação falhar, não investigue locks ou schema ainda.
4. Execute `SELECT 1`, depois leitura de `public.players`, constraints e índice único de `puuid`.
5. Teste um upsert sintético em transação com `ROLLBACK`, sem imprimir valores sensíveis. Se leitura passar e escrita bloquear, registre o tempo e a exceção do driver.
6. Compare transaction pooler e session/direct connection apenas com endpoints oficiais. Não invente uma porta alternativa.
7. Se o pooler transaction mode estiver confirmado, verifique se o driver usa prepared statements nomeados ou estado de sessão incompatível; aplique ajuste somente após reproduzir o comportamento.
8. Reexecute o endpoint duas vezes após qualquer correção e confirme HTTP 200, identidade estável e ausência de duplicidade.

Não use `psql` diretamente com uma connection string Npgsql (`Host=...;...`); converta em memória ou use um teste Npgsql, pois os parsers aceitam formatos diferentes.
