$port = 3080
$conns = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
if (-not $conns) {
    Write-Host 'DeepSeek Harness 没有在运行（端口 3080 无监听）。'
    exit 0
}

$stopped = @()
$skipped = @()
foreach ($procId in ($conns.OwningProcess | Select-Object -Unique)) {
    $p = Get-CimInstance Win32_Process -Filter "ProcessId=$procId" -ErrorAction SilentlyContinue
    if ($p -and $p.CommandLine -match 'dsh') {
        taskkill /f /t /pid $procId 2>&1 | Out-Null
        $stopped += $procId
    } else {
        $skipped += "$procId ($($p.Name))"
    }
}

if ($stopped.Count -gt 0) { Write-Host "已停止 DeepSeek Harness（PID: $($stopped -join ', ')）。" }
if ($skipped.Count -gt 0) { Write-Host "端口 3080 被其他程序占用，未停止: $($skipped -join ', ')。" }
if ($stopped.Count -eq 0) { Write-Host '没有发现 DeepSeek Harness 进程。' }
