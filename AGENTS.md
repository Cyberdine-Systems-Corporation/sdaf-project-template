# AGENTS.md — Router de agentes MiProyecto

| Campo | Valor |
|--------|--------|
| Versión | 0.2.1 |
| Estado | Draft |
| Fecha | YYYY-MM-DD |
| Norma | `sdaf-core/handbook/06-ai-agent-framework.md`, `sdaf-core/handbook/07-prompt-engineering-standard.md`, `sdaf-core/handbook/08-agent-traceability.md`, `sdaf-core/skills/README.md` |
| Config | `sdaf.config.yaml` |
| Core | submodule `sdaf-core` @ `v0.2.1` |

---

## Propósito

Índice operativo para agentes de **ingeniería**.  
Antes de cualquier feature: Gate 0 (`sdaf-core/handbook/05-development-workflow.md` + skill `sdaf-gate0`).

## Modelo

Declarado en `sdaf.config.yaml` (`stack.pack: null` en esta plantilla):

| Estado | Agentes |
|--------|---------|
| **Activo** | Specification, Architecture, Testing+Review |
| **Stub** | Product, Domain, Application, DevOps, Review, Testing |

Fusiones o `frontend` / `domain-application` se añaden con un pack (`sdaf-stack-*`) o contratos locales.

## Handoff canónico

```text
Specification → Architecture → (implementación del consumidor / pack)
                                      ↘ Testing+Review ↗
```

## Inventario

Tras [`scripts/materialize-submodules.ps1`](scripts/materialize-submodules.ps1) (`-Force`), contratos y prompts en `agents/` y `prompts/agents/` son symlinks al pin del core (y del pack si existe). Ver [`docs/materializacion-submodules.md`](docs/materializacion-submodules.md).

| Agente | Contrato | Prompt | Estado |
|--------|----------|--------|--------|
| Specification | [agents/specification-agent.md](agents/specification-agent.md) | [prompts/agents/specification-agent.md](prompts/agents/specification-agent.md) | active |
| Architecture | [agents/architecture-agent.md](agents/architecture-agent.md) | [prompts/agents/architecture-agent.md](prompts/agents/architecture-agent.md) | active |
| Testing+Review | [agents/testing-review-agent.md](agents/testing-review-agent.md) | [prompts/agents/testing-review-agent.md](prompts/agents/testing-review-agent.md) | active |
| Product | [agents/product-agent.md](agents/product-agent.md) | [prompts/agents/product-agent.md](prompts/agents/product-agent.md) | stub |
| Domain | [agents/domain-agent.md](agents/domain-agent.md) | [prompts/agents/domain-agent.md](prompts/agents/domain-agent.md) | stub |
| Application | [agents/application-agent.md](agents/application-agent.md) | [prompts/agents/application-agent.md](prompts/agents/application-agent.md) | stub |
| DevOps | [agents/devops-agent.md](agents/devops-agent.md) | [prompts/agents/devops-agent.md](prompts/agents/devops-agent.md) | stub |
| Review | [agents/review-agent.md](agents/review-agent.md) | [prompts/agents/review-agent.md](prompts/agents/review-agent.md) | stub |
| Testing | [agents/testing-agent.md](agents/testing-agent.md) | [prompts/agents/testing-agent.md](prompts/agents/testing-agent.md) | stub |

Antes de materializar, las mismas rutas viven bajo `sdaf-core/agents/` y `sdaf-core/prompts/agents/`.

## Skills

[`skills/`](skills/) tras materializar (symlinks al core). Índice: [skills/README.md](skills/README.md). Cursor: `.cursor/skills/<id>`.

Citar `skill-id@version` en worklogs. Alta: `sdaf-gate0`, `sdaf-worklog-handoff`, `sdaf-agent-router`, `sdaf-bootstrap`.

## Restricciones globales

Ningún agente: aprueba handbook/specs por sí solo; salta Gate 0; implementa alcance Out del MVP; introduce secretos; reescribe historia git sin orden humana.
