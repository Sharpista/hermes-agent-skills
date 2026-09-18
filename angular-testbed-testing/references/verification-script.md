# Script de Verificação Ad-Hoc para Testes Angular

Use este script para validar correções em arquivos `.spec.ts` sem depender da execução dos testes (útil quando Chrome/Chromium não está disponível).

## Uso

```bash
./hermes-verify-angular-specs.sh <diretório-frontend>
```

## O que este script deve fazer

- Executar o Angular CLI local com `./node_modules/.bin/ng` para evitar dependência de `npx`
- Rodar build e um subconjunto de specs relevantes
- Preferir `--include=<diretório>` ou `--include=<spec>` repetido por argumento
- Nunca compactar múltiplos caminhos em uma única string separada por vírgula

## O Que Verifica

1. **Compilação TypeScript** - `tsc --noEmit --project tsconfig.spec.json`
2. **Imports não utilizados** - Verifica presença de imports removidos
3. **Providers redundantes** - Confirma remoção de `provideHttpClient` quando service é spy'd
4. **Padrão Subject para testes assíncronos** - Valida que testes de loading/saving usam `Subject`
5. **Estrutura de testes** - Confirma existência de testes obrigatórios
6. **Seleção de specs** - Garante que `--include` realmente encontre arquivos de teste

## Exemplo de Saída

```
=== Verificação de Correções - Testes Frontend ===

[1/6] Verificando compilação TypeScript...
  ✅ TypeScript: OK

[2/6] Verificando B-1 (remover ComponentRef)...
  ✅ B-1: ComponentRef removido

[3/6] Verificando B-2 (remover RouterTestingModule)...
  ✅ B-2: RouterTestingModule removido

[4/6] Verificando B-4 (remover provideHttpClient)...
  ✅ B-4: provideHttpClient removido de ambos os specs

[5/6] Verificando M-3 (teste saving=true com Subject)...
  ✅ M-3: Teste saving=true usa Subject

[6/6] Verificando M-1 (teste loading com Subject)...
  ✅ M-1: Teste loading usa Subject

=== Todas as verificações passaram! ===
```

## Limitações

- **Não substitui execução de testes** - apenas valida sintaxe e estrutura
- **Não detecta erros de lógica** - apenas padrões de código
- **Requer grep e bash** - não funciona em Windows sem WSL/Git Bash

## Quando Usar

- Chrome/Chromium não disponível no ambiente
- Validação rápida antes de commit
- CI/CD sem browser instalado
- Debug de estrutura de testes após refatoração
