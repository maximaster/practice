#import "../utils/page.typ": page
#import "../utils/glossary.typ": TERMS

#show: page.with(title: "Глоссарий", active: "/glossary/")

Короткий словарь терминов из задания и руководства. Подсказки по этим терминам
всплывают, если навести курсор на подчёркнутое слово в тексте.

#html.elem(
  "dl",
  attrs: (class: "glossary"),
  {
    for (code, entry) in TERMS {
      html.elem("dt", entry.term)
      html.elem("dd", entry.tip)
    }
  },
)
