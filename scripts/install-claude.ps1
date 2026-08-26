<#
.SYNOPSIS
  Instala las skills de Claude en Claude Code copiando cada carpeta e
  inyectando shared/interop-notion.md en su references/ (igual que package.sh,
  pero sin empaquetar en .skill: Claude Code lee las carpetas directamente).

.DESCRIPTION
  Claude Code descubre skills como carpetas con SKILL.md en:
    - personal: ~/.claude/skills/<nombre>/
    - por proyecto: <raiz-del-proyecto>/.claude/skills/<nombre>/
  Este script instala solo las skills pensadas para Claude (las de Kiro
  -qa-discovery, qa-generator- se omiten). La copia dentro de cada skill de
  interop-notion.md es un artefacto: la fuente unica es shared/interop-notion.md.

.PARAMETER Dest
  Carpeta de skills destino. Por defecto la personal (~/.claude/skills).
  Para instalar por proyecto: -Dest "C:\ruta\al\proyecto\.claude\skills".

.EXAMPLE
  ./scripts/install-claude.ps1
  ./scripts/install-claude.ps1 -Dest "C:\repos\mi-proyecto\.claude\skills"
#>
[CmdletBinding()]
param(
  [string]$Dest = (Join-Path $HOME ".claude\skills")
)

$ErrorActionPreference = "Stop"

$root   = Split-Path -Parent $PSScriptRoot
$shared = Join-Path $root "shared\interop-notion.md"

# Skills para Claude (las de Kiro corren en su propio runtime y se omiten).
$claudeSkills = @(
  "derivar-proyecto",
  "sdd-harness-notion",
  "project-onboarding",
  "documentation-master",
  "project-deck",
  "project-doc",
  "project-audit",
  "git-workflow"
)

if (-not (Test-Path $shared)) {
  throw "No se encontro el contrato compartido: $shared"
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Write-Host "Destino: $Dest`n"

foreach ($s in $claudeSkills) {
  $from = Join-Path $root "skills\$s"
  if (-not (Test-Path (Join-Path $from "SKILL.md"))) {
    Write-Host "omitir: $s (sin SKILL.md)"
    continue
  }
  $to = Join-Path $Dest $s
  if (Test-Path $to) { Remove-Item $to -Recurse -Force }
  Copy-Item $from $to -Recurse -Force
  New-Item -ItemType Directory -Force -Path (Join-Path $to "references") | Out-Null
  Copy-Item $shared (Join-Path $to "references\interop-notion.md") -Force
  Write-Host "ok:     $s"
}

Write-Host "`nListo. En Claude Code corre /skills para verificar la lista."
