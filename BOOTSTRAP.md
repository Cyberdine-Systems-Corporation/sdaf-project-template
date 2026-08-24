# Bootstrap — nuevo proyecto desde esta plantilla

## 1. Renombrar el producto

1. Edita `sdaf.config.yaml` → `project.name`.
2. Edita `AGENTS.md` (título y tabla si hace falta).
3. Edita `handbook/01-product-charter.md` y `handbook/03-mvp-definition.md` (Draft → revisión → Approved).

## 2. Verificar el core

```powershell
git submodule status
# Debe mostrar sdaf-core (v0.1.0)
```

Si el submodule está vacío:

```powershell
git submodule update --init --recursive
cd sdaf-core
git checkout v0.1.0
cd ..
```

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

## 5. Implementación

Solo tras Gate 0. Los agentes de implementación de stack se añaden con un pack (`stack.pack`) o contratos locales — no vienen en esta plantilla.

## 6. Upgrade del core (más adelante)

```powershell
cd sdaf-core
git fetch --tags
git checkout v0.1.x   # nueva release
cd ..
git add sdaf-core
git commit -m "chore: actualizar sdaf-core a v0.1.x."
```

Documentación de upgrade automatizado: pendiente en sdaf-core v0.2+.
