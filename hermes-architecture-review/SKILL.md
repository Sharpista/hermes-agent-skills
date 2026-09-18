---
name: hermes-architecture-review
description: Revisar arquitetura e design de código antes ou depois de mudanças estruturais. Use quando módulos, dependências, contratos ou responsabilidades forem alterados.
---

# Hermes architecture review

Mapeie os limites dos módulos, pontos de entrada, direção das dependências, contratos externos e responsabilidades antes de propor mudanças.

Avalie:

- acoplamento e dependências cíclicas;
- duplicação de regra de negócio;
- fronteiras entre domínio, aplicação, infraestrutura e UI;
- estabilidade de contratos e impacto de migrações;
- testabilidade, observabilidade e custo de evolução;
- compatibilidade com padrões já usados no repositório.

Prefira a menor mudança que melhora a fronteira real. Não introduza abstrações, camadas ou padrões apenas por preferência. Registre trade-offs, arquivos afetados, riscos de migração e evidência que sustenta a decisão.
