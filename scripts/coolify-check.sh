#!/usr/bin/env bash
# Verifica que compose.yaml cumpla el contrato de Coolify (rama coolify).
# Sale 0 si todo pasa; falla con "servicio: motivo" o "compose: motivo" si no.
#
# Contrato que aplica a este repo (mariadb-local, sin Supabase):
#   1. Servicios sin profiles: nada que publique al host (ports, container_name,
#      privileged, devices, cap_add, network_mode/pid/ipc host, docker.sock).
#   2. Sin `name:` fijo a nivel raíz ni en redes ni en volúmenes.
#   Plus: la directiva `build` debe aparecer una sola vez en los servicios
#   (Coolify construye por servicio); el ancla x-app la heredaba para web y cron.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE="$ROOT/compose.yaml"

if [[ ! -f "$COMPOSE" ]]; then
  echo "Falta $COMPOSE" >&2
  exit 2
fi

fail() { echo "FALLO: $*" >&2; exit 1; }

# 1) Generar .env temporal con valores ficticios no secretos.
TMP_ENV="$(mktemp)"
trap 'rm -f "$TMP_ENV"' EXIT
vars=$(grep -oE '\$\{[A-Z_][A-Z0-9_]*\??[^}]*\}' "$COMPOSE" \
      | sed -E 's/^\$\{([A-Z_][A-Z0-9_]*).*/\1/' | sort -u)
for v in $vars; do
  case "$v" in
    CRM_HOST) printf 'CRM_HOST=https://ejemplo.invalid\n' >> "$TMP_ENV" ;;
    *)        printf '%s=x1234567890abcdef\n' "$v" >> "$TMP_ENV" ;;
  esac
done

# 2) Renderizar con docker compose config --format json.
RENDER="$(docker compose --project-directory "$ROOT" -f "$COMPOSE" --env-file "$TMP_ENV" config --format json)"
if [[ -z "$RENDER" || "$RENDER" == "null" ]]; then
  fail "docker compose config no devolvió JSON"
fi

# 3) Punto 1 del contrato: servicios sin profiles no saltan Traefik ni dan poder.
SERVICES_WITHOUT_PROFILES=$(echo "$RENDER" | jq -r '
  .services | to_entries
  | map(select((.value.profiles // []) | length == 0))
  | map(.key) | .[]')

for svc in $SERVICES_WITHOUT_PROFILES; do
  s="$(echo "$RENDER" | jq -c ".services[\"$svc\"]")"
  if echo "$s" | jq -e 'has("ports") and ((.ports // []) | length > 0)' >/dev/null; then
    fail "$svc: declara 'ports' (Coolify enruta vía Traefik; exponer publica al host)"
  fi
  if echo "$s" | jq -e '(.container_name // "") != ""' >/dev/null; then
    fail "$svc: 'container_name' fijo"
  fi
  if echo "$s" | jq -e '(.privileged // false) == true' >/dev/null; then
    fail "$svc: privileged=true"
  fi
  if echo "$s" | jq -e '.network_mode == "host"' >/dev/null; then
    fail "$svc: network_mode=host"
  fi
  if echo "$s" | jq -e '(.pid == "host") or (.ipc == "host")' >/dev/null; then
    fail "$svc: pid/ipc host"
  fi
  if echo "$s" | jq -e '(.devices // []) | length > 0' >/dev/null; then
    fail "$svc: 'devices' declarados"
  fi
  if echo "$s" | jq -e '(.cap_add // []) | length > 0' >/dev/null; then
    fail "$svc: 'cap_add' declarados"
  fi
  if echo "$s" | jq -e '(.security_opt // []) | map(select(test("unconfined"))) | length > 0' >/dev/null; then
    fail "$svc: 'security_opt' con 'unconfined'"
  fi
  bind_sources=$(echo "$s" | jq -r '.volumes[]? | select(.type == "bind") | .source')
  for src in $bind_sources; do
    case "$src" in
      /var/run/docker.sock|/run/docker.sock)
        fail "$svc: bindea docker.sock" ;;
    esac
  done
done

# 4) Punto 2 del contrato: sin 'name:' fijo. docker compose config siempre
# añade un 'name' por defecto desde el directorio del proyecto, así que la
# verificación es sobre el YAML fuente (no sobre el JSON renderizado).
python3 - "$COMPOSE" <<'PY' || fail "compose: 'name:' fijo en el YAML fuente"
import sys, yaml
data = yaml.safe_load(open(sys.argv[1]).read())
errs = []
if isinstance(data, dict):
    if data.get("name"):
        errs.append("raíz")
    for k, v in (data.get("networks") or {}).items():
        if isinstance(v, dict) and v.get("name"):
            errs.append(f"net {k}")
    for k, v in (data.get("volumes") or {}).items():
        if isinstance(v, dict) and v.get("name"):
            errs.append(f"vol {k}")
if errs:
    print("name: fijo en: " + ", ".join(errs))
    sys.exit(1)
PY

# 5) Diagnóstico: 'build' debe aparecer en un solo servicio.
build_count=$(echo "$RENDER" | jq '[.services | to_entries[] | select(.value.build != null)] | length')
if [[ "$build_count" -gt 1 ]]; then
  fail "build aparece en $build_count servicios (Coolify construye varias veces); debe quedar solo en web"
fi

echo "OK: compose cumple el contrato de Coolify."