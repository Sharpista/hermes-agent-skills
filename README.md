# Hermes Agent Skills

Skills compartilhadas para o [Hermes Agent](https://github.com/NousResearch/hermes-agent), organizadas para uma equipe de agents especializados em desenvolvimento, QA, revisão e operação.

O repositório mantém uma fonte canônica para evitar que cada perfil tenha instruções divergentes. As skills seguem o formato `SKILL.md` com metadados `name` e `description`, e podem ser usadas por qualquer agent compatível com o padrão Agent Skills.

## Categorias

### Coordenação e evidência

- `hermes-team-handoff`: contrato de handoff, Kanban e evidências.
- `verification-planning`: planeja como cada afirmação será verificada.
- `hermes-verification-gate`: impede conclusão sem evidência fresca.
- `loop-engineering`: limita ciclos de tentativa, observação e correção.
- `hermes-skill-eval`: avalia triggers e impacto das próprias skills.
- `reflect`: propõe melhorias somente quando há fricção recorrente.

### Desenvolvimento e arquitetura

- `hermes-systematic-debugging`: diagnóstico por hipótese e teste.
- `hermes-tdd`: ciclo red, green, refactor.
- `hermes-architecture-review`: revisão de módulos, contratos e dependências.
- `codemap`: mapa compacto de repositórios desconhecidos.
- Skills específicas para .NET, Angular, PostgreSQL e autenticação.

### Frontend e qualidade

- `hermes-frontend-design`: design Angular/Material orientado ao domínio.
- `hermes-design-system`: extração e revisão de tokens e componentes.
- `hermes-ui-brief`: brief implementável para telas e fluxos.
- `hermes-ui-loop`: implementação, build, browser, screenshot e revisão.
- `hermes-webapp-testing`: Playwright, DOM, console e evidência visual.
- Skills de testes funcionais, TestBed e revisão de entrega frontend.

### Integrações e operação

- `hermes-mcp-builder`: contratos e avaliação de servidores MCP.
- `security-audit`: fronteiras de confiança, segredos e risco residual.
- `hermes-incident-response`: contenção, recuperação e postmortem.
- `hermes-deploy-checklist`: pré-deploy, rollout, smoke test e rollback.

## Uso no Hermes

As skills são distribuídas pelos perfis em `~/.hermes/profiles/*/config.yaml` através de `skills.external_dirs`. O mapa de distribuição está em [`distribution.json`](./distribution.json).

Para instalar em uma máquina com Hermes já instalado:

```bash
git clone https://github.com/Sharpista/hermes-agent-skills.git ~/.hermes/shared/agent-skills
```

Depois, aponte os perfis Hermes para os diretórios relevantes em `skills.external_dirs`. A configuração completa dos perfis fica no repositório privado [`Sharpista/hermes-config`](https://github.com/Sharpista/hermes-config).

## Princípios

- evidência antes de afirmações de sucesso;
- mudanças pequenas e verificáveis;
- segurança e dados externos tratados como não confiáveis;
- reutilização de componentes e contratos existentes;
- skills curtas, específicas e carregadas sob demanda;
- nenhuma credencial, sessão ou estado local versionado.

## Desenvolvimento

Cada skill deve ficar em um diretório próprio com `SKILL.md`. Mantenha a descrição específica sobre o que a skill faz e quando deve ser usada. Use referências ou scripts apenas quando eles reduzirem repetição ou tornarem a execução verificável.

Valide uma skill com o validador do Codex:

```bash
python3 /home/alexandre/.codex/skills/.system/skill-creator/scripts/quick_validate.py caminho/da/skill
```

Antes de publicar, valide o YAML dos perfis, o carregamento real no Hermes e a ausência de segredos ou dados de sessão.
