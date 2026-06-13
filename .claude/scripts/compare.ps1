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

# 详细对比表格（含图像 + 文本）
& "$ScriptDir\compare-detail.ps1" -NewPdf $NewPdf -RefPdf $RefPdf
