# Tim platform 1C:Enterprise da cai tren may.
#   find-platform.ps1 [-Want 8.3.25] [-List]
# Khong co -List: in duong dan Designer (1cv8.exe / 1cv8t.exe) cua ban MOI NHAT khop -Want
#   (-Want de trong = moi ban; -Want 8.3.25 = moi ban 8.3.25.x; -Want 8.3.25.1445 = dung ban do).
# Co -List: in danh sach moi ban tim thay.
param([string]$Want = '', [switch]$List)
$roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA + '\Programs') | Where-Object { $_ } | Select-Object -Unique
$found = foreach ($r in $roots) {
  foreach ($d in @('1cv8', '1cv8t')) {
    $exe = if ($d -eq '1cv8t') { '1cv8t.exe' } else { '1cv8.exe' }
    Get-ChildItem -Directory -Path (Join-Path $r $d) -ErrorAction SilentlyContinue |
      Where-Object { $_.Name -match '^\d+\.\d+\.\d+\.\d+$' } |
      ForEach-Object {
        $p = Join-Path $_.FullName ('bin\' + $exe)
        if (Test-Path $p) { [pscustomobject]@{ V = [version]$_.Name; Training = ($d -eq '1cv8t'); P = $p } }
      }
  }
}
$Want = $Want.Trim()
if ($Want) { $found = $found | Where-Object { ($_.V.ToString() + '.').StartsWith($Want + '.') } }
$found = $found | Sort-Object V -Descending
if ($List) {
  if (-not $found) { Write-Output '        - khong co ban nao. Platform co the cai o noi khac: dien duong dan day du vao V8_PATH.' }
  foreach ($f in $found) { $t = if ($f.Training) { ' (training)' } else { '' }; Write-Output ('        ' + $f.V + $t + '   ->  ' + $f.P) }
} elseif ($found) {
  Write-Output @($found)[0].P
}
