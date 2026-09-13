# SDAF Project Template

Plantilla para **iniciar un proyecto consumidor** de [`sdaf-core`](https://github.com/Cyberdine-Systems-Corporation/sdaf-core) (`v0.2.0`).

Smokes de adopción:

- Solo método: [`sdaf-adoption-smoke`](https://github.com/Cyberdine-Systems-Corporation/sdaf-adoption-smoke) (histórico `v0.1.0`)
- Método + pack .NET: [`sdaf-smoke-core-pack`](https://github.com/Cyberdine-Systems-Corporation/sdaf-smoke-core-pack) (`v0.2.0` + `sdaf-stack-dotnet@0.1.0`)

## Uso rápido (GitHub)

1. En GitHub: **Use this template** → crea tu repo.
2. Clona con submodules:

```powershell
git clone --recurse-submodules https://github.com/<ORG>/<TU-REPO>.git
cd <TU-REPO>
git config core.symlinks true
.\scripts\materialize-submodules.ps1 -Force
```

3. Sigue [BOOTSTRAP.md](BOOTSTRAP.md).

Materialización: [`docs/materializacion-submodules.md`](docs/materializacion-submodules.md) (core al clonar; pack tras adoptarlo).

## Qué incluye

| Ruta | Rol |
|------|-----|
| `sdaf-core/` | Submodule pinneado a `v0.2.0` |
| `sdaf.config.yaml` | Config default-core (`pack: null`; cambia `project.name`) |
| `AGENTS.md` | Router (ajusta nombre; citas handbook 0.2) |
| `handbook/` | Stubs de constitución de **producto** (Draft) |
| `knowledge/`, `specs/`, `architecture/`, `backlog/`, `worklogs/` | Árbol SDAF vacío / con README |
| `scripts/materialize-submodules.*` | Symlinks core (+ pack si existe) |
| `docs/materializacion-submodules.md` | HOWTO materialización |
| `src/`, `tests/` | Placeholders (`stack.src_path` / `tests_path`) |

## Qué no incluye

- Specs Approved ni PBI de ejemplo.
- Pack de stack por defecto — opcional: [`sdaf-stack-dotnet`](https://github.com/Cyberdine-Systems-Corporation/sdaf-stack-dotnet) vía `stack.pack` (ver ADOPT del pack).
- Código de producto.

## Norma

- Método: submodule `sdaf-core` (Parte I 01–05, Parte II 06–08, apéndice A).
- Producto: tu `handbook/` + `specs/`.
- Gate 0 obligatorio antes de implementar (`sdaf-core/skills/sdaf-gate0`).
- Adopción/upgrade: `sdaf-core/docs/adopcion-y-upgrade.md` y skills `sdaf-bootstrap` / `sdaf-upgrade`.
