---
name: hermes-command-safety
description: Avaliar risco de comandos de terminal e exigir confirmação ou plano reversível para operações destrutivas. Use antes de alterar dados, histórico Git, infraestrutura ou permissões.
---

# Hermes command safety

Classifique o comando antes de executá-lo: leitura, alteração reversível, alteração com backup, destruição ou publicação externa. Para comandos perigosos, mostre escopo, alvo, impacto, backup e rollback; nunca esconda um comando destrutivo em script ou pipeline.

Trate como destrutivos, entre outros: `rm -rf`, `DROP`/`TRUNCATE`, `git reset --hard`, force-push, exclusão de branches/recursos, alteração de secrets/permissões e deploy sem rollback. Use menor privilégio e limite o alvo por caminho, ambiente e branch.

Esta skill orienta o agent; bloqueios automáticos devem ser implementados no executor do Hermes. Após a execução, valide o estado real e registre a evidência. Uma confirmação antiga não autoriza um alvo ou ação diferente.
