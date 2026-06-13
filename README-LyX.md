# NCEPU 硕士论文模板 — LyX 用户指南

本模板提供**两套编译管线**，输出效果一致：

| 管线 | 源文件 | 编辑器 | 适合用户 |
|:-----|:-------|:-------|:---------|
| **LyX 版（推荐）** | `main.lyx` | LyX 2.5（所见即所得） | 习惯可视化编辑，不想记 LaTeX 命令 |
| **TeX 版（官方）** | `main_ref.tex` | 任何 TeX 编辑器 | 习惯直接写 LaTeX 代码 |

---

## 快速开始

### 首次使用

1. 安装 LyX 2.5（下载地址：https://www.lyx.org/Download）
2. 确保已安装 XeLaTeX（TeX Live 2020+）
3. 打开 `main.lyx`，LyX 自动加载 `NCEPUMaster.layout` 布局
4. 编译：`文档 → 导出 → PDF（XeLaTeX）` 或直接运行 `build.ps1`

### 一键编译（推荐）

```powershell
.claude\scripts\build.ps1
```

脚本自动：编译 → 清理临时文件 → 与 `main_ref.pdf` 逐页对比 → 输出差异报告 `diff_report.md`

---

## LyX 界面说明

### 1. 学位类型（学硕 / 专硕）

在文档开头可见：

```
学位类型 (academic/professional)：professional
```

- **学术硕士**：填写 `academic`
- **专业硕士**：填写 `professional`

选择后，封面、中文信息页、英文信息页自动显示对应的学位名称（"学术硕士学位论文" / "专业硕士学位论文"）。

### 2. 元数据字段

所有封面信息通过 LyX 样式填写，从菜单 `插入 → 自定义布局` 中选择：

| 菜单分组 | 字段 | 说明 |
|:---------|:-----|:-----|
| **基本信息** | 中文标题、英文标题、英文标题过长标志 | 公共字段，学硕/专硕均需填写 |
| | 中文作者、英文作者 | |
| | 中文导师、英文导师 | |
| | 中文申请学位（学硕→工学硕士，专硕→工程硕士） | |
| | 英文申请学位 | |
| | 中文所在学院、英文所在学院 | |
| | 中文答辩日期、英文答辩日期 | |
| **学术硕士专用** | [学硕] 中文学科专业、[学硕] 英文学科专业 | 仅学术硕士填写 |
| **专业硕士专用** | [专硕] 中文企业导师、[专硕] 英文企业导师 | 仅专业硕士填写 |
| | [专硕] 中文专业领域、[专硕] 英文专业领域 | |
| | [专硕] 中文学习方式、[专硕] 英文学习方式 | |
| **其他信息** | 国内图书分类号、国际图书分类号、密级 | 公共字段 |

> 字段全部集中显示在文档开头，填写完即可编译。无需编辑任何 LaTeX 代码。

### 3. 成果列表（攻读学位期间发表论文）

使用 LyX 标准**编号列表**（Enumerate），自动生成 `[1]` `[2]` 编号和悬挂缩进：

```
（一）发表的学术论文
[1] xxx，xxx．文章标题[J]．期刊名，...
[2] xxx，xxx．文章标题[J]．期刊名，...
```

操作：`插入 → 列表/提纲 → 编号列表`

编号格式和缩进已在导言区预设，无需手动调整。

### 4. 图表标题

- **图标题**：使用 `BilingualFigureCaption` 样式，自动生成中英双语标题
- **子图**：使用 `Subfigure` Flex Inset，设置宽度比例和位置
- **表标题**：使用 `BilingualTableCaption` 样式

### 5. 定理环境

支持定理、定义、引理、推论、性质、例、注、证明——在 LyX 环境中直接使用。

### 6. 算法伪代码

支持 `algorithm` + `algorithmic` 环境，通过 `AlgFor`、`AlgIf`、`AlgWhile` 等样式插入。

---

## NCEPUMaster.cls 与官方原版的区别

`NCEPUMaster.cls` 基于官方 `NCEPUMaster_Original.cls` 修改，改动如下：

