#!/usr/bin/env bash
set -euo pipefail

REPO='/home/alexandre/repositorios/my_app/saas_consulta_online_frontend'
cd "$REPO"

echo '[1/3] Verificando configuração de produção...'
node <<'NODE'
const fs = require('fs');
const envProd = fs.readFileSync('src/environments/environment.prod.ts', 'utf8');
if (!/apiUrl:\s*'\/api'/.test(envProd)) {
  throw new Error('environment.prod.ts ainda não aponta para /api');
}
const auth = fs.readFileSync('src/app/services/auth.service.ts', 'utf8');
if (!/if \(environment\.production\)/.test(auth)) {
  throw new Error('auth.service.ts não contém o gate de produção');
}
if (!/localStorage\.removeItem\(this\.storageKey\)/.test(auth)) {
  throw new Error('auth.service.ts não remove localStorage no caminho de produção');
}
console.log('OK: env.prod e hardening de storage conferidos.');
NODE

echo '[2/3] Validando build do frontend...'
npm run build

echo '[3/3] Conferindo artefato gerado...'
node <<'NODE'
const fs = require('fs');
const dist = 'dist/saas-consulta-online-frontend';
if (!fs.existsSync(dist)) {
  throw new Error('dist não encontrado após o build');
}
console.log('OK: dist gerado em', dist);
NODE

echo 'VERIFICAÇÃO AD HOC CONCLUÍDA COM SUCESSO'
