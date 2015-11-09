-- Telecom CDR Data Warehouse (Hive)

-- Create database
CREATE DATABASE IF NOT EXISTS telecom_dw;
USE telecom_dw;

-- CDR Raw Table (External)
CREATE EXTERNAL TABLE IF NOT EXISTS cdr_raw (
    call_id STRING,
    calling_number STRING,
    called_number STRING,
    call_start_time TIMESTAMP,
    call_end_time TIMESTAMP,
    duration INT,
    call_type STRING,
    cell_tower_id STRING,
    imei STRING,
    imsi STRING,
    location_lat DOUBLE,
    location_lon DOUBLE
)
PARTITIONED BY (year INT, month INT, day INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/telecom/cdr_raw';

-- CDR Processed Table (ORC)
CREATE TABLE IF NOT EXISTS cdr_processed (
    call_id STRING,
    calling_number_hash STRING,
    called_number_hash STRING,
    call_start_time TIMESTAMP,
    call_duration INT,
    call_type STRING,
    cell_tower_id STRING,
    location_area STRING,
    hour_of_day INT,
    day_of_week INT,
    is_roaming BOOLEAN,
    is_international BOOLEAN
)
PARTITIONED BY (year INT, month INT)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

-- Customer Dimension
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id STRING,
    phone_number_hash STRING,
    customer_segment STRING,
    plan_type STRING,
    activation_date DATE,
    is_active BOOLEAN
)
STORED AS ORC;

-- Usage Summary Table
CREATE TABLE IF NOT EXISTS fact_daily_usage (
    customer_id STRING,
    usage_date DATE,
    total_calls INT,
    total_minutes INT,
    total_sms INT,
    total_data_mb BIGINT,
    revenue DECIMAL(10,2)
)
PARTITIONED BY (year INT, month INT)
STORED AS ORC;
