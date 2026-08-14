.PHONY: setup up dev stop down restart logs test lint ci compose-lint-ci compose-test-ci

# Подготовка проекта: сборка образов и установка зависимостей
setup:
	docker-compose run --rm app make setup

# Запуск
up:
	docker compose up -d

dev:
	docker compose up

stop:
	docker compose stop

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

# Тесты и линтер (внутри Docker, на production-образе)
test:
	docker-compose -f docker-compose.yml run --rm app make test

lint:
	docker-compose -f docker-compose.yml run --rm app make lint

# CI: пересборка + линтер + тесты
ci:
	docker compose -f docker-compose.yml down -v --remove-orphans
	docker compose -f docker-compose.yml build
	make compose-lint-ci compose-test-ci

compose-lint-ci:
	docker compose -f docker-compose.yml run --rm app make lint

compose-test-ci:
	docker compose -f docker-compose.yml run --rm app make test
