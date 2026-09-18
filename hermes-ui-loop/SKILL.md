---
name: hermes-ui-loop
description: Conduzir um ciclo de implementação, build, browser, screenshot e revisão visual de interfaces. Use quando uma tela precisar de refinamento visual ou validação contra um design system.
---

# Hermes UI loop

Execute ciclos pequenos e observáveis:

1. leia o `hermes-ui-brief` e o `hermes-design-system`;
2. implemente uma fatia coerente da tela;
3. execute build, lint ou testes aplicáveis;
4. abra o fluxo com `hermes-webapp-testing`;
5. capture DOM/acessibilidade, console e screenshot;
6. compare com o brief e o `DESIGN.md`;
7. corrija a menor divergência e repita com limite de tentativas.

Revise em camadas: primeiro estrutura e conteúdo, depois hierarquia e espaçamento, depois tipografia e cor, por fim microinterações. Verifique também teclado, foco, contraste, telas estreitas, loading, erro e persistência. Não aprove uma tela apenas por parecer boa em uma captura isolada.

Registre no cartão o comando executado, URL/ambiente, screenshot ou observação, console relevante, resultado e limitações manuais. Use `hermes-verification-gate` antes de concluir.
