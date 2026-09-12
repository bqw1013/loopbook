-- svg2pdf.lua
-- 构建 PDF 时，把 Markdown 里的图片引用统一改写到 _book/img/<basename>。
--   .svg   → 已预转换的 .pdf
--   .png / .jpg 源图由 build_pdf.sh 拷进同一目录
-- 原因：md 里的 images/xxx 是相对自身章目录的（给 MkDocs 用）；而 pandoc
-- 多文件拼接时不按各 md 所在目录解析图片，为避免依赖 resource-path 的怪癖，
-- 让所有图片落到仓库根可解析的唯一路径（_book/img/，已 gitignore），
-- pandoc 从仓库根执行即可按 cwd 找到。前提：图文件名全书唯一。
--
-- 挂载方式：pandoc --lua-filter=svg2pdf.lua

function Image (img)
  local basename = img.src:match("([^/]+)$")
  if basename then
    local out = basename:gsub("%.svg$", ".pdf")
    img.src = "_book/img/" .. out
  end
  return img
end

-- 禁用 pandoc 的自动图题（implicit_figures）：正文里的图一律以手写题注为准
-- （约定见 dev/plan.md 创作约定·图表题注）。pandoc ≥3 会把「独占一段的图片」
-- 包成 Figure 并用图片 alt 自动生成题注，会与 md 里手写的题注行重复。
-- 这里把独占图片的 Figure 降回普通图片段落：自动题注消失，手写题注保留。
function Figure (fig)
  local count, img = 0, nil
  fig.content:walk {
    Image = function (im)
      count = count + 1
      img = im
      return im
    end
  }
  if count == 1 and img then
    return pandoc.Para({ img })
  end
  return fig
end
