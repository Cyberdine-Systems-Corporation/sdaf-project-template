# Materialización de submodules (core + pack opcional)

Los consumidor SDAF pueden **enlazar** skills, agentes, prompts y reglas con symlinks relativos (Git mode `120000`) en lugar de copiarlas.

Esta plantilla incluye `scripts/materialize-submodules.ps1` / `.sh` como fuente de verdad del manifesto.

## Cuándo ejecutar

| Momento | Qué materializa |
|---------|------------------|
| Tras clonar e init de `sdaf-core` | Solo **core** (default de la plantilla) |
| Tras añadir `sdaf-stack-dotnet` y `stack.pack` | Core + **pack** (vuelve a ejecutar) |
| Tras upgrade de submodule | Re-ejecutar con `-Force` / `--force` |

## Prerequisitos

```powershell
git submodule update --init --recursive
git config core.symlinks true
```

En Windows: Modo desarrollador o shell elevado para symlinks en disco.

## Uso

```powershell
.\scripts\materialize-submodules.ps1 -WhatIf   # vista previa
.\scripts\materialize-submodules.ps1 -Force      # aplicar
```

```bash
chmod +x scripts/materialize-submodules.sh
./scripts/materialize-submodules.sh --force
```

Si `sdaf-stack-dotnet/` no existe, el script omite entradas del pack (mensaje informativo).

## Qué queda en el consumidor (archivos reales)

`AGENTS.md`, `skills/README.md`, handbook de producto, specs, `sdaf.config.yaml`, etc.

## Verificación

```powershell
git ls-files -s skills/sdaf-gate0
# mode 120000
```

## Más detalle

- Método: `sdaf-core/docs/adopcion-y-upgrade.md`
- Pack: `sdaf-stack-dotnet/ADOPT.md`
- Referencia completa: [ShiftFlow-sdaf](https://github.com/Cyberdine-Systems-Corporation/ShiftFlow-sdaf) (`docs/materializacion-submodules.md`)

## Fuera de alcance

- CLI empaquetada (`sdaf materialize`)
- Junctions Windows (`mklink /J`)
