# week 2

## set up Kestra and Postgres DB
docker compose up -d

## Upload flow
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/postgres_taxi_scheduled.yaml

## ETL pipeline
backfill green and yellow taxi data from 2019/01/01 to 2021/07/01

## Questions 1:
file size is printed out by the extract task

## Question 2:
green_tripdata_2020-04.csv (read from label)

## Question 3 - 5:
- pgcli -h localhost -d postgres-zoomcamp -U kestr -p 5432
- Yellow taxi csv rows year 2020:\
    select COUNT(1) FROM yellow_tripdata WHERE SUBSTRING(filename, 17, 4)='2020'\
24648499
- Green taxi csv rows:\
select COUNT(1) FROM green_tripdata WHERE SUBSTRING(filename, 16, 4)='2020'\
    1734051

- Yellow taxi csv rows 2021-03:\
select COUNT(1) FROM yellow_tripdata WHERE SUBSTRING(filename, 17, 7)='2021-03'\
1925152
## Question 6:

America/New_York