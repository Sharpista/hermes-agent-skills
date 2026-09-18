---
name: hermes-agent-usability
description: Avaliar se agents descobrem, escolhem e usam corretamente uma tool, MCP ou CLI sem orientação manual. Use ao criar integrações ou alterar contratos de ferramentas.
---

# Hermes agent usability

Teste a interface da ferramenta, não a inteligência do agent. Defina tarefas realistas com respostas verificáveis e execute uma linha de base sem documentação nova e outra com a documentação/skill avaliada.

Verifique cinco falhas: não descoberta, escolha errada, parâmetros usados por tentativa, schema de resposta ignorado e quedas em autenticação/timeout/rate limit. Varie ordem, contexto e casos de erro; evite que a resposta esperada vaze para o prompt.

Meça descoberta, escolha, chamada válida, interpretação da resposta, recuperação e tempo. Se a taxa melhorar apenas após instruções manuais, corrija nome, descrição, schema, exemplos ou erro da ferramenta. Registre casos, versão, resultado e limitações no cartão.
