# CLAUDE.md

华北电力大学（NCEPU）硕博学位论文 LyX 模板。须使用 **XeLaTeX** 编译。

## 编译命令

### 硕士论文

```powershell
.claude\scripts\build.ps1
```

编译 `main_master.lyx`，输出 `main_master.pdf`。

### 博士论文

```powershell
.claude\scripts\build-doctor.ps1
```

编译 `main_doctor.lyx`，输出 `main_doctor.pdf`。

## 入口文件

| 文件 | 用途 |
|------|------|
| `main_master.lyx` | 硕士论文主入口（LyX 2.5） |
| `main_doctor.lyx` | 博士论文主入口（LyX 2.5） |
| `NCEPUMaster.cls` | 硕士样式类 |
| `NCEPUMaster.layout` | 硕士 LyX 布局 |
| `NCEPUDoctor.cls` | 博士样式类 |
| `NCEPUDoctor.layout` | 博士 LyX 布局 |

## 项目结构

```
.
├── main_master.lyx              # 硕士入口
├── main_doctor.lyx              # 博士入口
├── NCEPUMaster.cls / .layout    # 硕士样式
├── NCEPUDoctor.cls / .layout    # 博士样式
├── figures/                     # 共用插图
├── figure_for_NCEPU/            # 共用校徽/封面
├── tools/                       # 共用工具（gbt7714 bst/sty）
├── simsun.ttc / simhei.ttf      # 中文字体
│
├── tex/                         # 原始 TeX 备份（仅存档）
│   ├── master/                  # ── 硕士原始 TeX
│   │   ├── NCEPUMaster.cls
│   │   ├── main.tex             # 整合版
│   │   ├── chapters/
│   │   └── others/
│   └── PhD/                     # ── 博士原始 TeX
│       ├── NCEPUDoctor.cls
│       ├── NCEPUDoctor.layout
│       ├── main.tex             # 整合版
│       ├── chapters/
│       └── others/
│
└── .claude/scripts/
    ├── build.ps1                # 编译硕士
    ├── build-doctor.ps1         # 编译博士
    ├── compare.ps1
    └── compare-detail.ps1
```

## 学位信息配置

### 硕士

`NCEPUMaster.cls` 导言区使用 `\mastertype{}` 选择学位类型（二选一）：

| 字段 | 学术硕士 (`academic`) | 专业硕士 (`professional`) |
|------|----------------------|--------------------------|
| 专业/领域 | `\cmajorzh{...}` | `\csubjectzh{...}` |
| 企业导师 | 无 | `\cmentorzh{...}` |
| 学习方式 | 无 | `\cclutivationzh{...}` |

### 博士

`NCEPUDoctor.cls` 导言区使用 `\degreetype{}` 选择学位类型（二选一）：

| 字段 | 学术博士 (`academic`) | 专业博士 (`professional`) |
|------|----------------------|--------------------------|
| 专业/领域 | `\csubjectzh{...}` | `\csubjectzh{...}` / `\cclutivationzh{...}` |
| 企业导师 | 无 | `\cmentorzh{...}` |

共用配置项：密级 `\csecretlevel{public|internal|secret|confidential|topsecret}`、英文标题字号 `\Ltitle{True|False}`、图书分类号 `\cclc{}`/`\cudc{}`。

## LaTeX 环境支持

两个样式类都预定义了以下环境：

- **定理类**：`definition`、`theorem`、`lemma`、`corollary`、`proposition`、`example`、`remark`、`proof`
- **算法类**：`algorithm` + `algorithmic`
- **图表**：`\figcaptioncneng{}`（中英双语图题）、`\bilingualtablecaption{}`（中英双语表题）、`subfigure` 子图（硕士用 `subfigure` 包 + ERT，博士用 LyX 原生 `subfloat`）
- **长表格**：`longtable` 环境（续表标记 `\thenexttable`），列宽用 `C{比例}` 自定义

## 核心约束

- **`figure_for_NCEPU/`** 为学校标志和封面图片，不可删除或替换
- **`tools/gbt7714-numerical.bst`** 为国标参考文献样式文件
- 模板仅支持 XeLaTeX（`xelatex`），不支持 pdflatex
- 中文排版依赖 `simsun.ttc`（宋体）和 `simhei.ttf`（黑体）