| 修改项 | 官方原版 | 当前版本 | 原因 |
|:-------|:---------|:---------|:-----|
| **子图宏包** | `subcaption` | `subfig` | `subfig` 对 LyX 兼容性更好 |
| **子图标题** | `\captionsetup[subfigure]` | `\captionsetup[subfloat]` | 配合 `subfig` 宏包 |
| **natbib** | `\RequirePackage[sort&compress]{natbib}` | 增加 `numbers` 选项 | 兼容 LyX 的引用设置 |
| **xcolor** | 直接加载 | 先 `\PassOptionsToPackage{table}` | 允许表格中使用颜色 |
| **目录页码** | 注释掉页码重置 | 启用了 `\setcounter{page}{1}` | 确保目录页码从 1 开始 |
| **成果列表** | 注释掉 `leftmargin` | 启用 `leftmargin=2.5em` | 实现悬挂缩进 |
| **引用上标** | 无 | 导言区添加 `\setcitestyle{super}` | 参考文献引用默认上标 |

> 所有修改均向后兼容。如果不需要 LyX 功能，可直接使用 `NCEPUMaster_Original.cls` 配合 `main_ref.tex` 编译。

---

## 已知差异（LyX 版 vs TeX 版）

通过编译对比工具对比 `main.pdf`（LyX）与 `main_ref.pdf`（TeX），存在以下细微差异：

| 差异类型 | 说明 | 影响 |
|:---------|:-----|:-----|
| **渲染精度**（P6, P9, P18, P21） | LyX 和 TeX 引擎对字体微调不同，像素级有差异 | 文本内容完全一致，打印无区别 |
| **目录间距**（P7） | 中文字符与引导线的间距略有不同 | 视觉上可忽略 |
| **标点间距**（P10-P11） | 中文与英文/数字间的空格处理不同 | 符合排版规范 |
| **断行位置**（P13-P14） | 长段落在页面边界处换行位置略有偏移 | 不影响阅读 |
| **表格/符号表**（P15-P16） | 列宽和间距的像素级差异 | 数据内容完全一致 |
| **成果列表**（P20） | LyX 使用 Enumerate 自动编号，TeX 使用自定义列表 | 渲染效果基本一致 |

**结论**：两个版本的内容完全一致，仅在排版细节上因不同引擎有微小差异，不影响论文评审。

---

## 文件结构

```
.
├── main.lyx                 # ★ LyX 主文件（用这个编辑！）
├── main_ref.tex             # TeX 版备份（官方管线）
├── NCEPUMaster.cls          # ★ 文档样式（已适配 LyX）
├── NCEPUMaster_Original.cls # 官方原版 cls（未修改）
├── NCEPUMaster.layout       # ★ LyX 布局定义（决定了 LyX 界面）
├── main_ref.pdf             # 只读基准 PDF
├── chapters/                # 正文章节（.lyx 文件内联在 main.lyx 中）
├── figures/                 # 插图文件夹
├── figure_for_NCEPU/        # 学校标志（勿动）
├── others/                  # 前/后置部分（摘要、符号表、致谢等）
├── .claude/scripts/
│   ├── build.ps1            # 一键编译脚本
│   └── compare-detail.ps1   # PDF 逐页对比引擎
└── README-LyX.md            # 本文件
```

---

## 常见问题

### Q: LyX 打开报错 "Unknown layout tag"？
A: 确保已将 `NCEPUMaster.layout` 放在 `main.lyx` 同级目录。LyX 会自动加载。如果仍有问题，执行 `工具 → 重新配置` 后重启 LyX。

### Q: 如何切换学硕/专硕？
A: 在文档开头找到 `学位类型 (academic/professional)：` 行，改为 `academic`（学硕）或 `professional`（专硕）。

### Q: 编译报找不到字体？
A: 模板依赖 `simsun.ttc`（宋体）和 `simhei.ttf`（黑体），已包含在项目根目录。如果报错，请用 XeLaTeX 编译。

### Q: 我想改格式（页边距、行距等）？
A: 所有格式定义在 `NCEPUMaster.cls` 中。**不建议修改**——如需调整，请在 `main.lyx` 导言区添加 LaTeX 命令覆盖。
