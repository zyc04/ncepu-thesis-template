$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
Set-Location $ProjectRoot

$RefPdf = "main_ref.pdf"
$NewPdf = "main.pdf"

if (-not (Test-Path $RefPdf)) {
    Write-Host "错误：未找到基准文件 main_ref.pdf" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $NewPdf)) {
    Write-Host "错误：未找到 main.pdf，请先编译" -ForegroundColor Red
    exit 1
}

Write-Host "=== 对比 main.pdf 与基准文件 main_ref.pdf ===" -ForegroundColor Cyan
Write-Host ""

$compareResult = compare_pdf --pdf $NewPdf --pdf $RefPdf 2>&1
$compareResult | ForEach-Object { Write-Host $_ }

Write-Host ""

$diffPages = $compareResult | Select-String "differs|different|not equal"
if ($diffPages) {
    Write-Host "!!! 与基准文件存在差异 !!!" -ForegroundColor Red
    $diffPages | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
}
else {
    Write-Host "✓ 与基准文件完全一致（无变化）" -ForegroundColor Green
}
