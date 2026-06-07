// Glossary — single source for term definitions. Used two ways:
//   - inline:  #g.card[карточку]  → a term with a hover/focus tooltip
//   - the /glossary/ page renders the whole dict as a definition list
// Tooltip styling lives in assets/styles/components.css (.term / .tip).
//
// Each term is addressed by its code name (a dict field), not by its text:
//   - the inline word and its dictionary key are decoupled, so you write
//     the phrase in any grammatical form: #g.review-queue[очередь на сегодня];
//   - a typo in the code name is a hard compile error (unknown field), not a
//     silently mis-rendered word;
//   - `tip` is content, so a definition may contain #link(...) and markup.
//
// Usage (import the whole module as the `g` namespace):
//   #import "../utils/glossary.typ" as g
//   ...создаётся из #g.note()[заметки]...
//   #g.card()   // no body → the canonical term, "карточка"
//
// Each entry: `term` — canonical name shown on the /glossary/ page (<dt>);
//             `tip`  — definition shown in the tooltip and as <dd>.

#let TERMS = (
  spaced-repetition: (
    term: "интервальное повторение",
    tip: [Техника запоминания: материал показывают через растущие промежутки времени — перед тем, как вы успеете его забыть.],
  ),
  sm2: (
    term: "SM-2",
    tip: [Классический алгоритм интервального повторения, родом из #link("https://super-memory.com/english/ol/sm2.htm")[SuperMemo]. По вашей оценке и «лёгкости» карточки считает, когда показать её снова.],
  ),
  note: (
    term: "заметка",
    tip: [Единица знаний: заголовок, текст, теги и ссылки на другие заметки.],
  ),
  card: (
    term: "карточка",
    tip: [Вопрос и ответ (лицо и оборот). Создаётся из заметки и участвует в повторении.],
  ),
  grade: (
    term: "оценка карточки",
    tip: [Шкала припоминания: again, hard, good, easy — от худшего к лучшему, как кнопки в Anki. Это одна ось, а не разные оценки.],
  ),
  review-queue: (
    term: "очередь повторения",
    tip: [Карточки, срок показа которых наступил.],
  ),
  streak: (
    term: "серия",
    tip: [Streak — сколько дней подряд было хотя бы одно повторение.],
  ),
  acceptance-tests: (
    term: "приёмочные тесты",
    tip: [Проверки готовности: по контракту (Hurl) и несколько UI-сценариев (Playwright). Намеренно нестрогие.],
  ),
  openapi: (
    term: "OpenAPI",
    tip: [Формат описания HTTP-API. Схема в spec/api/openapi.yaml — источник истины для запросов и ответов.],
  ),
  hurl: (
    term: "Hurl",
    tip: [Текстовый формат HTTP-проверок: запрос плюс ассерты на статус, заголовки и тело. Дружит с git и CI.],
  ),
  playwright: (
    term: "Playwright",
    tip: [Браузерные #link("https://playwright.dev/")[end-to-end тесты]: открывают страницу и проходят сценарий как живой пользователь.],
  ),
  static-analysis: (
    term: "статический анализ",
    tip: [Проверка кода без запуска: типы, стиль, «запахи» (PHPStan, PHPMD, Rector, ESLint).],
  ),
  ci: (
    term: "CI",
    tip: [Continuous Integration — автопрогон проверок на каждый push. Здесь гоняет тот же just verify, что и у вас локально.],
  ),
  lsp: (
    term: "LSP",
    tip: [Language Server Protocol — по нему редактор даёт автодополнение, переходы и поиск использований. Термины глоссария адресуются по коду, поэтому LSP находит все места, где термин употреблён.],
  ),
)

// Build one wrapper per entry. `..args`: an optional content body overrides
// the displayed word; with none, the canonical term is shown.
#let _term(entry, ..args) = {
  let shown = if args.pos().len() > 0 { args.pos().first() } else { [#entry.term] }
  html.elem(
    "span",
    attrs: (class: "term", tabindex: "0"),
    shown + html.elem("span", attrs: (class: "tip"), entry.tip),
  )
}

// One module-level binding per term, so importing this file `as g` exposes
// `g.<code>()`. Typst can't call a function stored in a dict field via
// `g.code()` (that's method-call syntax), but a module member call works.
// Kept explicit (not a loop) because Typst can't create bindings dynamically.
#let spaced-repetition = _term.with(TERMS.spaced-repetition)
#let sm2 = _term.with(TERMS.sm2)
#let note = _term.with(TERMS.note)
#let card = _term.with(TERMS.card)
#let grade = _term.with(TERMS.grade)
#let review-queue = _term.with(TERMS.review-queue)
#let streak = _term.with(TERMS.streak)
#let acceptance-tests = _term.with(TERMS.acceptance-tests)
#let openapi = _term.with(TERMS.openapi)
#let hurl = _term.with(TERMS.hurl)
#let playwright = _term.with(TERMS.playwright)
#let static-analysis = _term.with(TERMS.static-analysis)
#let ci = _term.with(TERMS.ci)
#let lsp = _term.with(TERMS.lsp)
