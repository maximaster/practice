// Show rules for content inside the layout.

#import "../utils/tola.typ": to-string

// Транслитерация кириллицы — иначе кириллические заголовки дают пустой id=""
// (невалидный дублирующийся якорь). Сводим к латинице, потом к slug.
#let _translit = (
  "а": "a", "б": "b", "в": "v", "г": "g", "д": "d", "е": "e", "ё": "e",
  "ж": "zh", "з": "z", "и": "i", "й": "i", "к": "k", "л": "l", "м": "m",
  "н": "n", "о": "o", "п": "p", "р": "r", "с": "s", "т": "t", "у": "u",
  "ф": "f", "х": "h", "ц": "c", "ч": "ch", "ш": "sh", "щ": "sch", "ъ": "",
  "ы": "y", "ь": "", "э": "e", "ю": "yu", "я": "ya",
)

#let _slug(s) = {
  let t = lower(if type(s) == str { s } else { to-string(s) })
  let r = ""
  let prev-dash = true
  for c in t.clusters() {
    for ch in _translit.at(c, default: c).clusters() {
      let ok = (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9")
      if ok {
        r = r + ch
        prev-dash = false
      } else if not prev-dash {
        r = r + "-"
        prev-dash = true
      }
    }
  }
  if r.ends-with("-") { r = r.slice(0, r.len() - 1) }
  if r.starts-with("-") { r = r.slice(1) }
  r
}

#let base(body) = {
  // h1 is the page title (rendered by the layout); content headings start at h2.
  show heading.where(level: 1): it => html.elem("h2", attrs: (id: _slug(it.body)))[#it.body]
  show heading.where(level: 2): it => html.elem("h3", attrs: (id: _slug(it.body)))[#it.body]
  show heading.where(level: 3): it => html.elem("h4", attrs: (id: _slug(it.body)))[#it.body]

  body
}
