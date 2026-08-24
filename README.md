# SDAF Project Template

Plantilla para **iniciar un proyecto consumidor** de [`sdaf-core`](https://github.com/Cyberdine-Systems-Corporation/sdaf-core) (`v0.1.0`).

Referencia de adopción validada: [`sdaf-adoption-smoke`](https://github.com/Cyberdine-Systems-Corporation/sdaf-adoption-smoke).

## Uso rápido (GitHub)

1. En GitHub: **Use this template** → crea tu repo.
2. Clona con submodules:

```powershell
git clone --recurse-submodules https://github.com/<ORG>/<TU-REPO>.git
cd <TU-REPO>
```

3. Sigue [BOOTSTRAP.md](BOOTSTRAP.md).

## Qué incluye

| Ruta | Rol |
|------|-----|
| `sdaf-core/` | Submodule pinneado a `v0.1.0` |
| `sdaf.config.yaml` | Config default-core (cambia `project.name`) |
| `AGENTS.md` | Router (ajusta nombre y enlaces) |
| `handbook/` | Stubs de constitución de **producto** (Draft) |
| `knowledge/`, `specs/`, `architecture/`, `backlog/`, `worklogs/` | Árbol SDAF vacío / con README |
| `src/`, `tests/` | Placeholders (`stack.src_path` / `tests_path`) |

## Qué no incluye

- Specs Approved ni PBI de ejemplo (eso lo genera el smoke o tu equipo).
- Pack de stack (`.NET`, etc.) — futuro `sdaf-stack-*`.
- Código de producto.

## Norma

- Método: submodule `sdaf-core`.
- Producto: tu `handbook/` + `specs/`.
- Gate 0 obligatorio antes de implementar (`sdaf-core/skills/sdaf-gate0`).
