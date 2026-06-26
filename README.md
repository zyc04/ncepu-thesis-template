# NCEPU 硕博学位论文模板

华北电力大学（NCEPU）硕博学位论文 LaTeX/LyX 模板，支持 **硕士** 和 **博士** 两套论文格式。

## 快速开始

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

## 文件说明

| 文件 | 说明 |
|:-----|:-----|
| `main_master.lyx` | 硕士论文（LyX 2.5） |
| `main_doctor.lyx` | 博士论文（LyX 2.5） |
| `NCEPUMaster.cls` / `.layout` | 硕士样式 |
| `NCEPUDoctor.cls` / `.layout` | 博士样式 |
| `tex/master/` | 硕士原始 TeX 备份 |
| `tex/PhD/` | 博士原始 TeX 备份 |
| `figures/` | 共用插图 |
| `figure_for_NCEPU/` | 学校标志（勿动） |
| `tools/` | 文献样式（gbt7714） |
| `simhei.ttf` / `simsun.ttc` | 中文字体 |

## 学位类型

### 硕士

在 `main_master.lyx` 开头选择 `academic`（学硕）或 `professional`（专硕）。

### 博士

在 `main_doctor.lyx` 开头选择 `academic`（学术博士）或 `professional`（专业博士）。

## 依赖

- LyX 2.5 +
- TeX Live 2020 +（XeLaTeX）
- 中文字体 `simsun.ttc`（宋体）、`simhei.ttf`（黑体）已包含在仓库中
