---
name: hermes-ui-brief
description: Transformar pedidos vagos de interface em um brief implementável com usuário, hierarquia, estados, acessibilidade e critérios visuais. Use antes de iniciar uma tela ou fluxo frontend.
---

# Hermes UI brief

Antes de criar componentes, converta a ideia em decisões verificáveis:

```text
Objetivo da tela:
Usuário e contexto:
Ação primária:
Conteúdo essencial:
Hierarquia visual:
Estados: loading, vazio, erro, sucesso, foco e desabilitado
Responsividade:
Acessibilidade:
Componentes/tokens existentes:
Critérios de aprovação:
```

Use o domínio real, dados reais ou fixtures representativas e a linguagem visual documentada em `.hermes/DESIGN.md`, quando existir. Se houver mais de uma direção visual plausível, apresente opções curtas e escolha uma com base no objetivo da tela.

O brief deve limitar escopo, explicitar dependências de API e indicar como a tela será validada por build, DOM, screenshot e fluxo browser. Não transforme adjetivos como “moderno” ou “bonito” em critérios sem comportamento ou referência observável.
