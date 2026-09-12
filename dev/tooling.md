# 工具链手册

> 维护者用。命令一律在仓库根目录执行。

## 一、安装依赖

| 依赖 | Windows 安装 | Debian / Ubuntu 安装 | 作用 |
|------|--------------|----------------------|------|
| uv | 安装脚本见 [uv 官方文档](https://docs.astral.sh/uv/) | 同左 | Python 环境与依赖管理，`uv sync` 一并装好 MkDocs 等全部项目依赖 |
| pandoc | 官网安装包 | `sudo apt install pandoc` | 把 Markdown 章节转成 LaTeX（PDF）与 EPUB |
| xelatex（MiKTeX / TeX Live） | `winget install MiKTeX.MiKTeX` | `sudo apt install texlive-xetex texlive-lang-chinese fonts-noto-cjk` | 把 LaTeX 排版成 PDF，中文用 ctexart 文档类 |
| Inkscape / rsvg-convert | `winget install Inkscape.Inkscape` | `sudo apt install librsvg2-bin` | 仅当配图用 SVG 时需要，构建时转成 PDF / PNG |

> Windows 提示：git-bash 会话若报 `inkscape: command not found`（exit 127），
> 是旧会话没刷新 PATH——新开终端即可；或临时
> `export PATH="/c/Program Files/Inkscape/bin:$PATH"`。

## 二、日常命令

常用操作分两类：跑 Python 示例，以及构建站点与电子书。后者的工具见上一节。

| 任务 | 命令 | 产物 / 位置 |
|------|------|-------------|
| 同步环境（运行依赖） | `uv sync` | `.venv/` |
| 同步环境（含站点工具） | `uv sync --group docs` | `.venv/` |
| 运行示例 | `uv run python examples/01_hash_dedup.py` | 终端输出 + `scratch/ch1/` |
| 预览站点 | `uv run mkdocs serve` | http://127.0.0.1:8000 |
| 构建站点 | `uv run mkdocs build` | `site/` |
| 构建 PDF | `bash build_pdf.sh` | `_book/loopbook.pdf` |
| 构建 EPUB | `bash build_epub.sh` | `_book/loopbook.epub` |

`site/`、`_book/` 与构建期派生的图片都是产物，已被 .gitignore 忽略，无需提交。

## 三、章节结构

一章 = `chapters/` 下一个文件夹，正文 `index.md`，图在文件夹自己的 `images/` 里：

```text
chapters/
  index.md                     # 首页，固定
  01-sample-chapter/           # 示例章（开书时替换）
    index.md                   # 章正文
    images/hash-dedup.svg
```

## 四、新增章节

1. 新建 `chapters/NN-<slug>/index.md`（`NN` 两位序号决定先后），配图放同目录 `images/`；md 里用相对引用 `images/xxx.png` 即可。
2. 章节顺序由三处决定，**新增章要三处同步追加**，保持一致：
   - `mkdocs.yml` 的 `nav`；
   - `build_pdf.sh` 顶部的 `CHAPTERS=( ... )`；
   - `build_epub.sh` 顶部的 `CHAPTERS=( ... )`（与 PDF 一致）。
3. 配图规则：
   - png / jpg / svg 都可用。svg 会在构建时由 rsvg-convert / Inkscape 自动转成 PDF / PNG，源 png / jpg 原样收录，无需手工处理。
   - 构建时脚本把所有图统一收集到 `_book/img/`（已 gitignore）的**唯一扁平路径**，pandoc 从仓库根按 cwd 解析（lua 过滤器在构建时改写引用）。因此 **图文件名必须全书唯一**（如 `hash-dedup.svg`）：重名会互相覆盖、导致串图。
   - md 内始终写相对自身章目录的 `images/xxx.svg`，供 MkDocs 站点直接渲染；PDF / EPUB 的路径改写对正文不可见。

## 五、公式

- 站点（MkDocs）：`mkdocs.yml` 已启用 `pymdownx.arithmatex` + MathJax（`chapters/javascripts/mathjax.js`）。正文里 `$...$` 行内、`$$...$$` 块级公式，与 Markdown 一致即可。MathJax 从 CDN 加载，离线预览时公式不会渲染。
- PDF / EPUB：pandoc 原生把 `$...$` 转成 LaTeX 数学，无需额外配置。
