all: build up

build:
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d 

down:
	docker compose -f srcs/docker-compose.yml down

ps:
	docker compose -f srcs/docker-compose.yml ps

re: down build up

clean:
	docker compose -f srcs/docker-compose.yml down
	bash ./clean.sh
	docker volume rm webroot
	docker volume rm database