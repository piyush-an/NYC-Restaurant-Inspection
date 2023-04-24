#!/usr/bin/python3
from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from airflow.models.param import Param
from datetime import timedelta
import pandas as pd
import os
from sqlalchemy import create_engine
from great_expectations_provider.operators.great_expectations import GreatExpectationsOperator
from great_expectations.data_context.types.base import (
    DataContextConfig,
    CheckpointConfig
)
from airflow.utils.task_group import TaskGroup
from airflow.utils.edgemodifier import Label

base_path = "/opt/airflow/great_expectations"
BASE_URL = os.getenv("DB_URL", "postgresql://root:root@db:5432/nyc")

dag = DAG(
    dag_id="load_all_data",
    schedule="0 0 * * *",   # https://crontab.guru/
    start_date=days_ago(0),
    catchup=False,
    dagrun_timeout=timedelta(minutes=30),
    tags=["zoomcamp", "2023"],
)


def load_into_raw_staging(**kwargs):
    """
        Download latest csv file and load it into stg table
    """
    # create a db connection
    engine = create_engine(BASE_URL)
    engine.connect()

    # read from uel with this schema
    dtypes = {
        'CAMIS': 'Int64',
        'DBA': 'object',
        'BORO': 'object',
        'BUILDING': 'object',
        'STREET': 'object',
        'ZIPCODE': 'object',
        'PHONE': 'object',
        'CUISINE DESCRIPTION': 'object',
        'INSPECTION DATE': 'object',
        'ACTION': 'object',
        'VIOLATION CODE': 'object',
        'VIOLATION DESCRIPTION': 'object',
        'CRITICAL FLAG': 'object',
        'SCORE': 'Int64',
        'GRADE': 'object',
        'GRADE DATE': 'object',
        'RECORD DATE': 'object',
        'INSPECTION TYPE': 'object',
        'Latitude': 'float64',
        'Longitude': 'float64',
        'Community Board': 'Int64',
        'Council District': 'Int64',
        'Census Tract': 'Int64',
        'BIN': 'Int64',
        'BBL': 'Int64',
        'NTA': 'object'
    }
    df = pd.read_csv("https://data.cityofnewyork.us/api/views/43nn-pn8j/rows.csv", dtype=dtypes)

    # column name lowercase and whitespace removal
    df.columns = map(str.lower, df.columns)
    df.columns = df.columns.str.replace(' ', '_')

    # change of datetime column into dates
    df.inspection_date = pd.to_datetime(df.inspection_date).dt.date
    df.grade_date = pd.to_datetime(df.grade_date).dt.date

    # audit column with current datetime
    df.record_date = pd.Timestamp('now')

    # write to postgres db
    df.to_sql(name='raw_stg_food_inspection', con=engine, schema='staging', index=False, if_exists='replace')


def load_into_staging(**kwargs):
    """
        Load data from raw stag to staging
    """
    # create a db connection
    engine = create_engine(BASE_URL)
    conn = engine.connect()

    # read raw_stg table
    df = pd.read_sql_table(table_name="raw_stg_food_inspection", con=engine, schema='staging')

    # write to stg table
    df.to_sql(name='stg_food_inspection', schema='staging', con=engine, index=False, if_exists='replace')


with dag:

    load_into_raw_staging = PythonOperator(   
        task_id='load_into_raw_staging',
        python_callable = load_into_raw_staging,
        provide_context=True,
        dag=dag,
    )

    great_expectation_reports = GreatExpectationsOperator(
        task_id="great_expectation_reports",
        data_context_root_dir=base_path,
        checkpoint_name="nyc_food_inspection_v05",
        fail_task_on_validation_failure=True
    )

    load_into_staging = PythonOperator(   
        task_id='load_into_staging',
        python_callable = load_into_staging,
        provide_context=True,
        dag=dag,
    )

    with TaskGroup(group_id="dbt_etl") as dbt_etl:
        dbt_project_path_export = BashOperator(
        task_id="dbt_project_path_export",
        bash_command='export DBT_PROFILES_DIR=/opt/airflow/dbt_nyc'
        )

        dbt_dep_install = BashOperator(
        task_id="dbt_dep_install",
        bash_command='cd /opt/airflow/dbt_nyc;  dbt deps'
        )

        dbt_run_build = BashOperator(
        task_id="dbt_run_build",
        bash_command="cd /opt/airflow/dbt_nyc;  dbt build --var 'is_test_run: false'"
        )

        dbt_project_path_export >> dbt_dep_install >> dbt_run_build


    # Flow
    load_into_raw_staging >> Label("Data Quality Check") >> great_expectation_reports >> Label("Data Loading") >> load_into_staging >> dbt_etl