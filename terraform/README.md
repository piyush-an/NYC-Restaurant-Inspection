## Cloud Deployment

### Prerequisite
1. Install terraform - [download](https://developer.hashicorp.com/terraform/downloads)
2. GCP Cloud Account

### Resources Provisioned
* Compute Instance of the type `e2-standard-4`
* OS : Ubuntu
* Disk Size 50 GB
* Assign's static IP
* Firewall rules on port `"80", "8080", "8086", "3000", "8095"` to enable traffic
* Install docker using the install script, refer [install.sh](./install.sh)


### Instruction

1. Change working directory to `terraform`

2. Generate SSH key pair
    ```
    ssh-keygen -t rsa -f ce -C ubuntu -b 2048
    ```
    Press `enter` for the `Enter passphrase (empty for no passphrase):` prompt </br>This generates the public and private SSH key pair file name `ce`

    Expected Output:
    ```bash
    $ ls -l ce*
    -rw------- 1 anku anku 1811 Apr 24 21:43 ce
    -rw-r--r-- 1 anku anku  388 Apr 24 21:43 ce.pub
    ```

3. Login into GCP Cloud, create a new Service Account and download the key as JSON file</br>
   Role : Compute Admin </br>
   Copy the contents of the key into `tfkey.json` in current directory

4. Define the variables in the `terraform.tfvars` file
    ```bash
    # terraform.tfvars
    
    project_id = "vertical-set-375108"
    region = "us-east1"
    zone = "us-east1-b"
    name = "nyc-food-inspection"
    ssh_key_filename = "ce"
    machine_type = "e2-standard-4"
    ```

5. Run the terraform init command
   ```bash
    terrform init
   ```

   Expected Output:
   ```bash
   Terraform has been successfully initialized!
   ```

6. Run the terraform plan command
    ```bash
    terraform plan
    ```
    Expect Output:
    ```bash
    Plan: 3 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
    + ExternalIP = (known after apply)
    ```

7. Run the terraform apply command
    ```bash
    terraform apply
    ```
    Enter `yes` to confirm the execution
    Expect Output:
    ```bash
    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

    Outputs:
    ExternalIP = "34.139.43.201"
    ```

    > Note: Going forward replace `34.139.43.201` with the IP returned for your instance.

8.  SSH into the instance using the ssh key generated previously
    ```
    ssh -i ce ubuntu@34.139.43.201
    ```
    Enter `yes` in the prompt `Are you sure you want to continue connecting (yes/no/[fingerprint])?`

9. Clone the repository in local
    ```bash
    git clone https://github.com/piyush-an/NYC-Restaurant-Inspection.git
    ```
    Change working directory to `NYC-Restaurant-Inspection`

10. Check docker is running

    Command:
    ```bash
    docker --version
    ```
    Expected Output:
    ```bash
    $ docker --version
    Docker version 23.0.4, build f480fb1
    ```

11. Using the make utility to initialize env file
    ```bash
    make create-env
    ```
    This create an `.env` file for docker compose with content as
    ```
    AIRFLOW_UID=1000
    AIRFLOW_PROJ_DIR=./airflow
    ```
12. Create directories for airflow containers
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

13. Initialize the database containers
    ```bash
    make init
    ```
    This downloads the docker images and initialize database containers

14. Load the `metabase` database using the dump file
    ```bash
    make db-init
    ```
    This recreates the metabase database for visualization

15. Start the docker services 
    ```bash
    make start
    ```
    This takes a couple of minutes (approx 5 mins) for the services to be at Healthy status, Verify the status using 
    ```bash
    docker ps
    ```

16. Login in into Airflow

    URL: http://34.139.43.201:8080/ </br>
    Username: `airflow` </br>
    Password: `airflow`

17. Trigger the `load_all_data` DAG

    <img src=../images/run_dag.PNG width="100%" height="100%">

    This runs the data pipeline (run time approx 12 mins)

    <img src=../images/dags.PNG width="100%" height="100%">

    1. **Data Sourcing** - Read the csv file from the opendata url and loads the data into `raw_stg_food_inspection` table
    
    2. **Data Quality Check** - The ingested data is passed thru data quality check for NOT NULL values for specific columns. The reports can be access on http://34.139.43.201:8086/ . If the check passes data is loaded into `stg_food_inspection` table
    
    3. **Data Loading** - Using dbt core, data is loaded into dim and fact tables

18. Open Visualization Admin
    
    URL: http://34.139.43.201:3080/ </br>
    Username: `test@gmail.com` </br>
    Password: `password@123`

    or Visit URL to view the dashboard directly</br>
    URL : http://34.139.43.201:3000/public/dashboard/4607f075-bf4f-44cb-bbc4-168b69594788

19. To stop all the container
    ```bash
    make down
    ```

20. To stop all the container and delete the volumes
    ```bash
    make clean
    ```

21. Close the connection to the instance
    ```bash
    exit
    ```

22. Delete the cloud resources using the terraform delete command
    ```bash
    terraform destroy
    ```
    Enter `yes` to confirm the execution

    Expected Output:
    ```bash
    Destroy complete! Resources: 3 destroyed.
    ```

