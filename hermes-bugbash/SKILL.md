---
name: hermes-bugbash
description: Explorar sistematicamente uma aplicação, API ou CLI para descobrir bugs, estados inconsistentes e problemas de usabilidade fora dos cenários planejados. Use em QA exploratório.
---

# Hermes bug bash

Defina área, ambiente, versão e tempo da exploração. Comece pelo caminho crítico e varie entradas, ordem de ações, reload, permissões, rede lenta, dados vazios, duplicação, concorrência e retorno após erro.

Para cada achado, preserve passos mínimos de reprodução, resultado esperado, resultado observado, evidência, severidade, frequência e possível impacto. Separe bug confirmado, suspeita e problema de ambiente. Não corrija durante a exploração sem registrar o estado original.

Use `hermes-webapp-testing` para browser, `hermes-agent-usability` para tools/MCP e `hermes-verification-gate` para fechar a rodada. A exploração termina com mapa de áreas cobertas e lacunas, não apenas com uma lista de bugs.
