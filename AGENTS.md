# AGENTS.md — Router de agentes MiProyecto

| Campo | Valor |
|--------|--------|
| Versión | 0.1.0 |
| Estado | Draft |
| Fecha | YYYY-MM-DD |
| Norma | `sdaf-core/handbook/13-ai-agent-framework.md`, `sdaf-core/handbook/14-prompt-engineering-standard.md`, `sdaf-core/handbook/15-agent-traceability.md`, `sdaf-core/skills/README.md` |
| Config | `sdaf.config.yaml` |
| Core | submodule `sdaf-core` @ `v0.1.0` |

---

## Propósito

Índice operativo para agentes de **ingeniería**.  
Antes de cualquier feature: Gate 0 (`sdaf-core/handbook/09-development-workflow.md` + skill `sdaf-gate0`).

## Modelo

Declarado en `sdaf.config.yaml`:

| Estado | Agentes |
|--------|---------|
| **Activo** | Specification, Architecture, Testing+Review |
| **Stub** | Product, Domain, Application, DevOps, Review, Testing |

## Handoff canónico

```text
Specification → Architecture → (implementación del consumidor / pack)
                                      ↘ Testing+Review ↗
```

## Inventario

| Agente | Contrato | Prompt | Estado |
|--------|----------|--------|--------|
| Specification | [sdaf-core/agents/specification-agent.md](sdaf-core/agents/specification-agent.md) | [sdaf-core/prompts/agents/specification-agent.md](sdaf-core/prompts/agents/specification-agent.md) | active |
| Architecture | [sdaf-core/agents/architecture-agent.md](sdaf-core/agents/architecture-agent.md) | [sdaf-core/prompts/agents/architecture-agent.md](sdaf-core/prompts/agents/architecture-agent.md) | active |
| Testing+Review | [sdaf-core/agents/testing-review-agent.md](sdaf-core/agents/testing-review-agent.md) | [sdaf-core/prompts/agents/testing-review-agent.md](sdaf-core/prompts/agents/testing-review-agent.md) | active |
| Product | [sdaf-core/agents/product-agent.md](sdaf-core/agents/product-agent.md) | [sdaf-core/prompts/agents/product-agent.md](sdaf-core/prompts/agents/product-agent.md) | stub |
| Domain | [sdaf-core/agents/domain-agent.md](sdaf-core/agents/domain-agent.md) | [sdaf-core/prompts/agents/domain-agent.md](sdaf-core/prompts/agents/domain-agent.md) | stub |
| Application | [sdaf-core/agents/application-agent.md](sdaf-core/agents/application-agent.md) | [sdaf-core/prompts/agents/application-agent.md](sdaf-core/prompts/agents/application-agent.md) | stub |
| DevOps | [sdaf-core/agents/devops-agent.md](sdaf-core/agents/devops-agent.md) | [sdaf-core/prompts/agents/devops-agent.md](sdaf-core/prompts/agents/devops-agent.md) | stub |
| Review | [sdaf-core/agents/review-agent.md](sdaf-core/agents/review-agent.md) | [sdaf-core/prompts/agents/review-agent.md](sdaf-core/prompts/agents/review-agent.md) | stub |
| Testing | [sdaf-core/agents/testing-agent.md](sdaf-core/agents/testing-agent.md) | [sdaf-core/prompts/agents/testing-agent.md](sdaf-core/prompts/agents/testing-agent.md) | stub |

## Skills

[`sdaf-core/skills/`](sdaf-core/skills/) — citar `skill-id@version` en worklogs.

## Restricciones globales

Ningún agente: aprueba handbook/specs por sí solo; salta Gate 0; implementa alcance Out del MVP; introduce secretos; reescribe historia git sin orden humana.
