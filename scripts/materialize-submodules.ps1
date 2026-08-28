#Requires -Version 5.1
<#
.SYNOPSIS
  Materializa skills, agentes, prompts y reglas del consumidor SDAF como symlinks relativos.

.DESCRIPTION
  Core (sdaf-core): siempre. Pack (sdaf-stack-dotnet): solo si el submodule existe.
  Idempotente. Sin junctions. Ver docs/materializacion-submodules.md

.PARAMETER WhatIf
  Lista enlaces sin modificar el disco.

.PARAMETER Force
  Reemplaza copias o enlaces incorrectos.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Test-SubmodulePresent {
    param([string]$RelativePath)
    $full = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path $full)) {
        throw "Falta el submodule '$RelativePath'. Ejecuta: git submodule update --init --recursive"
    }
}

function Get-LinkTargetRelative {
    param([string]$LinkPath)
    if (-not (Test-Path $LinkPath)) { return $null }
    $item = Get-Item -LiteralPath $LinkPath -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        return $item.Target
    }
    return $null
}

function Remove-LinkOrCopy {
    param([string]$LinkPath)
    if (-not (Test-Path $LinkPath)) { return }
    $item = Get-Item -LiteralPath $LinkPath -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Remove-Item -LiteralPath $LinkPath -Force
    }
    elseif ($item.PSIsContainer) {
        Remove-Item -LiteralPath $LinkPath -Recurse -Force
    }
    else {
        Remove-Item -LiteralPath $LinkPath -Force
    }
}

function Remove-GitTracked {
    param([string]$LinkRelative)
    $tracked = git -C $RepoRoot ls-files -- $LinkRelative 2>$null
    if ($tracked) {
        git -C $RepoRoot rm -r -f -- $LinkRelative 2>$null | Out-Null
    }
}

function Add-GitSymlinkIndex {
    param(
        [string]$LinkRelative,
        [string]$TargetRelative
    )
    $normalizedTarget = ($TargetRelative -replace '\\', '/').TrimEnd('/')
    $hash = ($normalizedTarget | git -C $RepoRoot hash-object -w --stdin).Trim()
    if (-not $hash) {
        throw "git hash-object falló para '$LinkRelative'"
    }
    git -C $RepoRoot update-index --add --cacheinfo "120000,$hash,$LinkRelative" | Out-Null
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    git -C $RepoRoot checkout-index -f -- $LinkRelative 2>&1 | Out-Null
    $ErrorActionPreference = $prevEap
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Índice Git actualizado; working tree sin symlink OS para '$LinkRelative'. Activa Modo desarrollador o reclona con core.symlinks."
    }
}

