# Data Loading using dbt core

## Starter Code

1. Create a python virtual environment
    ```bash
    python -m venv .venv
    ```

2. Activate the virtual environment
    ```bash
    source .venv/bin/activate
    ``` 

3. Install the dependency
    ```bash
    pip install -r requirements.txt
    ``` 

4. Export the current working directory as the env variable for dbt
    ```bash
    export DBT_PROFILES_DIR=`pwd`/
    export PROJECT_DIR=`pwd`/
    ``` 

5. Install dbt dependency
    ```bash
    dbt deps
    ``` 

6. 


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
