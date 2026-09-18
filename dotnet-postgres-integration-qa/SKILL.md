---
name: dotnet-postgres-integration-qa
description: Use when testing .NET PostgreSQL integrations.
---

# QA de integração .NET + PostgreSQL/Supabase

Use este workflow para validar APIs ASP.NET Core que consultam e persistem em PostgreSQL hospedado, especialmente quando o frontend depende de um POST de busca/upsert.

## Procedimento

1. Preserve o estado do repositório e não altere código durante QA. Execute a validação na branch da entrega e registre a branch usada.
2. Use o mecanismo de secrets autorizado para o projeto e o ambiente de teste. Não carregue o `.env` de outro perfil automaticamente. Quando um arquivo de ambiente confiável for necessário, identifique seu caminho explícito no card e valide as permissões; não imprima valores nem os passe em argumentos visíveis. Não execute conteúdo de arquivos não confiáveis como shell.
3. Descubra a chave realmente consumida pelo código .NET e use seu mapeamento de ambiente exato. Por exemplo, `ConnectionStrings:LoLCoach` corresponde a `ConnectionStrings__LoLCoach` somente naquele projeto. Não renomeie configurações de outros projetos para esse exemplo. Remova variantes conflitantes apenas do ambiente descartável de teste.
4. Garanta quoting correto no `.env`: valores Npgsql contendo `;` devem estar entre aspas. Sem quoting, o shell encerra a atribuição no primeiro ponto e vírgula e o processo recebe uma string truncada. Após alterar um secret, valide a string efetivamente carregada pelo processo, não apenas o conteúdo bruto do arquivo.
5. Diferencie os níveis de conectividade na ordem: TCP (`pg_isready`), autenticação, `SELECT`, leitura da tabela, `INSERT/UPDATE`, upsert e retorno da API. Um `SELECT 1` verde não prova permissão ou funcionamento de escrita. Quando uma senha for rotacionada via Management API, trate o HTTP 2xx como confirmação administrativa apenas e valide a autenticação real no pooler com a mesma credencial antes de reabrir a QA.
6. Para pooler Supabase, confirme host, porta e usuário pela configuração oficial. A porta `6543` costuma ser transaction mode; verifique compatibilidade com pooling, prepared statements e estado de sessão antes de concluir que o SQL está errado. Use porta direta/session mode somente quando oficialmente fornecida.
7. Ao testar upsert, use dados sintéticos controlados e rollback quando possível. Para o fluxo real, execute duas chamadas idênticas e compare a identidade retornada; nunca imprima PUUID, senha, connection string ou tokens completos.
8. Mapeie a falha para a camada correta:
   - `password authentication failed`: credencial/usuário/variável concorrente;
   - erro no índice/tabela/permission: schema ou autorização;
   - timeout após leitura com `SELECT` verde: investigar transação, pooler, locks e conectividade de escrita;
   - HTTP 500 após Riot/API externa 200: persistência, não classificar como falha da Riot.
9. Antes de iniciar nova instância em uma porta, confirme se ela está livre. Depois de encerrá-la, confirme novamente a porta e o estado do processo; notificações assíncronas de `Now listening on` podem chegar atrasadas e não provam que o servidor continua ativo.
10. Só aprovar os critérios de QA depois das verificações pertinentes ao card: build/testes, contrato HTTP, CORS quando aplicável, persistência e repetição idempotente quando exigida. Browser indisponível deve ser reportado como limitação separada, não convertido em bug funcional.

## Critérios de aprovação para o cenário de busca/upsert

Aplique estes critérios quando esse for o contrato do card; outros endpoints devem seguir seus próprios status HTTP e requisitos.

- Build do backend e testes automatizados passam.
- Preflight CORS retorna a origem esperada no ambiente de desenvolvimento.
- Payload inválido retorna Problem Details adequado.
- Payload válido retorna HTTP 200 com identidade persistida.
- Segunda chamada idêntica mantém a mesma identidade e não cria duplicata.
- Segredos não aparecem em arquivos rastreados, logs ou relatórios.
- Qualquer limitação visual/browser é explicitamente separada da decisão funcional.

## Referências

Para o roteiro de diagnóstico de poolers e escrita, consulte `references/pooler-write-diagnostics.md`.
