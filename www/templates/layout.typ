// Page chrome: head, header nav, main, footer.

#import "../utils/site.typ": SITE, NAV, u
#import "../utils/tola.typ": og-tags

#let make-head(m) = {
  html.elem("meta", attrs: (charset: "utf-8"))
  html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))

  // <title>: на главной — полное самоописательное название, на остальных
  // страницах добавляем хвост «Recall · Максимастер», чтобы выдача и вкладка
  // всегда называли проект и автора.
  let page-title = m.at("title", default: SITE.title)
  let title = if page-title == SITE.title { SITE.title-home } else {
    page-title + " — " + SITE.title-suffix
  }
  let desc = m.at("summary", default: SITE.description)
  html.elem("title")[#title]
  html.elem("meta", attrs: (name: "description", content: desc))
  html.elem("meta", attrs: (name: "author", content: SITE.author))
  html.elem("link", attrs: (rel: "canonical", href: SITE.url))
  og-tags(
    title: title,
    description: desc,
    url: SITE.url,
    type: "website",
    site-name: SITE.author,
    locale: "ru_RU",
  )

  html.elem("link", attrs: (rel: "preconnect", href: "https://fonts.googleapis.com"))
  html.elem("link", attrs: (rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: ""))
  html.elem("link", attrs: (
    rel: "stylesheet",
    href: "https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap",
  ))
  // Asset links stay source-relative (/assets/...): Tola applies the site
  // prefix itself on build. Wrapping them in u() emits the same path but makes
  // `tola validate` treat them as page links → "not found". u() is for pages.
  html.elem("link", attrs: (rel: "stylesheet", href: "/assets/styles/main.css"))
  html.elem("link", attrs: (rel: "stylesheet", href: "/assets/styles/components.css"))
  html.script(
    "(function(){var d=document.documentElement;var t=localStorage.getItem('theme');if(t){d.setAttribute('data-theme',t)}else if(window.matchMedia('(prefers-color-scheme:dark)').matches){d.setAttribute('data-theme','dark')}}());function toggleTheme(){var d=document.documentElement;d.setAttribute('data-theme',d.getAttribute('data-theme')==='dark'?'light':'dark');localStorage.setItem('theme',d.getAttribute('data-theme'))}",
  )
}

#let layout(body, meta: (:)) = {
  let title = meta.at("title", default: none)
  let active = meta.at("active", default: none)

  // Brand block: logo links home, next to a two-line text column — the project
  // name (links home) над строкой атрибуции «сделано в Максимастер», где имя
  // ведёт на сайт студии. Атрибуция — отдельная ссылка, поэтому она НЕ может
  // лежать внутри ссылки-названия (вложенные <a> невалидны) — отсюда колонка
  // из двух самостоятельных якорей.
  //
  // Logo stays a CSS background on an inline span: a real <img> is block-level
  // in Typst's html model and would force a <p>, breaking the layout.
  let mark = html.elem("span", attrs: (
    class: "brand-mark",
    role: "img",
    "aria-label": SITE.author,
  ))
  let brand-by = html.elem(
    "span",
    attrs: (class: "brand-by"),
    [сделано в ]
      + html.elem("a", attrs: (href: SITE.author-url, rel: "author"), [#SITE.author]),
  )
  let brand = html.elem(
    "div",
    attrs: (class: "brand"),
    html.elem("a", attrs: (href: u("/"), class: "brand-home", "aria-label": "Recall"), mark)
      + html.elem(
        "span",
        attrs: (class: "brand-text"),
        html.elem("a", attrs: (href: u("/"), class: "brand-name"), [Recall: задание для практики])
          + brand-by,
      ),
  )

  let nav = html.elem("nav", {
    for item in NAV {
      let attrs = (href: u(item.href))
      // Mark the link for the current page so CSS can highlight it.
      if active == item.href { attrs.insert("aria-current", "page") }
      html.elem("a", attrs: attrs, [#item.label])
    }
  })

  let toggleBtn = html.elem(
    "button",
    attrs: (
      class: "theme-toggle",
      type: "button",
      "aria-label": "Переключить тему",
      onclick: "toggleTheme()",
    ),
    html.elem("span", attrs: (class: "theme-icon theme-icon-sun"), [☀])
    + html.elem("span", attrs: (class: "theme-icon theme-icon-moon"), [🌙]),
  )

  html.elem("header", attrs: (class: "site-header"), brand + nav + toggleBtn)

  html.elem("main")[
    #if title != none { html.elem("h1")[#title] }
    #body
  ]

  html.elem(
    "footer",
    attrs: (class: "site-footer"),
    [#SITE.tagline · сделано в ]
      + html.elem("a", attrs: (href: SITE.author-url, rel: "author"), [#SITE.author]),
  )
}
