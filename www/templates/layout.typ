// Page chrome: head, header nav, main, footer.

#import "../utils/site.typ": SITE, NAV, u

#let make-head(m) = {
  html.elem("meta", attrs: (charset: "utf-8"))
  html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
  let t = m.at("title", default: SITE.title)
  html.elem("title")[#t]
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

  // Keep the brand body purely inline. A real <img> is block-level in Typst's
  // html model, which forces a <p> inside the <a> — invalid nesting the browser
  // splits into two anchors, spreading logo and name apart. Render the logo as
  // a CSS background on an inline span instead, so no paragraph is emitted.
  let brand = html.elem(
    "a",
    attrs: (href: u("/"), class: "brand"),
    html.elem("span", attrs: (
      class: "brand-mark",
      role: "img",
      "aria-label": "Максимастер",
    )) + html.elem("span", attrs: (class: "brand-name"), [Recall]),
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

  html.elem("footer", attrs: (class: "site-footer"))[
    #SITE.tagline
  ]
}
