---
name: compare
description: 对比 main.pdf 与只读基准文件 main_ref.pdf，终端显示表格汇总，同时生成 diff_report.md 详细报告。当用户说"比较pdf"、"对比pdf"、"compare pdf"时触发。
---

# /compare — 对比 PDF

执行 `compare.ps1`：

```powershell
.claude\scripts\compare.ps1
```

## 输出

1. **终端表格** — 逐页对比（图像/文本/差异说明），颜色标识
2. **`diff_report.md`** — 详细差异报告，含 ref vs new 逐行对比表
