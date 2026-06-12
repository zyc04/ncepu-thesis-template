---
name: build
description: 编译 main.tex 为 PDF，自动清理临时文件，并与基准文件 main_ref.pdf 对比显示差异。当用户说"编译tex"、"编译论文"、"build"时触发。
---

# /build — 编译论文

执行 `build.ps1` 完成编译 → 清理 → PDF 对比：

```powershell
.claude\scripts\build.ps1
```

## 完整流程
1. `xelatex` 第一遍
2. `bibtex` 处理参考文献
3. `xelatex` 第二遍（解析引用）
4. `xelatex` 第三遍（最终定稿）
5. 立即清理所有临时文件（`.aux`, `.bbl`, `.log`, `.toc` 等）
6. 用 `compare_pdf` 对比新 `main.pdf` 与只读基准文件 `main_ref.pdf`
7. 显示逐页对比结果——无变化则提示一致，有差异则标红显示差异页码

## 注意事项
- 从项目根目录执行
- 任意步骤出错则立即停止，临时文件**不会清理**，方便排查问题
- LaTeX 警告（字体替代、盒子溢出、标签重复等）不影响 PDF 输出
