// MathJax 3 配置：正文用 $...$ 行内公式、$$...$$ 块级公式。
// pymdownx.arithmatex 在 generic: true 下输出 $...$ / $$...$$，
// 这里同时声明 \(...\) / \[...\] 以防扩展改为包裹形式。
window.MathJax = {
  tex: {
    inlineMath: [
      ['$', '$'],
      ['\\(', '\\)']
    ],
    displayMath: [
      ['$$', '$$'],
      ['\\[', '\\]']
    ],
    processEscapes: true
  },
  svg: {
    fontCache: 'global'
  },
  options: {
    ignoreHtmlClass: 'tex2jax_ignore',
    processHtmlClass: 'tex2jax_process'
  }
};
