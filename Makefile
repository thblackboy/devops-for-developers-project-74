ci:
		docker compose -f docker-compose.yml down -v --remove-orphans
		docker compose -f docker-compose.yml build
		make compose-lint-ci compose-test-ci

compose-lint-ci:
	docker compose -f docker-compose.yml run app make lint

compose-test-ci:
	docker compose -f docker-compose.yml run app make test