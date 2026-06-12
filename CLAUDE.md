# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

华北电力大学（NCEPU）硕士学位论文 LaTeX 模板。文档类 `NCEPUMaster.cls` 基于 `book` 类定制，须使用 **XeLaTeX** 编译。

## 编译命令

使用 `build.ps1` 一键编译并自动清理临时文件（或说"编译tex"/`/build` 触发 skill）：

```powershell
.claude\scripts\build.ps1
```

### 对比 PDF

编译后自动与 `main_ref.pdf` 对比。也可单独执行（说"比较pdf"或 `/compare`）：

```powershell
.claude\scripts\compare.ps1
```

> `main_ref.pdf` 是项目根目录下的只读基准文件，用于追踪每次编译的输出变化。

手动分步编译（如需排查问题）：

```powershell
xelatex -interaction=nonstopmode main.tex
bibtex main
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
```

## 入口文件

| 文件 | 用途 |
|------|------|
| `main.tex` | **主入口**，通过 `\include{}` 分文件组织各章节 |
| `main_all.tex` | **合并版**，所有章节内联在一个文件中（可作为后备） |

## 项目结构

```
.
├── main.tex                # 主入口（\include{} 分文件）
├── main_all.tex            # 合并版后备
├── main_ref.pdf            # 只读基准文件（用于编译后对比）
├── chapters/               # 正文章节
│   ├── chapter1.tex        # 绪论 + 插图/子图示例
│   ├── chapter2.tex        # 文献综述
│   ├── chapter3.tex        # 正文 + 算法/定理环境示例
│   ├── chapter4.tex        # FLUENT 仿真 + 子图排版
│   ├── chapter5.tex        # 实验 + 表格/longtable 示例
│   └── chapter6.tex        # 结论 + 参考文献引用示例
├── others/                 # 前/后置部分
│   ├── abstractzh.tex      # 中文摘要
│   ├── abstracten.tex      # 英文摘要
│   ├── nomenclature.tex    # 符号表
│   ├── ref.tex             # 参考文献（\bibliography{} 调用）
│   ├── reference.bib       # BibTeX 文献数据库
│   ├── appendix.tex        # 附录
│   ├── output.tex          # 攻读学位期间成果
│   └── thanks.tex          # 致谢
├── figures/                # 正文插图
├── figure_for_NCEPU/       # 封面/学校标志（勿修改）
├── tools/
│   ├── gbt7714-numerical.bst  # 国标参考文献样式
│   └── gbt7714.sty
├── NCEPUMaster.cls         # 硕士论文样式类（勿修改）
├── simhei.ttf              # 黑体（排版用）
└── simsun.ttc              # 宋体（排版用）
```

## 学位信息配置

`main.tex` 导言区使用 `\mastertype{}` 选择学位类型（二选一）：

| 字段 | 学术硕士 (`academic`) | 专业硕士 (`professional`) |
|------|----------------------|--------------------------|
| 专业/领域 | `\cmajorzh{...}` | `\csubjectzh{...}` |
| 企业导师 | 无 | `\cmentorzh{...}` |
| 学习方式 | 无 | `\cclutivationzh{...}` |

其他配置项：密级 `\csecretlevel{public\|internal\|secret\|confidential\|topsecret}`、英文标题字号 `\Ltitle{True\|False}`、图书分类号 `\cclc{}`/`\cudc{}`。

## LaTeX 环境支持

`NCEPUMaster.cls` 预定义了以下环境（用法见 `chapter3.tex`）：

- **定理类**：`definition`、`theorem`、`lemma`、`corollary`、`proposition`、`example`、`remark`、`proof`
- **算法类**：`algorithm` + `algorithmic`（`\algref{alg:label}` 引用）
- **图表**：`\figcaptioncneng{}`（中英双语图题）、`\bilingualtablecaption{}`（中英双语表题）、`subfigure` 子图排版
- **长表格**：`longtable` 环境（跨页表格，续表标记 `\thenexttable`），列宽用 `C{比例}` 自定义

## 核心约束

- **`NCEPUMaster.cls`** 不可修改——论文格式规范完全由此文件定义（如需改格式，更新后要在不同章节测试）
- **`figure_for_NCEPU/`** 为学校标志和封面图片，不可删除或替换
- **`tools/gbt7714-numerical.bst`** 为国标参考文献样式文件，仅引用格式更新时才修改
- 模板仅支持 XeLaTeX（`xelatex`），不支持 pdflatex
- 中文排版依赖 `simsun.ttc`（宋体）和 `simhei.ttf`（黑体），已包含在仓库中
