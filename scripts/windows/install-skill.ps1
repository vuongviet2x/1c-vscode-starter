# Cai skill tu file ZIP vao <du-an>\.claude\skills\<ten-skill>\
param([Parameter(Mandatory = $true)][string]$Zip)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$skillsDir = Join-Path $root '.claude\skills'
if (-not (Test-Path $Zip)) { Write-Host "[LOI] Khong thay file: $Zip"; exit 1 }
if ((Split-Path $Zip -Leaf) -match 'gemini') { Write-Host '[LOI] Day la ban skill cho Gemini. Trong VS Code hay dung file 1c-dev-mentor-student-claude-gpt.zip'; exit 1 }

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("skill-" + [guid]::NewGuid())
Expand-Archive -Path $Zip -DestinationPath $tmp -Force
$skillMd = Get-ChildItem -Path $tmp -Filter 'SKILL.md' -Recurse | Select-Object -First 1
if (-not $skillMd) { Write-Host '[LOI] File ZIP khong chua SKILL.md.'; exit 1 }

$src = $skillMd.Directory.FullName
$name = (Select-String -Encoding UTF8 -Path $skillMd.FullName -Pattern '^name:\s*"?([^"]+)"?\s*$' | Select-Object -First 1).Matches.Groups[1].Value
if (-not $name) { $name = $skillMd.Directory.Name }
$dest = Join-Path $skillsDir $name
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
Copy-Item $src $dest -Recurse
Remove-Item $tmp -Recurse -Force

$ver = (Select-String -Encoding UTF8 -Path (Join-Path $dest 'SKILL.md') -Pattern 'Phi.n b.n ([0-9.]+[-a-z]*)' | Select-Object -First 1).Matches.Groups[1].Value
Write-Host "[OK] Da cai skill '$name' $ver vao .claude\skills\$name"
Write-Host '     Mo lai panel Claude Code (hoac go /reload-skills) de skill co hieu luc.'
