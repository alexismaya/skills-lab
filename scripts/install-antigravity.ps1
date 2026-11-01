<#
.SYNOPSIS
  Instala la suite en la CLI de Antigravity (agy) copiando cada carpeta e
  inyectando shared/interop-notion.md en su references/ (igual que
  install-claude.ps1 e install-kiro.ps1, con otro destino: Antigravity tambien
  lee las carpetas directamente).

.DESCRIPTION
  Antigravity descubre skills como carpetas con SKILL.md en:
    - global (maquina): ~/.gemini/config/skills/<nombre>/
    - por proyecto: <raiz-del-repo>/.agents/skills/<nombre>/
      (tambien acepta .agent/, _agents/, _agent/)

  Precedencia, de mayor a menor: workspace .agents/ > entradas declaradas en
  skills.json del workspace > global ~/.gemini/config/ > skills builtin >
  entradas declaradas en el skills.json global. Instalar en el destino global
  deja la suite disponible en todos los proyectos de la maquina, y un proyecto
  puede seguir sobrescribiendo una skill concreta con su propia copia en
  .agents/skills/.

  NO instalar en ~/.gemini/antigravity-cli/builtin/skills/: ese arbol lo maneja
  la CLI, esta sellado por checksum y se reescribe en cada actualizacion. Lo que
  se ponga ahi desaparece sin aviso.

  La lista se deriva de skills/: toda carpeta con SKILL.md se instala. Ver la
  nota de install-claude.ps1 sobre por que no hay lista fija.

  La copia dentro de cada skill de interop-notion.md es un artefacto: la fuente
  unica es shared/interop-notion.md.

.PARAMETER Dest
  Carpeta de skills destino. Por defecto la global (~/.gemini/config/skills).
  Para instalar por proyecto: -Dest "C:\ruta\al\proyecto\.agents\skills".

.EXAMPLE
  ./scripts/install-antigravity.ps1
  ./scripts/install-antigravity.ps1 -Dest "C:\repos\mi-proyecto\.agents\skills"
#>
[CmdletBinding()]
param(
  [string]$Dest = (Join-Path $HOME ".gemini\config\skills")
)

$ErrorActionPreference = "Stop"

$root   = Split-Path -Parent $PSScriptRoot
$shared = Join-Path $root "shared\interop-notion.md"

if (-not (Test-Path $shared)) {
  throw "No se encontro el contrato compartido: $shared"
}

if ($Dest.Replace([char]92, '/') -like '*/antigravity-cli/builtin*') {
  throw "Destino invalido: $Dest`nEl arbol builtin de la CLI esta sellado por checksum y se reescribe al actualizar. Usa el destino global (~/.gemini/config/skills) o el de un proyecto (.agents/skills)."
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

Write-Host "`n$n skills instaladas en Antigravity."
Write-Host "Reinicia agy para que las descubra; /help lista los comandos de la sesion."
