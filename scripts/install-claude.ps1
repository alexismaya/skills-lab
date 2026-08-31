<#
.SYNOPSIS
  Instala la suite en Claude Code copiando cada carpeta e inyectando
  shared/interop-notion.md en su references/ (igual que package.sh, pero sin
  empaquetar en .skill: Claude Code lee las carpetas directamente).

.DESCRIPTION
  Claude Code descubre skills como carpetas con SKILL.md en:
    - personal: ~/.claude/skills/<nombre>/
    - por proyecto: <raiz-del-proyecto>/.claude/skills/<nombre>/

  La lista se deriva de skills/: toda carpeta con SKILL.md se instala. No hay
  lista fija que mantener, y es deliberado -una lista fija se desincroniza en
  silencio por dos lados: una skill nueva no llega a ningun runtime, y una skill
  ya instalada que quede fuera de la lista conserva el contrato viejo mientras
  las demas avanzan-. Todas las skills son portables entre runtimes; ver la
  tabla de equivalencias en shared/interop-notion.md.

  La copia dentro de cada skill de interop-notion.md es un artefacto: la fuente
  unica es shared/interop-notion.md.

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

if (-not (Test-Path $shared)) {
  throw "No se encontro el contrato compartido: $shared"
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Write-Host "Destino: $Dest`n"

$n = 0
foreach ($dir in Get-ChildItem -Path (Join-Path $root "skills") -Directory) {
  $s    = $dir.Name
  $from = $dir.FullName
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
  $n++
}

Write-Host "`n$n skills instaladas. En Claude Code corre /skills para verificar la lista."
