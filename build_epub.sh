#!/bin/bash
# 将 chapters/ 下的 Markdown 章节构建为 EPUB 电子书。
#
# 依赖：
#   - pandoc    文档格式转换（Markdown -> EPUB，基于 HTML，不需要 LaTeX）
#   - Inkscape  SVG 图转 PNG（Apple Books 对 EPUB 里的 SVG 支持很差，
#               会在图片处出现整页空白，因此 EPUB 构建时把图转成 PNG；
#               Linux 可改用 rsvg-convert，包名 librsvg2-bin）
#
# 用法：bash build_epub.sh

set -e

OUT_DIR="_book"
IMG_DIR="$OUT_DIR/img"
OUT_NAME="loopbook.epub"

# 章节顺序与 build_pdf.sh 保持一致
CHAPTERS=(
    chapters/index.md
    chapters/01-sample-chapter/index.md
)

mkdir -p "$OUT_DIR" "$IMG_DIR"

# 图片统一收集到 _book/img/（见 build_pdf.sh 的注释）：
#   1) 各章 svg 转成同名 png
#   2) 各章源 png/jpg 原样拷入
rm -f "$IMG_DIR"/*
while IFS= read -r -d '' svg; do
    png="$IMG_DIR/$(basename "${svg%.svg}").png"
    if command -v rsvg-convert >/dev/null 2>&1; then
        rsvg-convert -o "$png" "$svg"
    else
        inkscape "$svg" --export-type=png --export-filename="$png" -w 1200 2>/dev/null
    fi
done < <(find chapters -name '*.svg' -print0)
while IFS= read -r -d '' img; do
    cp "$img" "$IMG_DIR/$(basename "$img")"
done < <(find chapters \( -name '*.png' -o -name '*.jpg' \) -print0)

pandoc "${CHAPTERS[@]}" \
    -o "$OUT_DIR/$OUT_NAME" \
    --from markdown \
    --lua-filter=svg2png.lua \
    --css=epub.css \
    --toc \
    -M title="loopbook 示例书" \
    -M lang=zh-CN

echo "Done: $OUT_DIR/$OUT_NAME"
