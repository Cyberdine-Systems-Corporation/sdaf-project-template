# Bootstrap — nuevo proyecto desde esta plantilla

Compatible con **sdaf-core@v0.2.1**. Guía larga del método: `sdaf-core/docs/adopcion-y-upgrade.md`. Skill: `sdaf-core/skills/sdaf-bootstrap`.

## 1. Renombrar el producto

1. Edita `sdaf.config.yaml` → `project.name` (deja `stack.pack: null` salvo que adopts un pack).
2. Edita `AGENTS.md` (título y fecha).
3. Edita `handbook/01-product-charter.md` y `handbook/03-mvp-definition.md` (Draft → revisión → Approved).

## 2. Verificar el core

```powershell
git submodule status
# Debe mostrar sdaf-core (v0.2.1)
```

Si el submodule está vacío:

```powershell
git submodule update --init --recursive
cd sdaf-core
git checkout v0.2.1
cd ..
```

## 2b. Materializar core (recomendado)

Enlaza skills, agentes, prompts y regla de idioma del core sin copias:

```powershell
git config core.symlinks true
.\scripts\materialize-submodules.ps1 -Force
```

Detalle: [`docs/materializacion-submodules.md`](docs/materializacion-submodules.md). Tras esto, usa rutas `agents/…` y `skills/…` (symlinks) además de `sdaf-core/…`.

## 3. Rellenar el árbol SDAF

| Paso | Acción |
|------|--------|
| Knowledge | Añade fuentes en `knowledge/raw/` (append-only) |
| Specs | Draft → revisión humana → **Approved** (`specs/`) |
| ADR | Si tocas stack/límites → `architecture/decisions/` |
| Backlog | PBI enlazado a specs |
| Worklog | `worklogs/<PBI>/Iteration-001.md` |

## 4. Gate 0

Antes de código en `src/`:

```text
Abrir sdaf-core/skills/sdaf-gate0/SKILL.md
Aplicar G0.1–G0.5 al PBI
```

En Cursor: *“Aplica sdaf-core/skills/sdaf-gate0 al PBI-…; no implementes si falla.”*

En un repo recién bootstrapado, Gate 0 → **STOP** hasta specs Approved (esperado).

## 5. Pack de stack (opcional)

Esta plantilla **no** incluye pack. Para .NET:

1. Añadir submodule `sdaf-stack-dotnet` @ `v0.1.0`.
2. `stack.pack: sdaf-stack-dotnet@0.1.0` en `sdaf.config.yaml`.
3. Ejecutar `.\scripts\materialize-submodules.ps1 -Force` (añade enlaces del pack; ver [`docs/materializacion-submodules.md`](docs/materializacion-submodules.md) y `sdaf-stack-dotnet/ADOPT.md`).

Referencia: [sdaf-smoke-core-pack](https://github.com/Cyberdine-Systems-Corporation/sdaf-smoke-core-pack).

## 6. Implementación

Solo tras Gate 0. Los agentes de UI/implementación .NET los aporta el pack o contratos locales.

## 7. Upgrade del core

```powershell
cd sdaf-core
git fetch --tags
git checkout v0.2.x   # nueva release 0.2
cd ..
git add sdaf-core
git commit -m "chore: actualizar sdaf-core a v0.2.x."
```

O aplicar la skill `sdaf-core/skills/sdaf-upgrade`. Detalle: `sdaf-core/docs/adopcion-y-upgrade.md`.
