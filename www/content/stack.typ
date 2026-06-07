#import "../utils/page.typ": page
#import "../utils/site.typ": u
#import "../utils/glossary.typ" as g
#import "../utils/env.typ": ENV
#import "../utils/repo.typ": php-version, slim-version

#let php-mem = ENV.at("RECALL_PHP_MEMORY_LIMIT")
#let container-mem = ENV.at("RECALL_CONTAINER_MEMORY_LIMIT")

#show: page.with(title: "Почему такой стек", active: "/stack/")

Проект собран неспроста, каждый выбор был обоснован. Если вы сделали
иначе и можете объяснить, почему — это ровно тот разговор, который нам интересен:
пишите в `LOGBOOK.md`.

= Backend

- PHP #php-version + Slim #slim-version — это тонкий микрофреймворк, а не тяжеловесные Laravel или Symfony:
  видно, как устроено приложение; фреймворк ничего не прячет.
- Cycle ORM — схема задаётся массивом, домен остаётся чистым: без аннотаций в
  сущностях и без компиляции на каждый запрос.
- SQLite — ноль настройки, база — это один файл. Для небольших объёмов достаточно;
  #link("https://www.postgresql.org")[PostgreSQL] был бы избыточен для нужд заказчика.
- id — это UUIDv7, а момент создания берём из самого id — сортируемый ключ и время
  «бесплатно», без автоинкремента и колонки created_at.

= Frontend

- TypeScript + Vite, без UI-фреймворка. Видно платформу, а не абстракции React
  или Vue. Захотите фреймворк — обоснуйте, зачем он здесь.

= Соглашения и проверки

- #g.openapi()[OpenAPI] (`spec/api/openapi.yaml`) — схема первична: и фронтенд,
  и проверки опираются на неё.
- #g.hurl()[Hurl] обеспечивает #g.acceptance-tests()[приёмочные проверки] через
  файлы с одноимённым расширением, которые запускаются в #g.ci()[CI]. Удобнее,
  чем держать коллекцию в #link("https://www.postman.com")[Postman].
- #g.playwright()[Playwright] — несколько UI-сценариев поверх контракта.

= Дисциплина

- Строгий #g.static-analysis()[статанализ] (PHPStan на уровне max+strict, PHPMD,
  Rector; ESLint с type-aware правилами, Prettier) — мы держим планку
  #link("https://maximaster.ru/blog/code-quality/")[качества кода], критичную для разработки
  #link("https://maximaster.ru/blog/hygienic-minimum-of-non-functional-requirements/")[современных проектов].
- Лимиты памяти (#raw(php-mem) / #raw(container-mem)) — приближаем условия
  разработки к скромному серверу заказчика, чтобы исключить неожиданности при
  деплое.
- devbox — окружение разворачивается одной командой и одинаково у всех, без
  «поставьте десять инструментов руками».

= Этот сайт

Сам гайд собран на #link("https://typst.app/docs/")[Typst] +
#link("https://github.com/tola-rs/tola-ssg")[Tola]. Инструкция живёт рядом с
кодом и собирается в статический сайт. Typst хорош тем, что читается как
Markdown, но под капотом полноценный язык программирования, который легко
конвертируется в PDF, если вам так удобнее.

Цифры выше — не переписаны вручную: лимиты памяти страница читает прямо из
`.env.example` через #link("https://typst.app/docs/reference/data-loading/")[data-loading]
Typst, поэтому инструкция не может разойтись с конфигом.

А ещё Typst даёт хорошую ссылочность. Когда в тексте встречается термин, к нему
всплывает подсказка — все они собраны в #link(u("/glossary/"))[глоссарий].
На термины мы ссылаемся через код, так что при их переименовании или удалении
#g.lsp()[LSP] и компилятор сразу покажут, где термин ещё используется.
