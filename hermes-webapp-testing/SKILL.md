---
name: hermes-webapp-testing
description: Validar aplicações web locais com Playwright, ciclo de servidor, reconhecimento de DOM, console e evidência visual. Use em QA frontend ou regressões de fluxo.
---

# Hermes webapp testing

Use esta skill depois de definir o escopo e os critérios em `verification-planning`.

## Fluxo

1. Identifique frontend, backend, comandos de inicialização e portas.
2. Verifique o script de servidor com `--help` antes de usá-lo; não leia scripts auxiliares grandes sem necessidade.
3. Inicie e encerre servidores de forma controlada, registrando PID, URL e logs.
4. Faça reconhecimento: navegue, aguarde estado estável, capture screenshot, DOM/acessibilidade e console.
5. Só então interaja usando seletores descobertos e estáveis.
6. Valide caminho feliz, entradas inválidas, loading, erro, persistência e retorno após reload quando aplicável.
7. Anexe ao cartão comandos, status, screenshot, erros de console relevantes e limitações.

Para Angular, preserve a validação existente de API, autenticação, rotas e timezone. Prefira locators semânticos. Quando um campo nativo de data/hora não aceitar automação confiável, registre a limitação e faça a parte manual explicitamente.

Não declare aprovação apenas porque a página abriu. Um fluxo só passa quando o comportamento observável e o estado persistido atendem ao critério.
