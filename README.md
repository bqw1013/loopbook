# loopbook

> 面向中文技术书与教材的图书骨架：内置学习引擎理论、AI 代笔硬规范与
> 「站点 + PDF + EPUB」三产物构建链。复制本骨架、替换内容，即得一本新书工程。

## 骨架里有什么

| 支柱 | 位置 | 说明 |
|------|------|------|
| 学习理论 | `dev/design-rationale.md` | 为什么这样写教材：反馈闭环、学习引擎三层维度、教材设计准则 |
| 写作硬规范 | `CLAUDE.md` | 图表题注、代码行宽、缺字符号、文风四条，每章都必须遵守 |
| 本书约定 | `dev/plan.md` | 创作约定模板：读者画像、整任务章节大纲、进度（开书时先填它） |
| 构建链 | `build_pdf.sh` `build_epub.sh` `mkdocs.yml` | 一套 Markdown 源，同时产出站点、PDF、EPUB |
| 样例章 | `chapters/01-sample-chapter/` | 写满的一章，演示微环四拍、题注、AI 接口的完整写法；正文、配图、代码都在这一目录内 |

## 环境准备

`uv`、`pandoc`、`xelatex`（MiKTeX / TeX Live）、Inkscape（配图用 SVG 时需要）。
安装与排错见 [dev/tooling.md](dev/tooling.md)。

## 三分钟跑通

```bash
uv sync --group docs
uv run mkdocs serve                          # 站点预览
bash build_pdf.sh                            # _book/loopbook.pdf
bash build_epub.sh                           # _book/loopbook.epub
uv run python chapters/01-sample-chapter/code/hash_dedup.py   # 章配套脚本
```

## 用它开一本新书

1. **定身份**：改 `mkdocs.yml` 的 `site_name` / `nav` 与 `build_pdf.sh`、`build_epub.sh`
   顶部的 `CHAPTERS`（新增章要三处同步）；EPUB 书名在 `build_epub.sh` 的
   `-M title`。
2. **先理论后动笔**：读 `dev/design-rationale.md`，再填 `dev/plan.md` 的读者画像
   与整任务章节序列。
3. **替换内容**：`chapters/index.md` 与 `chapters/01-sample-chapter/` 是占位示例，
   换成你的首页与第一章。
4. **硬规范不动**：`CLAUDE.md` 直接沿用。

## 目录速览

```text
chapters/            # 站点与电子书的 Markdown 源，一章一个目录
  index.md           #   首页
  NN-slug/index.md   #   章正文
  NN-slug/images/    #   本章配图（有图才有；文件名全书唯一）
  NN-slug/code/      #   本章完整可执行代码（有代码才有）
scratch/             # 脚本运行时产物（已 gitignore，只保留目录壳）
data/                # 随书数据（按需填充；大文件走脚本拉取，不进 git）
dev/                 # 创作资料：design-rationale / plan 模板 / tooling 手册
```
