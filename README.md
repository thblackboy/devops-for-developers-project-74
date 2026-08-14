### Hexlet tests and linter status:
[![Actions Status](https://github.com/thblackboy/devops-for-developers-project-74/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/thblackboy/devops-for-developers-project-74/actions)

[![Push Actions Status](https://github.com/thblackboy/devops-for-developers-project-74/actions/workflows/push.yml/badge.svg)](https://github.com/thblackboy/devops-for-developers-project-74/actions/workflows/push.yml)

# DevOps for Developers — Project 74

Доставка и запуск приложения [JS Fastify Blog](./app) в Docker: production-образ на Docker Hub, docker-compose для локальной разработки, CI с линтером и тестами внутри контейнеров, обратный прокси Caddy с HTTPS.

## Требования к системе

- Docker 24+
- Docker Compose v2
- GNU Make
- (опционально) Node.js 24+ — только для запуска приложения и тестов без Docker

## Образ на Docker Hub

```
thblackboy/devops-for-developers-project-74
```

Ссылка: https://hub.docker.com/r/thblackboy/devops-for-developers-project-74

## Переменные окружения

Приложение полностью конфигурируется через переменные окружения:

| Переменная           | Назначение                                        | Значение по умолчанию |
| -------------------- | ------------------------------------------------- | --------------------- |
| `NODE_ENV`           | Режим работы (`development`/`production`/`test`)  | —                     |
| `DATABASE_HOST`      | Хост БД                                           | `db`                  |
| `DATABASE_PORT`      | Порт БД                                           | `5432`                |
| `DATABASE_NAME`      | Имя БД                                            | `postgres`            |
| `DATABASE_USERNAME`  | Пользователь БД                                   | `postgres`            |
| `DATABASE_PASSWORD`  | Пароль БД                                         | `postgres`            |

В `test`-режиме используется SQLite, переменные БД не нужны. Значения для локального запуска вне Docker собраны в `app/.env.example`.

## Команды (Makefile)

Подготовка и запуск:

```bash
make setup   # собрать образы и установить зависимости приложения
make dev     # поднять стек в текущем терминале (app + db + caddy)
make up      # поднять стек в фоне
make stop    # остановить контейнеры
make down    # остановить и удалить контейнеры
make logs    # следить за логами в реальном времени
```

Тесты и линтер (запускаются внутри Docker, на production-образе):

```bash
make test    # тесты локально
make lint    # линтер локально
make ci      # полный CI-цикл: сборка + линтер + тесты
```

## Доступ к приложению

После `make dev` приложение доступно:

- напрямую: http://localhost:8080
- через Caddy с самоподписанным сертификатом: https://localhost

## Структура репозитория

- `app/` — приложение JS Fastify Blog
- `Dockerfile` — образ для разработки (без копирования исходников, монтируются через volume)
- `Dockerfile.production` — production-образ (установка зависимостей, сборка и копирование исходников)
- `docker-compose.yml` — production-конфигурация (готовый образ, без открытых портов)
- `docker-compose.override.yml` — конфигурация для разработки (локальная сборка, порты, PostgreSQL, Caddy)
- `services/caddy/` — конфигурация обратного прокси Caddy
- `.github/workflows/` — CI: сборка и публикация образа, прогон тестов и линтера

## CI

- `.github/workflows/push.yml` — на каждый push собирает и публикует production-образ на Docker Hub, затем запускает `make ci` (тесты и линтер внутри Docker).
- `.github/workflows/hexlet-check.yml` — автоматическая проверка задания на стороне Hexlet.
