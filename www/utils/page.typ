// Page wrapper used by every content file.
//
// Usage:
//   #import "../utils/page.typ": page
//   #show: page.with(title: "...")

#import "../templates/tola.typ": wrap-page
#import "../templates/base.typ": base
#import "../templates/layout.typ": layout, make-head

#let page = wrap-page(
  base: base,
  head: make-head,
  view: (body, m) => layout(body, meta: m),
)
