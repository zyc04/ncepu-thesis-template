---
name: compare
description: 对比 main.pdf 与只读基准文件 main_ref.pdf，逐页显示差异。当用户说"比较pdf"、"对比pdf"、"compare pdf"时触发。
---

# /compare — 对比 PDF

执行 `compare.ps1` 对比当前 `main.pdf` 与只读基准文件 `main_ref.pdf`：

```powershell
.claude\scripts\compare.ps1
```

## 说明
- `main_ref.pdf` 是项目根目录下的只读基准文件
- 当编译后的输出与预期不一致时，用此命令快速定位差异
- 全部一致显示"✓ 与基准文件完全一致"，有差异会标红显示具体页码
