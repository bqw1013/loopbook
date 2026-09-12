-- svg2png.lua
-- 构建 EPUB 时，把 Markdown 里的图片引用统一改写到 _book/img/<basename>。
--   .svg   → 已预转换的 .png（Apple Books 对 EPUB 里 <img> 嵌入 SVG 支持很差）
--   .png / .jpg 源图由 build_epub.sh 拷进同一目录
-- 其余同 svg2pdf.lua 的说明：pandoc 从仓库根按 cwd 解析唯一路径。
--
-- 挂载方式：pandoc --lua-filter=svg2png.lua

function Image (img)
  local basename = img.src:match("([^/]+)$")
  if basename then
    local out = basename:gsub("%.svg$", ".png")
    img.src = "_book/img/" .. out
  end
  return img
end
