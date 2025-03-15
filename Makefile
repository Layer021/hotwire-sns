.PHONY: all
all:
	@make init
	@make build
	@make install
	@make down

.PHONY: init
init:
	cp .env.example .env
	-docker network create enikk_docker_network

.PHONY: build
build:
	docker compose build --no-cache

.PHONY: install
install:
	docker compose run --rm web bundle install

.PHONY: run
run:
	docker compose up

.PHONY: down
down:
	docker compose down

.PHONY: migrate
migrate:
	docker compose run --rm web bundle exec dotenv ridgepole -c config/database.yml -f db/Schemafile -E development --apply --dump-with-default-fk-name
	docker compose run --rm web bundle exec dotenv ridgepole -c config/database.yml -f db/Schemafile -E test --apply --dump-with-default-fk-name

.PHONY: fixture
fixture:
	docker compose run --rm web bundle exec rake db:fixtures:load RAILS_ENV=development

.PHONY: reset-db
reset-db:
	docker compose run --rm web bundle exec rake db:drop db:create db:migrate db:seed RAILS_ENV=development
	docker compose run --rm web bundle exec rake db:drop db:create db:migrate db:seed RAILS_ENV=test
	make migrate
	make fixture

.PHONY: test
test:
	docker compose run --rm web bundle exec rspec

.PHONY: lint
lint:
	docker compose run --rm web bundle exec rubocop

.PHONY: lint-fix
lint-fix:
	docker compose run --rm web bundle exec rubocop -a
