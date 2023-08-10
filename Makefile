ifneq (,$(wildcard ./.env))
   include .env
   export
   ENV_FILE_PARAM = --env-file .env
endif

RED ?= \033[0;31m
GREEN ?= \033[0;32m
YELLOW ?= \033[0;33m
BLUE ?= \033[0;34m
PURPLE ?= \033[0;35m

.PHONY: all help build build-with-no-cache start-django start-django-detached stop-django delete-volumes makemigrations migrate create-superuser create-test-admin load-gis-data test-people test-locator-api code-format-check code-format print-logs print-interactive-logs

help:
	@echo -e "\n$(WHITE)Available commands:$(COFF)"
	@echo -e "$(CYAN)make build$(COFF)                          		- Builds or rebuilds services"

build:
	@echo -e "$(CYAN)Building images:$(COFF)"
	@docker-compose -f docker-compose.dev.yml build

build-with-no-cache:
	@echo -e "$(CYAN)Building images with no cache:$(COFF)"
	@docker-compose -f docker-compose.dev.yml build --no-cache

start-django:
	@echo -e "$(CYAN)Starting Django backend service:$(COFF)"
	@docker-compose -f docker-compose.dev.yml up

start-django-detached:
	@echo -e "$(CYAN)Starting Django backend service in the background:$(COFF)"
	@docker-compose -f docker-compose.dev.yml up -d

stop-django:
	@echo -e "$(CYAN)Stopping Django backend service:$(COFF)"
	@docker-compose -f docker-compose.dev.yml down

delete-volumes:
	@echo -e "$(CYAN)Deleting volumes for Django and DB:$(COFF)"
	@docker-compose -f docker-compose.dev.yml down --volumes

makemigrations:
	@echo -e "$(CYAN)Make Django migrations:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py makemigrations $(cmd)

migrate:
	@echo -e "$(CYAN)Update database schema from Django migrations:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py migrate $(cmd)


create-superuser:
	@echo -e "$(CYAN)Create superuser for the backend admin:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py createsuperuser $(cmd)

create-test-admin:
	@echo -e "$(CYAN)Create default backend admin:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py loaddata people/fixtures/geoadmin.json

load-gis-data:
	@echo -e "$(CYAN)Populate DB with GIS data:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py shell -c "from data import load_locations;load_locations.run()"

test-people:
	@echo -e "$(CYAN)Run tests on people Django app:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py test people $(cmd)

test-locator-api:
	@echo -e "$(CYAN)Run tests on locator_api Django app:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py test locator_api $(cmd)

code-format-check:
	@echo -e "$(CYAN)Run black formatter check:$(COFF)"
	@python black --check . $(cmd)

code-format:
	@echo -e "$(CYAN)Lint code with black formatter:$(COFF)"
	@docker-compose -f docker-compose.dev.yml down python black . $(cmd)

print-logs:
	@echo -e "$(CYAN)Print out logs:$(COFF)"
	@docker-compose -f docker-compose.dev.yml django logs$(cmd)

print-interactive-logs:
	@echo -e "$(CYAN)Print out logs:$(COFF)"
	@docker-compose -f docker-compose.dev.yml django logs --follow $(cmd)
