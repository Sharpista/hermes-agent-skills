# Consultas Online — smoke de agendamento, auth e UX

## Sequência que funcionou nesta sessão
1. Fazer login com credenciais válidas.
2. Confirmar que rota protegida sem token retorna 401/redirect para login.
3. Criar consulta futura no horário local de negócio (`America/Sao_Paulo`).
4. Confirmar persistência na listagem após refresh/reload.
5. Testar conflito de duplicidade para o mesmo psicólogo/horário e confirmar `409`.
6. Testar agendamento no passado e confirmar `400` com mensagem clara.
7. Validar logout e retorno direto à área pública/anônima.
8. Validar acesso a endpoint de admin com token não-admin e confirmar `403`.

## Payload/contrato confirmado
- `POST /api/auth/login` com `email` + `senha`.
- `POST /api/consultas` e `PUT /api/consultas/{id}` aceitam:
  - `pacienteNome`
  - `psicologoNome`
  - `data` (`yyyy-MM-dd`)
  - `hora` (`HH:mm`)
  - `observacoes`
- O backend também devolve `dataHorario` e o frontend normaliza para `data` + `hora`.

## Mensagens e códigos observados
- Login válido: `200`
- Login inválido: `401`
- Sem token em `/api/consultas`: `401`
- Consulta futura válida: `201`
- Consulta passada: `400` (mensagem indicando data futura)
- Conflito de horário: `409` (mensagem indicando conflito/disponibilidade)
- Relatório sem role admin: `403`

## Observações de QA
- Validar o relógio/linha de tempo sempre no fuso local da clínica, não em UTC bruto.
- Para decisão final, a persistência na lista e a navegação protegida valem mais que a aparência do formulário.
- Se o browser mostrar overlay de erro antigo do dev server, reconfirme em sessão limpa antes de abrir bug de produto.
