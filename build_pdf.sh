#!/bin/bash
# 将 chapters/ 下的 Markdown 章节构建为单个 PDF。
#
# 依赖：
#   - pandoc        文档格式转换（Markdown -> LaTeX）
#   - xelatex       排版引擎（Windows: MiKTeX / Linux: texlive-xetex）
#   - Inkscape 或 rsvg-convert   SVG 图转 PDF（Windows: Inkscape / Linux: librsvg2-bin）
#
# 用法：bash build_pdf.sh

set -e

OUT_DIR="_book"
IMG_DIR="$OUT_DIR/img"
OUT_NAME="loopbook.pdf"

# 章节顺序在此定义（新增章节时在这里追加，与 mkdocs.yml nav 保持一致）
CHAPTERS=(
    chapters/index.md
    chapters/01-sample-chapter/index.md
)

mkdir -p "$OUT_DIR" "$IMG_DIR"

# 图片统一收集到 _book/img/（唯一路径，pandoc 从仓库根即可解析；该目录已 gitignore）：
#   1) 各章 svg 转成同名 pdf
#   2) 各章源 png/jpg 原样拷入（图文件名需全书唯一，重名会互相覆盖）
rm -f "$IMG_DIR"/*
while IFS= read -r -d '' svg; do
    pdf="$IMG_DIR/$(basename "${svg%.svg}").pdf"
    if command -v rsvg-convert >/dev/null 2>&1; then
        rsvg-convert -f pdf -o "$pdf" "$svg"
    else
        inkscape "$svg" --export-type=pdf --export-filename="$pdf" 2>/dev/null
    fi
done < <(find chapters -name '*.svg' -print0)
while IFS= read -r -d '' img; do
    cp "$img" "$IMG_DIR/$(basename "$img")"
done < <(find chapters \( -name '*.png' -o -name '*.jpg' \) -print0)

pandoc "${CHAPTERS[@]}" \
    -o "$OUT_DIR/$OUT_NAME" \
    --from markdown \
    --lua-filter=svg2pdf.lua \
    --pdf-engine=xelatex \
    -V documentclass=ctexart \
    -V geometry:margin=2.5cm \
    --toc \
    --highlight-style=tango

echo "Done: $OUT_DIR/$OUT_NAME"
