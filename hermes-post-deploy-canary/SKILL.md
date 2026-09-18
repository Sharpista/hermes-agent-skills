---
name: hermes-post-deploy-canary
description: Executar smoke tests pós-deploy com rotas críticas, console, carregamento, performance e comparação visual. Use após publicar frontend ou mudanças de configuração.
---

# Hermes post-deploy canary

Defina antes do deploy uma baseline: URLs críticas, expectativa de status, screenshot quando útil, limiar de carregamento, ausência de erros de console e caminho de autenticação permitido. Após publicar, execute o mesmo conjunto no ambiente alvo.

Verifique health endpoint, login quando autorizado, rota inicial, navegação principal, assets, chamadas de API, console, LCP/INP/CLS quando disponíveis e um fluxo crítico de negócio. Compare com a baseline e registre versão, horário, ambiente, evidência e diferenças.

Se houver falha, interrompa promoção ou aplique rollback conforme `hermes-deploy-checklist`. Não trate uma página HTTP 200 como prova de saúde da aplicação.
