!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ROOT_DIR}/.env"
DOC_DIR="${ROOT_DIR}/doc"
IMG_DIR="${DOC_DIR}/img"

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "ERROR: '$1' is required."; exit 1; }
}

gen_env() {
  if [[ ! -f "${ENV_FILE}" ]]; then
    cat > "${ENV_FILE}" <<'EOF'
# ----- Creatio Deployment Env -----
CREATIO_VERSION=8.2.3

# Postgres
POSTGRES_USER=creatio
POSTGRES_PASSWORD=creatio_pass
POSTGRES_DB=creatio

# Redis
REDIS_PASSWORD=redis_pass

# NGINX
NGINX_HTTP_PORT=8080

# Optional components
ENABLE_KEYCLOAK=false
ENABLE_ELASTIC=false
ENABLE_ML=false
EOF
    echo "[env] .env created"
  else
    echo "[env] .env exists (skipped)"
  fi
}

render_diagrams() {
  mkdir -p "${IMG_DIR}"
  if command -v mmdc >/dev/null 2>&1; then
    echo "[diagrams] Rendering Mermaid → PNG"
    for f in components.mmd auth.mmd cicd.mmd analytics.mmd; do
      [[ -f "${DOC_DIR}/${f}" ]] || { echo "[warn] ${f} not found"; continue; }
      mmdc -i "${DOC_DIR}/${f}" -o "${IMG_DIR}/${f%.mmd}.png"
    done
  else
    echo "[diagrams] 'mmdc' not found. Skip rendering. (install: npm i -g @mermaid-js/mermaid-cli)"
  fi
}

compose_up() {
  docker compose up -d --build
  docker compose ps
}

compose_logs()    { docker compose logs -f --tail=200; }
compose_down()    { docker compose down; }
compose_restart() { docker compose restart; }
compose_nuke()    { docker compose down -v --remove-orphans; }

case "${1:-help}" in
  up)
    require docker
    require bash
    gen_env
    render_diagrams
    compose_up
    ;;
  logs)    compose_logs ;;
  down)    compose_down ;;
  restart) compose_restart ;;
  nuke)    compose_nuke ;;
  diagrams) render_diagrams ;;
  help|*)
    echo "Usage: $0 {up|logs|down|restart|nuke|diagrams}"
    ;;
esac
