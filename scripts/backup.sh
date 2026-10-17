#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
umask 077
folder="backups/$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$folder"
cp .env "$folder/environment.env"
docker compose stop proxy cron web
trap 'docker compose up -d web cron proxy' EXIT
docker compose exec -T db sh -c 'MYSQL_PWD="$MARIADB_PASSWORD" mariadb-dump -u "$MARIADB_USER" --single-transaction --skip-lock-tables --no-tablespaces "$MARIADB_DATABASE"' > "$folder/database.sql"
docker compose run --rm --no-deps -T --entrypoint tar web -czf - -C /var/www/documents . > "$folder/documents.tar.gz"
docker compose run --rm --no-deps -T --entrypoint tar web -czf - -C /var/www/html/custom . > "$folder/custom.tar.gz"
cp compose.yaml Dockerfile "$folder/"
(cd "$folder" && sha256sum database.sql documents.tar.gz custom.tar.gz > SHA256SUMS)
printf 'Respaldo local: %s. Cifrar y copiar fuera del servidor.\n' "$folder"
