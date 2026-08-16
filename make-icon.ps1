$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$dir = 'C:\Users\luo\OneDrive\Desktop\DeepSeek Harness'
$svgPath = Join-Path $dir 'whale-256.svg'
$icoPath = Join-Path $dir 'icon.ico'
$pngPath = Join-Path $dir 'icon-preview.png'

# Official DeepSeek blue.
$blue = [System.Drawing.Color]::FromArgb(255, 0x4D, 0x6B, 0xFE)

$svg = [System.IO.File]::ReadAllText($svgPath)
$d = [regex]::Match($svg, '<path[^>]*\sd="([^"]+)"').Groups[1].Value
$spaced = $d -replace '([A-Za-z])', ' $1 '
$tokens = @($spaced -split '[\s,]+' | Where-Object { $_ -ne '' })

# SVG path parser for M / C / Z (the whale logo uses only these).
# Coordinates are in a 50x50 viewBox; scale to the target frame size.
function New-WhalePath([double]$scale) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $cmd = $null
    $pending = New-Object System.Collections.Generic.List[double]
    $curX = 0.0
    $curY = 0.0
    foreach ($tok in $tokens) {
        if ($tok -match '^[A-Za-z]$') {
            $cmd = $tok
            continue
        }
        $v = [double]$tok * $scale
        $pending.Add($v)
        switch ($cmd) {
            'M' {
                if ($pending.Count -ge 2) {
                    $x = $pending[0]; $y = $pending[1]
                    $pending.RemoveRange(0, 2)
                    # Every M starts a fresh subpath (the logo has no implicit
                    # lineto pairs after M, only explicit C segments).
                    $path.StartFigure()
                    $curX = $x; $curY = $y
                }
            }
            'C' {
                if ($pending.Count -ge 6) {
                    $path.AddBezier(
                        [single]$curX, [single]$curY,
                        [single]$pending[0], [single]$pending[1],
                        [single]$pending[2], [single]$pending[3],
                        [single]$pending[4], [single]$pending[5])
                    $curX = $pending[4]; $curY = $pending[5]
                    $pending.RemoveRange(0, 6)
                }
            }
            'Z' {
                $path.CloseFigure()
            }
        }
    }
    return $path
}

$sizes = @(16, 24, 32, 48, 64, 128, 256)
$frames = @()
foreach ($size in $sizes) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)
    $path = New-WhalePath ($size / 50.0)
    $brush = New-Object System.Drawing.SolidBrush($blue)
    $g.FillPath($brush, $path)
    $brush.Dispose()
    $path.Dispose()
    $g.Dispose()
    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    if ($size -eq 256) { $bmp.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png) }
    $bmp.Dispose()
    $frames += ,($ms.ToArray())
}

$out = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($out)
$bw.Write([uint16]0)
$bw.Write([uint16]1)
$bw.Write([uint16]$frames.Count)
$offset = 6 + 16 * $frames.Count
for ($i = 0; $i -lt $frames.Count; $i++) {
    $s = $sizes[$i]
    $data = $frames[$i]
    if ($s -ge 256) { $w = 0 } else { $w = $s }
    $bw.Write([byte]$w)
    $bw.Write([byte]$w)
    $bw.Write([byte]0)
    $bw.Write([byte]0)
    $bw.Write([uint16]1)
    $bw.Write([uint16]32)
    $bw.Write([uint32]$data.Length)
    $bw.Write([uint32]$offset)
    $offset += $data.Length
}
foreach ($f in $frames) { $bw.Write([byte[]]$f) }
$bw.Flush()
[System.IO.File]::WriteAllBytes($icoPath, $out.ToArray())
Write-Host ("whale icon.ico written: {0} bytes" -f (Get-Item $icoPath).Length)
