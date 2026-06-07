// Site-wide constants for the Recall guide.

// Path prefix the site is served under (GitHub Pages project page).
// Keep in sync with `site.info.url` in tola.toml. Single source for links.
#let PREFIX = "/practice"

// Build an internal URL: u("/brief/") -> "/practice/brief/".
#let u(path) = PREFIX + path

#let SITE = (
  title: "Recall — практика",
  tagline: "Задание для практики",
)

#let NAV = (
  (label: "Обзор", href: "/"),
  (label: "Бриф заказчика", href: "/brief/"),
  (label: "Задание", href: "/task/"),
  (label: "Почему так", href: "/stack/"),
  (label: "Глоссарий", href: "/glossary/"),
)
