---
name: hermes-deploy-checklist
description: Validar uma entrega antes, durante e depois do deploy, incluindo configuração, migrações, rollback e smoke test.
---

# Hermes deploy checklist

Antes do deploy, confirme artefato e commit, variáveis obrigatórias, permissões, migrações compatíveis, dependências externas, backup e plano de rollback. Separe mudanças reversíveis de migrações destrutivas.

Durante, registre horário, ambiente, versão, operador e sinais de falha. Faça rollout gradual quando disponível e monitore logs, métricas, erros, latência e saúde das dependências.

Depois, execute smoke tests do caminho crítico, confirme persistência e autenticação, compare métricas com a linha de base e registre o resultado no cartão. Se o critério falhar, pare a promoção ou aplique rollback conforme o plano; não normalize uma falha silenciosa.
