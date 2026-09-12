---
title: 首页
---

# loopbook 示例书

这是 **loopbook** 骨架自带的示例首页。开新书时，把这一页整体换成你书的介绍：
它是什么、写给谁、怎么读。

## 这个骨架里有什么

- **写作硬规范** `CLAUDE.md`：图表题注、代码行宽、缺字符号、文风四条，每章都必须遵守。
- **创作方法** `dev/design-rationale.md`：学习引擎理论（为什么这样写教材）；
  `dev/plan.md`：本书的创作约定模板，开书时先填它。
- **构建工具链** `dev/tooling.md`：`uv run mkdocs serve` 预览站点，
  `bash build_pdf.sh` / `bash build_epub.sh` 产出 `_book/` 下的电子书。
- **一章写满的样例** `chapters/01-sample-chapter/`：演示微环四拍、图表题注、
  AI 接口的完整写法，开书时替换或删除。

## 快速开始

```bash
uv sync --group docs
uv run mkdocs serve
```
