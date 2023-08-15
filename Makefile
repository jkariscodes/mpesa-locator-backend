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

.PHONY: all help build build-with-no-cache start-django start-django-detached shell django-shell stop-django delete-django-volumes makemigrations migrate create-superuser create-test-admin load-gis-data test-people test-locator-api lint-check lint-fix coverage print-logs print-logs-interactive

help:
	@echo -e "\n$(WHITE)Available commands:$(COFF)"
	@echo -e "$(BLUE)make build$(COFF)                            - Builds or rebuilds services"
	@echo -e "$(BLUE)make build-with-no-cache$(COFF)              - Builds or rebuilds services with no cache"
	@echo -e "$(GREEN)make start-django$(COFF)                    - Starts Django service"
	@echo -e "$(GREEN)make start-django-detached$(COFF)           - Starts Django service in the background"
	@echo -e "$(PURPLE)make shell$(COFF)                          - Starts a Linux shell (bash) in the django container"
	@echo -e "$(PURPLE)make django-shell$(COFF)                   - Starts a django python shell in the django container"
	@echo -e "$(RED)make stop-django$(COFF)                       - Stops Django service"
	@echo -e "$(RED)make delete-django-volumes$(COFF)             - Deletes volumes associated with Django service"
	@echo -e "$(BLUE)make makemigrations$(COFF)                   - Runs Django's migrate command in the container"
	@echo -e "$(BLUE)make migrate$(COFF)                          - Runs Django's makemigrations command in the container"
	@echo -e "$(BLUE)make create-superuser$(COFF)                 - Runs Django's createsuperuser command in the container"
	@echo -e "$(BLUE)make create-test-admin$(COFF)                - Runs Django's fixtures to create default admin"
	@echo -e "$(BLUE)make load-gis-data$(COFF)                    - Populates PostGIS database with data"
	@echo -e "$(YELLOW)make test-people$(COFF)                    - Runs automatic tests on people Django app"
	@echo -e "$(YELLOW)make test-locator-api$(COFF)               - Runs automatic tests on locator-api Django app"
	@echo -e "$(YELLOW)make lint-check$(COFF)                     - Checks code with Black formatter"
	@echo -e "$(YELLOW)make lint-fix$(COFF)                       - Formats code with Black formatter"
	@echo -e "$(YELLOW)make coverage$(COFF)                       - Runs code test coverage calculation"
	@echo -e "$(YELLOW)make print-logs$(COFF)                     - Prints logs on the shell"
	@echo -e "$(YELLOW)make print-logs-interactive$(COFF)         - Prints interactive logs on the shell"

build:
	@echo -e "$(BLUE)Building images:$(COFF)"
	@docker-compose -f docker-compose.dev.yml build

build-with-no-cache:
	@echo -e "$(BLUE)Building images with no cache:$(COFF)"
	@docker-compose -f docker-compose.dev.yml build --no-cache

start-django:
	@echo -e "$(GREEN)Starting Django backend service:$(COFF)"
	@docker-compose -f docker-compose.dev.yml up

start-django-detached:
	@echo -e "$(GREEN)Starting Django backend service in the background:$(COFF)"
	@docker-compose -f docker-compose.dev.yml up -d

shell:
	@echo -e "$(PURPLE)Starting Linux (Bash) shell in Django:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django bash

django-shell:
	@echo -e "$(PURPLE)Starting Django-Python shell:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django ./manage.py shell

stop-django:
	@echo -e "$(RED)Stopping Django backend service:$(COFF)"
	@docker-compose -f docker-compose.dev.yml down

delete-django-volumes:
	@echo -e "$(RED)Deleting volumes for Django and PostGIS:$(COFF)"
	@docker-compose -f docker-compose.dev.yml down --volumes

makemigrations:
	@echo -e "$(BLUE)Make Django migrations:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django ./manage.py makemigrations $(cmd)

migrate:
	@echo -e "$(BLUE)Update database schema from Django migrations:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django ./manage.py migrate $(cmd)

create-superuser:
	@echo -e "$(BLUE)Create superuser for the backend admin:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django ./manage.py createsuperuser $(cmd)

create-test-admin:
	@echo -e "$(BLUE)Create default backend admin:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django ./manage.py loaddata people/fixtures/geoadmin.json

load-gis-data:
	@echo -e "$(BLUE)Populate DB with GIS data:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py shell -c "from data import load_locations;load_locations.run()"

test-people:
	@echo -e "$(YELLOW)Run tests on people Django app:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py test people $(cmd)

test-locator-api:
	@echo -e "$(YELLOW)Run tests on locator_api Django app:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django python ./manage.py test locator_api $(cmd)

test-django:
	@echo -e "$(YELLOW)Run automatic django tests:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django py.test

lint-check:
	@echo -e "$(YELLOW)Run black formatter check:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django black --check . $(cmd)

lint-fix:
	@echo -e "$(YELLOW)Lint code with black formatter:$(COFF)"
	@docker-compose -f docker-compose.dev.yml run --rm django black . $(cmd)

coverage:
	@echo -e "$(CYAN)Running automatic code coverage check for Python:$(COFF)"

print-logs:
	@echo -e "$(YELLOW)Print out logs:$(COFF)"
	@docker-compose -f docker-compose.dev.yml logs django$(cmd)

print-logs-interactive:
	@echo -e "$(YELLO)Print out logs:$(COFF)"
	@docker-compose -f docker-compose.dev.yml logs --follow django $(cmd)
