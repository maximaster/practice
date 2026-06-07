# Инструкции агента

См. @README.md.
Настройки портов — `.env.example` / Justfile.

## Особенности окружения

- Инструменты ставит devbox. Запускать через `eval "$(devbox shellenv)"`
  либо `devbox shell` / direnv. `devbox run -- <cmd>` НЕ отдаёт на PATH
  flake-пакеты (tola) — используйте shellenv.
- Hurl ≥8 убрал переменные через `HURL_<имя>`. Передавать `--variable base=...`
  (Justfile уже так делает).
- Playwright на NixOS: скачанные браузеры не запускаются. Указать
  `PLAYWRIGHT_BROWSERS_PATH` в `.env` на nixpkgs-браузеры
  (`nix-build '<nixpkgs>' -A playwright-driver.browsers --no-out-link`).
  Рецепт `e2e` пропускает скачивание, когда переменная задана. Версию
  `@playwright/test` держать в паре с драйвером из nixpkgs (сейчас 1.56.x).
- `just guide` пишет в `www/public`. Пути к ассетам абсолютные (`/assets/...`),
  поэтому через `file://` стили не подхватятся — смотреть через `just guide-serve`.
  Префикс для GitHub Pages задан в `www/tola.toml` (`site.info.url`).
- Tola прибивает Typst-root к `www/` (флага `--root` нет), а Typst не читает
  файлы вне root — `yaml("../../compose.yaml")` падает «cannot read file outside
  of project root». Доступ к файлам репо-корня — через `www/root/`: реальный
  каталог с симлинками на ОТДЕЛЬНЫЕ файлы (каталоги симлинками не делать),
  повторяющими структуру репо. Typst идёт по симлинку внутри root, не проверяя
  цель. Так `www/utils/env.typ` читает `.env.example` (лимиты памяти — оттуда).
- В `.typ` ссылки только через `#link("url")[текст]`; markdown `[текст](url)`
  Typst не парсит (автоссылит голый URL, оставляя литерал) — `just lint` это
  ловит. Большие стили дробите на модули: CSS под лимитом linecop (300 строк).
- Статанализ backend — composer require-dev (php-cs-fixer, phpstan
  +strict/+deprecation, phpmd, rector); запуск через `just lint`/`just fmt`.
  php-cs-fixer на PHP 8.5 разрешён `setUnsupportedPhpVersionAllowed(true)`
  в конфиге (env `PHP_CS_FIXER_IGNORE_ENV` не нужен). PHPMD/pdepend не парсит
  parens-less `new` из PHP 8.4 — правило cs-fixer `new_expression_parentheses`
  и rector `NewMethodCallWithoutParenthesesRector` отключены, пишите `(new X())->y()`.
  pdepend под 8.5 шумит deprecation в stderr — гасим
  `-d error_reporting='E_ALL & ~E_DEPRECATED'`.
- Frontend-статанализ — npm devDeps (eslint + typescript-eslint, prettier);
  type-aware линт требует `tsconfig`, ESLint flat-config в `eslint.config.js`.
  Юнит-тесты фронта — Vitest (`npm test`), входят в `just test`.
- Backend на Slim 4 + Cycle ORM, id — UUIDv7 (symfony/uid), момент создания
  берётся из id (поля created_at в БД нет; updated_at — только у заметки).
  Схема Cycle задана массивом в `Infrastructure/Persistence/Orm.php` (без
  аннотаций в домене, без компиляции на запрос). Грабли Cycle: сущности НЕ
  `final` (ORM делает прокси-наследника при гидрации), id-VO реализуют
  `Stringable` (Heap индексирует по строке PK), перевод VO↔БД — в одном
  `ValueObjectTypecast`. Класс-обёртку нельзя звать `Orm`/`ORM` — конфликт
  с `Cycle\ORM\ORM` без учёта регистра.
- Зависимости приложения ставит composer (fallback-автозагрузчика больше нет);
  в `compose.yaml` это делает сервис `backend-deps` (`--no-dev`). Зависимости
  контейнеров — в именованных томах, локальный `vendor`/`node_modules` не трогают.

## CI и выдача студентам

- Шаблон НАМЕРЕННО не доходит до зелёного `just verify`: часть фич — стабы для
  студента (`ReviewsController::grade` не сохраняет карточку, `StatsController` —
  заглушка). Не «чинить» их: это и есть задание. Приёмка (`reviews.hurl` и т.п.)
  на шаблоне красная — так и должно быть.
- Два разных гейта. `just verify` — студенческий: решено ли задание (lint, юнит,
  acceptance, e2e), строго зелёный. На шаблоне красный, зеленеет по мере решения.
  В CI на ветках и PR (`ci.yml`), не на master. `just preflight` (алиас `handoff`)
  — гейт веб-студии: ЗДОРОВ ли шаблон для выдачи. Гоняет те же проверки, но
  функциональные падения (acceptance + e2e) сверяет с базлайном известных
  «красных» `preflight-baseline.txt`: падение НЕ из базлайна = регрессия (валит),
  внезапно зелёная из базлайна = стаб решён/тест ослаб (тоже валит — обновить
  `just preflight-baseline`). Плюс гигиена (`_handoff-clean`), сборка гайда,
  `outdatty check`. Сбор падений — `_failures` (TAP от hurl + JSON от playwright →
  нормализованный `var/preflight/failures.txt`). Параллельно (GNU parallel),
  юнит — после lint (общая установка зависимостей). На master гоняет
  `preflight.yml` с guard `github.repository == 'maximaster/practice'`.
- Базлайн `preflight-baseline.txt` (в корне, коммитится) — список файлов
  приёмки и заголовков e2e, которые шаблон намеренно не проходит. Меняете состав
  стабов/спеков — `just preflight-baseline` и коммит результата. Гранулярность:
  acceptance — по файлу (`.hurl`), e2e — по заголовку теста.
- `outdatty check` вынесен в рецепт `just docs-sync`; на PR его дублирует
  `docs-sync.yml` (drift до мержа), master закрыт preflight'ом. После правок
  источников из `outdatty.yaml` (Justfile, devbox.json, compose.yaml, схемы
  и т.д.) — `outdatty update`, иначе гейт красный.
- Студенты работают в отдельной ветке (verify на ветках/PR, не на master) —
  отражено в гайде (`www/content/task.typ`).
- Анализаторы в `just lint` гоняются параллельно после установки зависимостей.
  GNU parallel — в devbox; `_parallel-cite` гасит баннер цитирования.

## Правила

- Conventional Commits на русском, без футеров.
- LOGBOOK.md не править — заполняется человеком. Логи переписки с ИИ туда не добавлять.
