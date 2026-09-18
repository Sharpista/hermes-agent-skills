---
name: loop-engineering
description: Estruturar ciclos limitados de tentativa, observação e verificação para correções e validações. Use quando uma tarefa exigir retries ou diagnóstico iterativo.
---

# Loop engineering

Use um ciclo explícito para evitar tentativas indefinidas:

`objetivo -> ação -> observação -> decisão -> próxima ação`.

Defina antes de começar:

- objetivo e critério de sucesso;
- executor autorizado e comando exato;
- verificador independente;
- máximo de tentativas e condição de parada;
- estado a preservar entre tentativas.

Tipos de verificador úteis: `test`, `build`, `lint`, `command`, `fileExists`, `oracle`, `observer` e `manual`. Uma verificação manual não deve ser declarada resolvida sem registro humano da observação.

Em cada iteração, registre o erro observado, a hipótese que será testada e a mudança mínima. Pare quando o critério passar, quando o limite for atingido ou quando a hipótese deixar de ser sustentada. Nesse último caso, marque o cartão como bloqueado ou escale com evidência.

Não transforme falhas de ambiente em falhas do produto. Separe código de saída, logs relevantes, dependências ausentes e efeitos colaterais. Nunca repita comandos destrutivos automaticamente.
