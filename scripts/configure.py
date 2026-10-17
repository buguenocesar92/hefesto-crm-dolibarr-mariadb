#!/usr/bin/env python3
import os, re, secrets, sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
if len(sys.argv)!=2 or not re.fullmatch(r"(?=.{1,253}$)(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,63}",sys.argv[1]):
    raise SystemExit('Uso: python3 scripts/configure.py crm.tudominio.cl')
values={'CRM_HOST':sys.argv[1], 'COMPANY_NAME':'Hefesto CRM'}
for name in ['DB_PASSWORD','DB_ROOT_PASSWORD','ADMIN_PASSWORD','INSTANCE_ID','CRON_KEY']:
    values[name]=secrets.token_hex(32)
try:
    fd=os.open(root/'.env',os.O_CREAT|os.O_EXCL|os.O_WRONLY,0o600)
except FileExistsError:
    raise SystemExit('.env ya existe; no se modificó.')
with os.fdopen(fd,'w') as f:
    for k,v in values.items(): f.write(f'{k}={v}\n')
print('.env creado. Guarda sus valores en un gestor de contraseñas; no lo subas al repositorio.')
