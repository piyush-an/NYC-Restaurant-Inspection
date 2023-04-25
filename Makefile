COMPOSE_BASE := docker compose

create-dirs:
	mkdir -p ./airflow/dags ./airflow/logs ./airflow/plugins

create-env:
	echo "AIRFLOW_UID=`id -u`" > .env
	echo "AIRFLOW_PROJ_DIR=./airflow" >> .env

init: create-dirs create-env
	$(COMPOSE_BASE) up airflow-init -d

start:
	$(COMPOSE_BASE) up -d

down:
	$(COMPOSE_BASE) down

clean:
	$(COMPOSE_BASE) down -v

db-init:
	docker exec -i db /bin/bash -c "PGPASSWORD=root psql --username root metabase" < ./user_data/metabase-2023-04-25.sql

db-extract:
	docker exec db pg_dump -c -U root -F p -d metabase > ./user_data/metabase-$(date +%Y-%m-%d).sql
