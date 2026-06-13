$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
Set-Location $ProjectRoot

$LogFile = Join-Path $ProjectRoot "build.log"
$RefPdf = Join-Path $ProjectRoot "main_ref.pdf"
$PdfFile = Join-Path $ProjectRoot "main.pdf"

# 判断源文件类型
if (Test-Path "main.lyx") {
    $SourceType = "lyx"
    $SourceFile = "main.lyx"
}
elseif (Test-Path "main.tex") {
    $SourceType = "tex"
    $SourceFile = "main.tex"
}
else {
    Write-Host "错误：未找到 main.lyx 或 main.tex" -ForegroundColor Red
    exit 1
}

Write-Host "=== 编译 $SourceFile ===" -ForegroundColor Cyan

try {
    if ($SourceType -eq "lyx") {
        Write-Host "[1/1] lyx --export pdf4..." -ForegroundColor Yellow -NoNewline
        lyx --export pdf4 $SourceFile *>&1 | Out-File -FilePath $LogFile -Encoding utf8
        if (-not (Test-Path $PdfFile)) { throw "lyx 编译失败（main.pdf 未生成）" }
        Write-Host " OK" -ForegroundColor Green
    }
    else {
        Write-Host "[1/4] xelatex (第一遍)..." -ForegroundColor Yellow -NoNewline
        xelatex -interaction=nonstopmode $SourceFile *>&1 | Out-File -FilePath $LogFile -Encoding utf8
        if ($LASTEXITCODE -ne 0) { throw "xelatex 第一遍失败" }
        Write-Host " OK" -ForegroundColor Green

        Write-Host "[2/4] bibtex..." -ForegroundColor Yellow -NoNewline
        bibtex main *>&1 | Out-File -FilePath $LogFile -Encoding utf8 -Append
        if ($LASTEXITCODE -ne 0) { throw "bibtex 失败" }
        Write-Host " OK" -ForegroundColor Green

        Write-Host "[3/4] xelatex (第二遍)..." -ForegroundColor Yellow -NoNewline
        xelatex -interaction=nonstopmode $SourceFile *>&1 | Out-File -FilePath $LogFile -Encoding utf8 -Append
        if ($LASTEXITCODE -ne 0) { throw "xelatex 第二遍失败" }
        Write-Host " OK" -ForegroundColor Green

        Write-Host "[4/4] xelatex (第三遍)..." -ForegroundColor Yellow -NoNewline
        xelatex -interaction=nonstopmode $SourceFile *>&1 | Out-File -FilePath $LogFile -Encoding utf8 -Append
        if ($LASTEXITCODE -ne 0) { throw "xelatex 第三遍失败" }
        Write-Host " OK" -ForegroundColor Green

        if (-not (Test-Path $PdfFile)) { throw "xelatex 编译失败（main.pdf 未生成）" }
    }

    Write-Host "清除临时文件..." -ForegroundColor Yellow -NoNewline
    Get-ChildItem "." -Recurse -Include *.aux,*.log,*.out,*.toc,*.lof,*.lot,*.bbl,*.blg,*.fls,*.fdb_latexmk,*.synctex.gz -ErrorAction SilentlyContinue | Remove-Item -Force
    Remove-Item $LogFile -ErrorAction SilentlyContinue
    Write-Host " OK" -ForegroundColor Green

    Write-Host "=== 编译完成: main.pdf ===" -ForegroundColor Green
    Write-Host ""

    if (Test-Path $RefPdf) {
        & "$ScriptDir\compare-detail.ps1" -NewPdf "main.pdf" -RefPdf $RefPdf
    }
    else {
        Write-Host "（跳过对比：未找到 main_ref.pdf 基准文件）" -ForegroundColor Yellow
    }
}
catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host "编译失败: $_" -ForegroundColor Red
    Write-Host "详细日志: $LogFile" -ForegroundColor Yellow
    exit 1
}
