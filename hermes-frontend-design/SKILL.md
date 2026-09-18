---
name: hermes-frontend-design
description: Projetar interfaces frontend distintas, coerentes e prontas para produção em Angular/Material. Use ao criar ou reformular telas, fluxos e componentes visuais.
---

# Hermes frontend design

Comece pelo produto e pelo usuário: qual é a tarefa principal, qual contexto visual comunica o domínio e qual estado deve receber atenção imediata. Escolha uma direção visual deliberada antes de escrever componentes.

## Processo

1. Inspecione o design system, tokens, componentes existentes, rotas e referências visuais do projeto.
2. Defina hierarquia, tipografia, paleta, densidade, espaçamento, estados e comportamento responsivo.
3. Reutilize Angular Material e tokens compartilhados antes de criar estilos locais. Extraia componente quando houver repetição real.
4. Implemente estados de loading, vazio, erro, sucesso, foco, teclado e telas estreitas junto com o estado principal.
5. Valide com `hermes-webapp-testing`, incluindo screenshot, DOM, console e fluxo real.

## Qualidade visual

Evite layouts genéricos, gradientes decorativos sem função, excesso de cards arredondados, tipografia padrão sem intenção e centralização indiscriminada. A personalidade deve vir do domínio, do conteúdo e da hierarquia, não de efeitos acumulados.

Não sacrifique contraste, foco visível, navegação por teclado, semântica ou desempenho para obter aparência. Uma tela só está pronta quando a direção visual, a responsividade, a acessibilidade e o comportamento persistido passam na validação.
