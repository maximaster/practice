# Практика

Привет! Этот репозиторий содержит задание для практики. Что нужно сделать,
бриф заказчика, структура репозитория и что прислать — всё в гайде:
https://maximaster.github.io/practice/ (локально: `just guide-serve`).

## Требования к окружению

Нужны `git`, `docker` и [devbox](https://www.jetify.com/devbox).
Остальные инструменты устанавливаются с помощью последнего.
Выполните `devbox shell` и вам будет доступен весь нужный софт.

## Работа с репозиторием

Вызовите `just --list`, чтобы увидеть список доступных команд для работы с проектом.
Изучите [Justfile](Justfile), чтобы понять как именно работают эти команды.

После запуска будут доступны:

- Backend: `http://localhost:8080` (PHP 8.5, Slim 4, Cycle ORM, SQLite; id — UUIDv7)
- Frontend: `http://localhost:5173` (TypeScript + Vite)

## Качество кода

Статанализ настроен строго и входит в `just verify` (то же гоняет CI):
backend — php-cs-fixer, PHPStan (max + strict), PHPMD, Rector; frontend —
ESLint (type-aware, strict), Prettier, `tsc`. Юнит-тесты (`just test`) —
Testo (backend) и Vitest (frontend).

- `just lint` — проверить всё, не поднимая приложение.
- `just fmt` — автоформат и безопасные автоправки.

## Производительность

Сервер заказчика скромный, поэтому бэкенд запускается с лимитом памяти
`memory_limit=96M`, а контейнер ограничен `mem_limit=256m` (см. `compose.yaml`).
Функциональные тесты должны проходить в этих рамках. Каждый ответ отдаёт
`Server-Timing` и `X-DB-Query-Count` — по ним видно время и число запросов к БД
(метрики наблюдаются, но сборку не гейтят).
