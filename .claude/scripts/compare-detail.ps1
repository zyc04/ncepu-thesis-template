param(
    [Parameter(Mandatory)] [string] $NewPdf,
    [Parameter(Mandatory)] [string] $RefPdf
)

$ErrorActionPreference = "Stop"

# ── 图像对比 ──
$imageResult = compare_pdf --pdf $NewPdf --pdf $RefPdf 2>&1
$imageDiffSet = @{}
foreach ($line in $imageResult) {
    if ($line -match "All images on Page (\d+) are equal") { $imageDiffSet[[int]$matches[1]] = $false }
    if ($line -match "Some images on Page (\d+) are not equal") { $imageDiffSet[[int]$matches[1]] = $true }
}

$totalPages = ($imageDiffSet.Keys | Measure-Object).Count
if ($totalPages -eq 0) { $totalPages = 21 }

if (-not (Get-Command pdftotext -ErrorAction SilentlyContinue)) { Write-Host "（需安装 pdftotext 才能显示文本差异）"; return }

$tmpKey = Get-Random
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..\..")

# ── 收集每页数据 ──
$pageData = @()
foreach ($p in 1..$totalPages) {
    $newFile = "$env:TEMP\pdfdiff_${tmpKey}_n_$p.txt"
    $refFile = "$env:TEMP\pdfdiff_${tmpKey}_r_$p.txt"
    pdftotext -layout -f $p -l $p $NewPdf $newFile 2>$null
    pdftotext -layout -f $p -l $p $RefPdf $refFile 2>$null

    $newLines = Get-Content $newFile -ErrorAction SilentlyContinue | Where-Object { $_.Trim() -ne "" }
    $refLines = Get-Content $refFile -ErrorAction SilentlyContinue | Where-Object { $_.Trim() -ne "" }
    $newText = $newLines -join "`n"
    $refText = $refLines -join "`n"
    Remove-Item $newFile, $refFile -Force -ErrorAction SilentlyContinue

    $imgDiff = if ($imageDiffSet.ContainsKey($p)) { $imageDiffSet[$p] } else { $false }
    $txtDiff = ($newText -ne $refText)

    $pageData += [PSCustomObject]@{
        Page     = $p
        ImgDiff  = $imgDiff
        TxtDiff  = $txtDiff
        NewLines = $newLines
        RefLines = $refLines
    }
}

# ── 终端输出（表格） ──
Write-Host ""
Write-Host "=== PDF 逐页差异对比 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host ("  {0,-5}  {1,-6}  {2,-6}  {3}" -f "页码", "图像", "文本", "差异说明")
Write-Host ("  {0,-5}  {1,-6}  {2,-6}  {3}" -f "----", "----", "----", "----")

$sameCount = 0; $diffCount = 0; $mdRows = @()

foreach ($d in $pageData) {
    $imgStr = if ($d.ImgDiff) { " 不同" } else { " 相同" }
    $txtStr = if ($d.TxtDiff) { " 不同" } else { " 相同" }
    $desc = @()

    if ($d.ImgDiff -and -not $d.TxtDiff) { $desc += "渲染精度差异" }

    if ($d.TxtDiff) {
        $dl = Compare-Object $d.RefLines $d.NewLines | Where-Object { $_.InputObject.Trim() -ne '' }
        $cnt = ($dl | Measure-Object).Count
        $desc += "$cnt 处文字差异"
        $samples = @()
        foreach ($dl in ($dl | Where-Object { $_.InputObject.Trim() -match '[一-鿿a-zA-Z0-9]' } | Select-Object -First 2)) {
            $s = $dl.InputObject.Trim(); if ($s.Length -gt 16) { $s = $s.Substring(0, 14) + "…" }; $samples += $s
        }
        if ($samples) { $desc += "如「$($samples -join '」「')」" }
    }

    $descStr = $desc -join '；'
    Write-Host ("  {0,-5}  {1,-6}  {2,-6}  {3}" -f "P$($d.Page)", $imgStr, $txtStr, $descStr) -ForegroundColor $(if ($d.ImgDiff -or $d.TxtDiff) { 'Yellow' } else { 'Green' })

    if ($d.ImgDiff -or $d.TxtDiff) { $diffCount++ } else { $sameCount++ }
}

Write-Host ""
Write-Host ("相同: {0} 页 | 不同: {1} 页" -f $sameCount, $diffCount)

# ── 写入 Markdown 详细报告 ──
$mdPath = Join-Path $ProjectRoot "diff_report.md"
$mdLines = @()

$mdLines += "# PDF 差异报告"
$mdLines += ""
$mdLines += "| 对比文件 | 路径 |"
$mdLines += "|---------|------|"
$mdLines += "| 新文件 | $NewPdf |"
$mdLines += "| 基准文件 | $RefPdf |"
$mdLines += ""
$mdLines += "| 相同页 | 不同页 |"
$mdLines += "|--------|--------|"
$mdLines += "| $sameCount | $diffCount |"
$mdLines += ""

$mdLines += "## 逐页差异明细"
$mdLines += ""

foreach ($d in $pageData) {
    if (-not $d.ImgDiff -and -not $d.TxtDiff) { continue }
    $mdLines += "### P$($d.Page)"
    $mdLines += ""

    if ($d.ImgDiff -and -not $d.TxtDiff) {
        $mdLines += "**图像不同**，文本内容一致。"
        $mdLines += ""
        continue
    }
    if (-not $d.TxtDiff) { continue }

    $diffs = Compare-Object $d.RefLines $d.NewLines | Where-Object { $_.InputObject.Trim() -ne '' }
    # 过滤页码行
    $diffs = $diffs | Where-Object { $_.InputObject.Trim() -notmatch '^\d+$' -and $_.InputObject.Trim() -notmatch '^[IVXLCDM]+$' }

    $mdLines += "**文本差异**（$($diffs.Count) 处）"
    $mdLines += ""
    $mdLines += "| 基准 (ref) | 新文件 (new) |"
    $mdLines += "|-----------|-------------|"

    # 分组成对显示
    $added = @(); $removed = @()
    foreach ($line in $diffs) {
        if ($line.SideIndicator -eq '=>') { $added += $line.InputObject.Trim() }
        else { $removed += $line.InputObject.Trim() }
    }
    $maxCount = [Math]::Max($added.Count, $removed.Count)
    $hasContent = $false
    for ($i = 0; $i -lt $maxCount; $i++) {
        $r = if ($i -lt $removed.Count) { $removed[$i] } else { "" }
        $a = if ($i -lt $added.Count) { $added[$i] } else { "" }
        if ($r -ne $a) { $mdLines += "| $r | $a |"; $hasContent = $true }
    }
    if (-not $hasContent) { $mdLines += "（仅有空白或页码差异）" }
    $mdLines += ""
}

$mdLines | Out-File -FilePath $mdPath -Encoding utf8
Write-Host ""
Write-Host ("详细报告已保存: diff_report.md" -f $mdPath) -ForegroundColor Cyan
