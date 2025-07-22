Welcome in the airboltic data modeling project.

The project is constituted of :

some csv files in the seeds folder that include all of the sources.
some tables in the models folder that constitute all the data modeling for the project. The tables are described in the yml files, as well as the report pdf.
Steps to run the project:

make sure you have docker and pgsql 16 installed
create a local empty pgsql database : Windows powershell : docker run -d --name airboltic -e POSTGRES_USER= -e POSTGRES_PASSWORD= -e POSTGRES_DB=airboltic_db -p 5432:5432 postgres:16
make sure you have python and dbt installed and configured
adapt the profiles.yml file to connect to the database
run dbt build. This will create the sources, and the tables from the models, as well as running the tests.
The tables will appear in the airboltic database
