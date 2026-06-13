---
name: build
description: 编译 main.lyx（或 main.tex）为 PDF，自动清理临时文件，并与基准文件 main_ref.pdf 逐页对比（表格汇总 + diff_report.md 详细报告）。当用户说"编译"时触发。
---

# /build — 编译论文

执行 `build.ps1` 一键完成编译 → 清理 → PDF 对比：

```powershell
.claude\scripts\build.ps1
```

## 源文件自动识别

| 存在文件 | 编译方式 |
|:---------|:---------|
| `main.lyx` | `lyx --export pdf4`（LyX 自动调用 XeLaTeX + BibTeX） |
| `main.tex`（无 .lyx） | xelatex + bibtex 经典 4 步编译 |

## 输出

1. **终端表格** — 逐页对比（图像/文本/差异说明）
2. **详细报告** — `diff_report.md`（含 ref vs new 逐行对比表）

## 注意事项

- 编译失败时可查看 `build.log` 定位问题
