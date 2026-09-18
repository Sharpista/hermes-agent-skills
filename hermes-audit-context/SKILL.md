---
name: hermes-audit-context
description: Construir contexto técnico antes de uma auditoria de segurança ou revisão profunda. Use para rastrear fluxo de dados, invariantes, contratos e fronteiras de confiança.
---

# Hermes audit context

Antes de procurar vulnerabilidades, produza um modelo verificável do sistema:

- entrypoints e atores autorizados;
- fluxo de dados entre frontend, API, serviços, banco e integrações;
- pré-condições, pós-condições e invariantes por função crítica;
- estados persistidos, transições e efeitos colaterais;
- fronteiras de confiança e validações em cada limite;
- dependências externas, retries e tratamento de erro.

Use caminhos, símbolos e linhas. Trace chamadas até helpers relevantes, confirme contratos no código e marque suposições. Só depois aplique `security-audit` ou `hermes-architecture-review`. Se o mapa estiver incompleto, classifique a incerteza em vez de tratar ausência de evidência como ausência de risco.
