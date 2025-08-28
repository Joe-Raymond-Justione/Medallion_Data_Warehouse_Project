-- -- Docs: https://docs.mage.ai/guides/sql-blocks
-- -- Creating the Silver Layer dataset 
-- CREATE SCHEMA IF NOT EXISTS `moonlit-grail-469521-n4.Silver_Layer_DW`;

-- -- Creating a new table in Silver layer 
CREATE OR REPLACE TABLE `moonlit-grail-469521-n4.Silver_Layer_DW.crm_prd_info` AS
SELECT
                prd_id,
                REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID: This is needed to join with product catagory table
                SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,     -- Extract product key: This is needed to join with sales table
                prd_nm,
                IFNULL(prd_cost, 0) AS prd_cost,
                CASE 
                    WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                    WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                    WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                    WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                    ELSE 'n/a'
                END AS prd_line, -- Map product line codes to descriptive values
                CAST(prd_start_dt AS DATE) AS prd_start_dt,
                DATE_SUB(LEAD(CAST(prd_start_dt AS DATE)) 
                OVER (PARTITION BY prd_key 
                ORDER BY CAST(prd_start_dt AS DATE)),
                INTERVAL 1 DAY) AS prd_end_dt, -- Calculating end date as one day before the next start date
                CURRENT_TIMESTAMP() AS record_inserted_at
            FROM `moonlit-grail-469521-n4.Bronze_Layer_DW.crm_prd_info`
            ORDER BY prd_id;