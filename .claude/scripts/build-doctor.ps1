$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
Set-Location $ProjectRoot

$LogFile = Join-Path $ProjectRoot "build_doctor.log"
$PdfFile = Join-Path $ProjectRoot "main_doctor.pdf"

Write-Host "=== 编译博士论文: main_doctor.lyx ===" -ForegroundColor Cyan

try {
    Write-Host "[1/1] lyx --export pdf4..." -ForegroundColor Yellow -NoNewline
    lyx --export pdf4 main_doctor.lyx *>&1 | Out-File -FilePath $LogFile -Encoding utf8
    if (-not (Test-Path $PdfFile)) { throw "lyx 编译失败（main_doctor.pdf 未生成）" }
    Write-Host " OK" -ForegroundColor Green

    Write-Host "清除临时文件..." -ForegroundColor Yellow -NoNewline
    Remove-Item $LogFile -ErrorAction SilentlyContinue
    Write-Host " OK" -ForegroundColor Green

    Write-Host "=== 编译完成: main_doctor.pdf ===" -ForegroundColor Green
}
catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host "编译失败: $_" -ForegroundColor Red
    Write-Host "详细日志: $LogFile" -ForegroundColor Yellow
    exit 1
}
