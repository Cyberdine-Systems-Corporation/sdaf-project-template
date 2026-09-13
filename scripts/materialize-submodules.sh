#!/usr/bin/env bash
# Materializa skills, agentes, prompts y reglas como symlinks relativos.
# Core siempre; pack solo si existe sdaf-stack-dotnet/. Ver docs/materializacion-submodules.md
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORCE=0
WHATIF=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --what-if) WHATIF=1; shift ;;
    -h|--help) sed -n '2,5p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; exit 1 ;;
  esac
done

require_submodule() {
  local rel="$1"
  if [[ ! -e "$REPO_ROOT/$rel" ]]; then
    echo "Falta el submodule '$rel'. Ejecuta: git submodule update --init --recursive" >&2
    exit 1
  fi
}

link_or_skip() {
  local link_rel="$1"
  local target_rel="$2"
  local link_path="$REPO_ROOT/$link_rel"
  local link_dir

  link_dir="$(dirname "$link_path")"
  if ! ( cd "$link_dir" && [[ -e "$target_rel" ]] ); then
    echo "Destino inexistente para '$link_rel': $target_rel" >&2
    exit 1
  fi

  if [[ -L "$link_path" ]]; then
    local current
    current="$(readlink "$link_path")"
    if [[ "$current" == "$target_rel" ]]; then
      echo "OK: $link_rel"
      return 0
    fi
    if [[ "$FORCE" -ne 1 ]]; then
      echo "Enlace incorrecto en '$link_rel'. Usa --force." >&2
      exit 1
    fi
  elif [[ -e "$link_path" ]]; then
    if [[ "$FORCE" -ne 1 ]]; then
      echo "Existe copia en '$link_rel'. Usa --force." >&2
      exit 1
    fi
  fi

  if [[ "$WHATIF" -eq 1 ]]; then
    echo "WHATIF: $link_rel -> $target_rel"
    return 0
  fi

  mkdir -p "$link_dir"
  rm -rf "$link_path"
  ln -s "$target_rel" "$link_path"
  echo "CREATED: $link_rel -> $target_rel"
}

CORE_MANIFEST=(
  "skills/sdaf-gate0|../sdaf-core/skills/sdaf-gate0"
  "skills/sdaf-bootstrap|../sdaf-core/skills/sdaf-bootstrap"
  "skills/sdaf-upgrade|../sdaf-core/skills/sdaf-upgrade"
  "skills/sdaf-agent-router|../sdaf-core/skills/sdaf-agent-router"
  "skills/sdaf-worklog-handoff|../sdaf-core/skills/sdaf-worklog-handoff"
  "skills/adr-propose|../sdaf-core/skills/adr-propose"
  "skills/spec-draft-pbi|../sdaf-core/skills/spec-draft-pbi"
  "agents/specification-agent.md|../sdaf-core/agents/specification-agent.md"
  "agents/architecture-agent.md|../sdaf-core/agents/architecture-agent.md"
  "agents/testing-review-agent.md|../sdaf-core/agents/testing-review-agent.md"
  "agents/product-agent.md|../sdaf-core/agents/product-agent.md"
  "agents/domain-agent.md|../sdaf-core/agents/domain-agent.md"
  "agents/application-agent.md|../sdaf-core/agents/application-agent.md"
  "agents/devops-agent.md|../sdaf-core/agents/devops-agent.md"
  "agents/review-agent.md|../sdaf-core/agents/review-agent.md"
  "agents/testing-agent.md|../sdaf-core/agents/testing-agent.md"
  "prompts/agents/specification-agent.md|../../sdaf-core/prompts/agents/specification-agent.md"
  "prompts/agents/architecture-agent.md|../../sdaf-core/prompts/agents/architecture-agent.md"
  "prompts/agents/testing-review-agent.md|../../sdaf-core/prompts/agents/testing-review-agent.md"
  "prompts/agents/product-agent.md|../../sdaf-core/prompts/agents/product-agent.md"
  "prompts/agents/domain-agent.md|../../sdaf-core/prompts/agents/domain-agent.md"
  "prompts/agents/application-agent.md|../../sdaf-core/prompts/agents/application-agent.md"
  "prompts/agents/devops-agent.md|../../sdaf-core/prompts/agents/devops-agent.md"
  "prompts/agents/review-agent.md|../../sdaf-core/prompts/agents/review-agent.md"
  "prompts/agents/testing-agent.md|../../sdaf-core/prompts/agents/testing-agent.md"
  ".cursor/rules/idioma-castellano.mdc|../../sdaf-core/.cursor/rules/idioma-castellano.mdc"
)

PACK_MANIFEST=(
  "skills/csharp-adr006-slice|../sdaf-stack-dotnet/skills/csharp-adr006-slice"
  "skills/blazor-bff-slice|../sdaf-stack-dotnet/skills/blazor-bff-slice"
  "skills/aspire-local-run|../sdaf-stack-dotnet/skills/aspire-local-run"
  "agents/domain-application-agent.md|../sdaf-stack-dotnet/agents/domain-application-agent.md"
  "agents/frontend-agent.md|../sdaf-stack-dotnet/agents/frontend-agent.md"
  "agents/infrastructure-agent.md|../sdaf-stack-dotnet/agents/infrastructure-agent.md"
  "prompts/agents/domain-application-agent.md|../../sdaf-stack-dotnet/prompts/agents/domain-application-agent.md"
  "prompts/agents/frontend-agent.md|../../sdaf-stack-dotnet/prompts/agents/frontend-agent.md"
  "prompts/agents/infrastructure-agent.md|../../sdaf-stack-dotnet/prompts/agents/infrastructure-agent.md"
  ".cursor/rules/coding-standards-csharp.mdc|../../sdaf-stack-dotnet/.cursor/rules/coding-standards-csharp.mdc"
)

require_submodule sdaf-core

MANIFEST=("${CORE_MANIFEST[@]}")
if [[ -e "$REPO_ROOT/sdaf-stack-dotnet" ]]; then
  require_submodule sdaf-stack-dotnet
  MANIFEST+=("${PACK_MANIFEST[@]}")
else
  echo "Pack no presente: omitiendo entradas de sdaf-stack-dotnet."
fi

for entry in "${MANIFEST[@]}"; do
  link_or_skip "${entry%%|*}" "${entry#*|}"
done

for entry in "${MANIFEST[@]}"; do
  link_rel="${entry%%|*}"
  [[ "$link_rel" == skills/* && "$link_rel" != *.* ]] || continue
  id="${link_rel#skills/}"
  target_rel="${entry#*|}"
  link_or_skip ".cursor/skills/$id" "../${target_rel}"
done

echo ""
echo "Listo. Ejecuta: git status"
