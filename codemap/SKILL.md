---
name: codemap
description: Construir um mapa compacto e verificável de um repositório antes de mudanças arquiteturais ou quando a topologia for desconhecida.
---

# Codemap

Use esta skill para reduzir exploração repetida. Primeiro leia `AGENTS.md`, `README`, manifests, entrypoints e configuração de CI. Depois identifique módulos, dependências entre eles, pontos de entrada, testes, integrações externas e arquivos de configuração.

Produza um mapa curto com:

- limites dos módulos e responsabilidade de cada um;
- fluxos de dados e chamadas relevantes;
- comandos de build, teste e lint;
- riscos, áreas sem cobertura e arquivos prováveis de mudança.

Prefira referências com caminho e símbolo/linha. Valide o mapa contra o estado atual do repositório e atualize-o quando hashes ou estrutura mudarem. Não gere uma árvore enorme nem trate o mapa como verdade permanente.

Se for necessário persistir o artefato, use um diretório local ignorado pelo projeto (por padrão `.hermes/codemap/`) e confirme o `.gitignore` antes de criar arquivos. O mapa apoia o plano de verificação; não substitui testes, revisão ou evidência de execução.
