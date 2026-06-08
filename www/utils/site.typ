// Site-wide constants for the Recall guide.

// Path prefix the site is served under (GitHub Pages project page).
// Keep in sync with `site.info.url` in tola.toml. Single source for links.
#let PREFIX = "/practice"

// Build an internal URL: u("/brief/") -> "/practice/brief/".
#let u(path) = PREFIX + path

// Canonical site URL (GitHub Pages project page). Keep in sync with `site.info.url`.
#let SITE-URL = "https://maximaster.github.io/practice"

// Автор шаблона и ссылка на него — для атрибуции в шапке, подвале и SEO-метатегах.
#let AUTHOR = "Максимастер"
#let AUTHOR-URL = "https://maximaster.ru"

#let SITE = (
  title: "Recall — практика",
  tagline: "Recall — учебное задание для практики",
  // Базовое описание для <meta description> и Open Graph.
  description: (
    "Recall — учебное задание для практики от Максимастер: персональная база "
      + "знаний с заметками и интервальным повторением. Бриф заказчика, стек, "
      + "критерии приёмки."
  ),
  // Хвост для <title>: имя проекта + автор, чтобы выдача была самоописательной.
  title-suffix: "Recall · " + AUTHOR,
  // Полный <title> главной страницы.
  title-home: "Recall — задание для практики от " + AUTHOR,
  url: SITE-URL,
  author: AUTHOR,
  author-url: AUTHOR-URL,
)

#let NAV = (
  (label: "Обзор", href: "/"),
  (label: "Бриф", href: "/brief/"),
  (label: "Задание", href: "/task/"),
  (label: "Стек", href: "/stack/"),
  (label: "Термины", href: "/glossary/"),
)
