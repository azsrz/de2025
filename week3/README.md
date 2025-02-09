## load data to GCS


## create external table
~~~CREATE OR REPLACE EXTERNAL TABLE `sinuous-gist-448417-j9.nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://nytaxi/yellow/yellow_tripdata_2024-*.parquet']
);
~~~

## Question 1. Count of records for the 2024 Yellow Taxi Data
It is saved in storage infomation of the table: 20,332,093

## create materialized table

~~~
CREATE OR REPLACE TABLE sinuous-gist-448417-j9.nytaxi.yellow_tripdata_non_partitoned AS
SELECT * FROM sinuous-gist-448417-j9.nytaxi.external_yellow_tripdata;
~~~

## read PULocationID
~~~
-- 155.12MB estimated read
SELECT PULocationID FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_non_partitoned;
~~~

## read PULocationID, DOLocationID
~~~
-- 310.24MB estimated read
SELECT PULocationID, DOLocationID FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_non_partitoned;
~~~

## count zero fare_amount
~~~
-- 8333 trips have zero fare_amount
SELECT COUNT(1) FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_non_partitoned WHERE fare_amount = 0;
~~~

## create a parition table
~~~
-- Creating a partition and cluster table
CREATE OR REPLACE TABLE sinuous-gist-448417-j9.nytaxi.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM sinuous-gist-448417-j9.nytaxi.external_yellow_tripdata;
~~~
## get distinct VendorID
~~~
-- 1, 2 26.84MB
SELECT DISTINCT VendorID FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_partitoned_clustered WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' AND DATE(tpep_dropoff_datetime) <= '2024-03-15';

-- 310.24MB
SELECT DISTINCT VendorID FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_non_partitoned WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' AND DATE(tpep_dropoff_datetime) <= '2024-03-15';
~~~

## It is not the best practice to always cluster
- clustering adds overhead during data writes and table maintainence
- The performance gain is negligible for small tables
- It also depends on the type of query you want to perform 

## get number of rows
#### the number of rows are already cached (storage information) so no need to read the table
~~~
-- 0B
SELECT COUNT(*) FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_partitoned_clustered;
-- 0B
SELECT COUNT(*) FROM sinuous-gist-448417-j9.nytaxi.yellow_tripdata_non_partitoned;
~~~