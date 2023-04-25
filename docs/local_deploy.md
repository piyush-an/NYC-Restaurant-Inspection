## Reproducing on local

### Prerequisite
1. Docker Desktop - [download](https://www.docker.com/products/docker-desktop/)
2. Git / Github Desktop
3. Min 8 GB RAM allocated to docker

### Instruction
1. Open Terminal (Mac) or Ubuntu (WSL on Windows)
2. Clone the repository in local
    ```bash
    git clone https://github.com/piyush-an/NYC-Restaurant-Inspection.git
    ```
    Alternatively, download the repo as a zip file and unzip in destination folder
3. Check docker is running

    Command:
    ```bash
    docker --version
    ```
    Expected Output:
    ```bash
    $ docker --version
    Docker version 20.10.24, build 297e128
    ```
4. Using the make utility to initialize env file
    ```bash
    make create-env
    ```
    This create an `.env` file for docker compose with content as
    ```
    AIRFLOW_UID=1000
    AIRFLOW_PROJ_DIR=./airflow
    ```
5. Create directories for airflow containers
    ```bash
    make create-dirs
    ```
    This create the three directories under airflow
    ```bash
    airflow/
    ├── dags
    ├── logs
    └── plugins
    ```
6. Initialize the database containers
    ```bash
    make init
    ```
    This downloads the docker images and initialize database containers
7. Load the `metabase` database using the dump file
    ```bash
    make db-init
    ```
    This recreates the metabase database for visualization
8. Start the docker services 
    ```bash
    make start
    ```
    This takes a couple of minutes (approx 5 mins) for the services to be at Healthy status, Verify the status using 
    ```bash
    docker ps
    ```
    Expected Output:
    ```
    CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS                   PORTS                           NAMES
    9409497d0150   apache/airflow:2.5.1       "/usr/bin/dumb-init …"   3 minutes ago   Up 2 minutes (healthy)   0.0.0.0:8080->8080/tcp          nyc-results-airflow-webserver-1
    1b29b0bd3660   apache/airflow:2.5.1       "/usr/bin/dumb-init …"   3 minutes ago   Up 2 minutes (healthy)   8080/tcp                        nyc-results-airflow-worker-1
    9862a0946762   apache/airflow:2.5.1       "/usr/bin/dumb-init …"   3 minutes ago   Up 2 minutes (healthy)   8080/tcp                        nyc-results-airflow-triggerer-1
    de8ca458cb01   apache/airflow:2.5.1       "/usr/bin/dumb-init …"   3 minutes ago   Up 2 minutes (healthy)   8080/tcp                        nyc-results-airflow-scheduler-1
    55d0420cee3f   dpage/pgadmin4             "/entrypoint.sh"         3 minutes ago   Up 3 minutes             443/tcp, 0.0.0.0:8095->80/tcp   pgadmin
    554e7593d62d   metabase/metabase:latest   "/app/run_metabase.sh"   3 minutes ago   Up 3 minutes (healthy)   0.0.0.0:3000->3000/tcp          metabase
    0cd9d417c504   nginx                      "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes             0.0.0.0:8086->80/tcp            nginx
    bc8dc96ef353   redis:latest               "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes (healthy)   6379/tcp                        nyc-results-redis-1
    ad14fc89b6b1   postgres:13                "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes (healthy)   0.0.0.0:5432->5432/tcp          db
    4f6a466724d6   postgres:13                "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes (healthy)   5432/tcp                        nyc-results-postgres-1
    ```
9.  Login in into Airflow

    URL: http://localhost:8080/ </br>
    Username: `airflow` </br>
    Password: `airflow`

10. Trigger the `load_all_data` DAG

    <img src=../images/run_dag.PNG width="800" height="400">

    This runs the data pipeline (run time approx 12 mins)

    <img src=../images/dags.PNG width="100%" height="100%">

    1. **Data Sourcing** - Read the csv file from the opendata url and loads the data into `raw_stg_food_inspection` table
    
    2. **Data Quality Check** - The ingested data is passed thru data quality check for NOT NULL values for specific columns. The reports can be access on http://localhost:8086/ . If the check passes data is loaded into `stg_food_inspection` table
    
    3. **Data Loading** - Using dbt core, data is loaded into dim and fact tables
11. Open Visualization Admin
    
    URL: http://localhost:3080/ </br>
    Username: `test@gmail.com` </br>
    Password: `password@123`

    or Visit URL to view the dashboard directly</br>
    URL : http://localhost:3000/public/dashboard/4607f075-bf4f-44cb-bbc4-168b69594788
12. To stop all the container
    ```bash
    make down
    ```
13. To stop all the container and delete the volumes
    ```bash
    make clean
    ``` 
