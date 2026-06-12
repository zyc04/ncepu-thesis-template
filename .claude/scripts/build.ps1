$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
Set-Location $ProjectRoot

$LogFile = Join-Path $ProjectRoot "build.log"
$RefPdf = Join-Path $ProjectRoot "main_ref.pdf"

Write-Host "=== 编译 main.tex ===" -ForegroundColor Cyan

try {
    Write-Host "[1/4] xelatex (第一遍)..." -ForegroundColor Yellow -NoNewline
    xelatex -interaction=nonstopmode main.tex *>&1 | Out-File -FilePath $LogFile -Encoding utf8
    if ($LASTEXITCODE -ne 0) { throw "xelatex 第一遍失败" }
    Write-Host " OK" -ForegroundColor Green

    Write-Host "[2/4] bibtex..." -ForegroundColor Yellow -NoNewline
    bibtex main *>&1 | Out-File -FilePath $LogFile -Encoding utf8 -Append
    if ($LASTEXITCODE -ne 0) { throw "bibtex 失败" }
    Write-Host " OK" -ForegroundColor Green

    Write-Host "[3/4] xelatex (第二遍)..." -ForegroundColor Yellow -NoNewline
    xelatex -interaction=nonstopmode main.tex *>&1 | Out-File -FilePath $LogFile -Encoding utf8 -Append
    if ($LASTEXITCODE -ne 0) { throw "xelatex 第二遍失败" }
    Write-Host " OK" -ForegroundColor Green

    Write-Host "[4/4] xelatex (第三遍)..." -ForegroundColor Yellow -NoNewline
    xelatex -interaction=nonstopmode main.tex *>&1 | Out-File -FilePath $LogFile -Encoding utf8 -Append
    if ($LASTEXITCODE -ne 0) { throw "xelatex 第三遍失败" }
    Write-Host " OK" -ForegroundColor Green

    if (-not (Test-Path "main.pdf")) {
        throw "main.pdf 未生成"
    }

    Write-Host "清除临时文件..." -ForegroundColor Yellow -NoNewline
    Get-ChildItem "." -Recurse -Include *.aux,*.thm,*.out,*.toc,*.lof,*.lot,*.bbl,*.blg,*.log,*.fls,*.fdb_latexmk,*.synctex.gz -ErrorAction SilentlyContinue | Remove-Item -Force
    Remove-Item $LogFile -ErrorAction SilentlyContinue
    Write-Host " OK" -ForegroundColor Green

    Write-Host "=== 编译完成: main.pdf ===" -ForegroundColor Green
    Write-Host ""

    # 与基准文件 main_ref.pdf 对比
    if (Test-Path $RefPdf) {
        Write-Host "=== 与基准文件 main_ref.pdf 对比 ===" -ForegroundColor Cyan
        Write-Host ""

        $compareResult = compare_pdf --pdf "main.pdf" --pdf "main_ref.pdf" 2>&1
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
