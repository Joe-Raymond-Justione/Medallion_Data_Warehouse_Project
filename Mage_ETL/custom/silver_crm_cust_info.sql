-- Docs: https://docs.mage.ai/guides/sql-blocks
-- Creating the Silver Layer dataset 
CREATE SCHEMA IF NOT EXISTS `moonlit-grail-469521-n4.Silver_Layer_DW`;

-- Creating a new table in Silver layer 
CREATE OR REPLACE TABLE `moonlit-grail-469521-n4.Silver_Layer_DW.crm_cust_info` AS

-- Data Quality Checks:
-- 1. There are duplicates in cst_id. They are ordered by lastest date in 'cst_create_date' and duplicates rows are removed. 
-- Also records with null in cst_id are dropped.
WITH no_duplicates AS (
  SELECT *
  FROM (
    SELECT 
        CAST(cst_id AS INT64) AS cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        TRIM(cst_marital_status) AS cst_marital_status,
        TRIM(cst_gndr) AS cst_gndr,
        cst_create_date,
        ROW_NUMBER() OVER (
            PARTITION BY CAST(cst_id AS INT64) 
            ORDER BY cst_create_date DESC
        ) AS rn
    FROM `moonlit-grail-469521-n4.Bronze_Layer_DW.crm_cust_info`
    WHERE CAST(cst_id AS INT64) IS NOT NULL
  )
  WHERE rn = 1
),

-- 2. Data Standardization: Stripping spaces before and after all strings and converting 'cst_marital_status' and 'cst_gndr' into full forms.
standardized_data AS (
  SELECT 
      cst_id,
      cst_key,
      cst_firstname,
      cst_lastname,
      CASE 
         WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
         WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
         ELSE 'n/a' 
      END AS cst_marital_status,
      CASE 
         WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
         WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
         ELSE 'n/a' 
      END AS cst_gndr,
      cst_create_date,
      CURRENT_TIMESTAMP() AS record_inserted_at
  FROM no_duplicates
)

SELECT * 
FROM standardized_data;
