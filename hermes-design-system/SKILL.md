---
name: hermes-design-system
description: Extrair, documentar e revisar o sistema visual de um projeto Angular/Material. Use antes de criar telas ou quando componentes e tokens estiverem inconsistentes.
---

# Hermes design system

Trate o sistema visual como um contrato do produto. Antes de alterar a aparência, inspecione estilos globais, tokens, temas, componentes compartilhados, fontes, ícones, breakpoints e telas de referência.

## Extração

Mapeie:

- cores semânticas e estados;
- tipografia, escala e comprimento de linha;
- espaçamento, grid, densidade e elevação;
- componentes Angular/Material e suas variantes;
- padrões de navegação, formulários, tabelas, feedback e responsividade;
- regras de acessibilidade e conteúdo visual.

Quando o projeto precisar de um artefato persistente, gere `.hermes/DESIGN.md` somente depois de verificar o `.gitignore`. Inclua caminhos dos tokens e componentes de origem, exemplos aprovados e decisões ainda incertas. Não invente valores ausentes nem copie uma referência visual sem identificar seu contexto.

## Revisão

Compare novas telas com o documento e com componentes existentes. Aponte divergências de token, hierarquia, espaçamento, estados, contraste e comportamento móvel. Prefira corrigir a fonte compartilhada a criar estilos locais duplicados.
