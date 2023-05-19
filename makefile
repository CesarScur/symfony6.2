all: build composer_install

build:
	docker compose build
	docker compose up -d

composer_install:
	docker compose exec php composer install

watch:
	docker compose exec php npm install
	docker compose run -d --rm --name encore_watch php npm run watch