function New-RelativeSymlink {
    param(
        [string]$LinkRelative,
        [string]$TargetRelative
    )

    $linkPath = Join-Path $RepoRoot $LinkRelative
    $linkDir = Split-Path $linkPath -Parent
    $targetPath = [System.IO.Path]::GetFullPath((Join-Path $linkDir $TargetRelative))

    if (-not (Test-Path $targetPath)) {
        throw "Destino inexistente para '$LinkRelative': $TargetRelative"
    }

    $existing = Get-LinkTargetRelative -LinkPath $linkPath
    if ($null -ne $existing) {
        $normalizedExisting = ($existing -replace '\\', '/').TrimEnd('/')
        $normalizedExpected = ($TargetRelative -replace '\\', '/').TrimEnd('/')
        if ($normalizedExisting -eq $normalizedExpected) {
            Write-Verbose "OK: $LinkRelative"
            return 'skipped'
        }
        if (-not $Force) {
            throw "Enlace incorrecto en '$LinkRelative' (actual: $existing). Usa -Force."
        }
    }
    elseif (Test-Path $linkPath) {
        if (-not $Force) {
            throw "Existe copia en '$LinkRelative'. Usa -Force para reemplazar por symlink."
        }
    }

    if ($PSCmdlet.ShouldProcess($LinkRelative, "symlink -> $TargetRelative")) {
        if (-not (Test-Path $linkDir)) {
            New-Item -ItemType Directory -Path $linkDir -Force | Out-Null
        }
        Remove-GitTracked -LinkRelative $LinkRelative
        Remove-LinkOrCopy -LinkPath $linkPath
        try {
            $uriBase = New-Object System.Uri (($linkDir.TrimEnd('\') + '\'))
            $uriTarget = New-Object System.Uri $targetPath
            $targetForLink = [System.Uri]::UnescapeDataString($uriBase.MakeRelativeUri($uriTarget).ToString()) -replace '/', '\'
            New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetForLink -ErrorAction Stop | Out-Null
            git -C $RepoRoot add -- $LinkRelative 2>$null | Out-Null
        }
        catch {
            Write-Warning "Symlink OS no disponible para '$LinkRelative' ($($_.Exception.Message)). Usando índice Git (120000)."
            Add-GitSymlinkIndex -LinkRelative $LinkRelative -TargetRelative $TargetRelative
        }
        return 'created'
    }
    return 'whatif'
}

$CoreManifest = @(
    @{ Link = 'skills/sdaf-gate0'; Target = '../sdaf-core/skills/sdaf-gate0' }
    @{ Link = 'skills/sdaf-bootstrap'; Target = '../sdaf-core/skills/sdaf-bootstrap' }
    @{ Link = 'skills/sdaf-upgrade'; Target = '../sdaf-core/skills/sdaf-upgrade' }
    @{ Link = 'skills/sdaf-agent-router'; Target = '../sdaf-core/skills/sdaf-agent-router' }
    @{ Link = 'skills/sdaf-worklog-handoff'; Target = '../sdaf-core/skills/sdaf-worklog-handoff' }
    @{ Link = 'skills/adr-propose'; Target = '../sdaf-core/skills/adr-propose' }
    @{ Link = 'skills/spec-draft-pbi'; Target = '../sdaf-core/skills/spec-draft-pbi' }
    @{ Link = 'agents/specification-agent.md'; Target = '../sdaf-core/agents/specification-agent.md' }
    @{ Link = 'agents/architecture-agent.md'; Target = '../sdaf-core/agents/architecture-agent.md' }
    @{ Link = 'agents/testing-review-agent.md'; Target = '../sdaf-core/agents/testing-review-agent.md' }
    @{ Link = 'agents/product-agent.md'; Target = '../sdaf-core/agents/product-agent.md' }
    @{ Link = 'agents/domain-agent.md'; Target = '../sdaf-core/agents/domain-agent.md' }
    @{ Link = 'agents/application-agent.md'; Target = '../sdaf-core/agents/application-agent.md' }
    @{ Link = 'agents/devops-agent.md'; Target = '../sdaf-core/agents/devops-agent.md' }
    @{ Link = 'agents/review-agent.md'; Target = '../sdaf-core/agents/review-agent.md' }
    @{ Link = 'agents/testing-agent.md'; Target = '../sdaf-core/agents/testing-agent.md' }
    @{ Link = 'prompts/agents/specification-agent.md'; Target = '../../sdaf-core/prompts/agents/specification-agent.md' }
    @{ Link = 'prompts/agents/architecture-agent.md'; Target = '../../sdaf-core/prompts/agents/architecture-agent.md' }
    @{ Link = 'prompts/agents/testing-review-agent.md'; Target = '../../sdaf-core/prompts/agents/testing-review-agent.md' }
    @{ Link = 'prompts/agents/product-agent.md'; Target = '../../sdaf-core/prompts/agents/product-agent.md' }
    @{ Link = 'prompts/agents/domain-agent.md'; Target = '../../sdaf-core/prompts/agents/domain-agent.md' }
    @{ Link = 'prompts/agents/application-agent.md'; Target = '../../sdaf-core/prompts/agents/application-agent.md' }
    @{ Link = 'prompts/agents/devops-agent.md'; Target = '../../sdaf-core/prompts/agents/devops-agent.md' }
    @{ Link = 'prompts/agents/review-agent.md'; Target = '../../sdaf-core/prompts/agents/review-agent.md' }
    @{ Link = 'prompts/agents/testing-agent.md'; Target = '../../sdaf-core/prompts/agents/testing-agent.md' }
    @{ Link = '.cursor/rules/idioma-castellano.mdc'; Target = '../../sdaf-core/.cursor/rules/idioma-castellano.mdc' }
)

$PackManifest = @(
    @{ Link = 'skills/csharp-adr006-slice'; Target = '../sdaf-stack-dotnet/skills/csharp-adr006-slice' }
    @{ Link = 'skills/blazor-bff-slice'; Target = '../sdaf-stack-dotnet/skills/blazor-bff-slice' }
    @{ Link = 'skills/aspire-local-run'; Target = '../sdaf-stack-dotnet/skills/aspire-local-run' }
    @{ Link = 'agents/domain-application-agent.md'; Target = '../sdaf-stack-dotnet/agents/domain-application-agent.md' }
    @{ Link = 'agents/frontend-agent.md'; Target = '../sdaf-stack-dotnet/agents/frontend-agent.md' }
    @{ Link = 'agents/infrastructure-agent.md'; Target = '../sdaf-stack-dotnet/agents/infrastructure-agent.md' }
    @{ Link = 'prompts/agents/domain-application-agent.md'; Target = '../../sdaf-stack-dotnet/prompts/agents/domain-application-agent.md' }
    @{ Link = 'prompts/agents/frontend-agent.md'; Target = '../../sdaf-stack-dotnet/prompts/agents/frontend-agent.md' }
    @{ Link = 'prompts/agents/infrastructure-agent.md'; Target = '../../sdaf-stack-dotnet/prompts/agents/infrastructure-agent.md' }
    @{ Link = '.cursor/rules/coding-standards-csharp.mdc'; Target = '../../sdaf-stack-dotnet/.cursor/rules/coding-standards-csharp.mdc' }
)

Push-Location $RepoRoot
try {
    Test-SubmodulePresent 'sdaf-core'

    $Manifest = [System.Collections.ArrayList]@($CoreManifest)
    $hasPack = Test-Path (Join-Path $RepoRoot 'sdaf-stack-dotnet')
    if ($hasPack) {
        Test-SubmodulePresent 'sdaf-stack-dotnet'
        [void]$Manifest.AddRange($PackManifest)
    }
    else {
        Write-Host 'Pack no presente: omitiendo entradas de sdaf-stack-dotnet (añade el submodule y vuelve a ejecutar).'
    }

    $stats = @{ created = 0; skipped = 0; whatif = 0 }

    foreach ($entry in $Manifest) {
        $result = New-RelativeSymlink -LinkRelative $entry.Link -TargetRelative $entry.Target
        $stats[$result]++
    }

    $skillLinks = $Manifest | Where-Object { $_.Link -like 'skills/*' -and $_.Link -notmatch '\.' }
    foreach ($entry in $skillLinks) {
        $id = Split-Path $entry.Link -Leaf
        $cursorTarget = if ($entry.Target -like '../*') { '../' + $entry.Target } else { $entry.Target }
        $result = New-RelativeSymlink -LinkRelative ".cursor/skills/$id" -TargetRelative $cursorTarget
        $stats[$result]++
    }

    Write-Host ''
    Write-Host "Resumen: creados=$($stats.created) omitidos=$($stats.skipped) whatif=$($stats.whatif)"
    Write-Host 'Siguiente: git status  (enlaces mode 120000 tras commit)'
    exit 0
}
finally {
    Pop-Location
}
