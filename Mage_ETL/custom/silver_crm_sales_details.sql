CREATE OR REPLACE TABLE `moonlit-grail-469521-n4.Silver_Layer_DW.crm_sales_details` AS
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
        WHEN sls_order_dt = 0 OR LENGTH(CAST(sls_order_dt AS STRING)) != 8 THEN NULL
        ELSE SAFE.PARSE_DATE('%Y%m%d', CAST(sls_order_dt AS STRING))
    END AS sls_order_dt,
    CASE 
        WHEN sls_ship_dt = 0 OR LENGTH(CAST(sls_ship_dt AS STRING)) != 8 THEN NULL
        ELSE SAFE.PARSE_DATE('%Y%m%d', CAST(sls_ship_dt AS STRING))
    END AS sls_ship_dt,
    CASE 
        WHEN sls_due_dt = 0 OR LENGTH(CAST(sls_due_dt AS STRING)) != 8 THEN NULL
        ELSE SAFE.PARSE_DATE('%Y%m%d', CAST(sls_due_dt AS STRING))
    END AS sls_due_dt,
    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price,
    CURRENT_TIMESTAMP() AS record_inserted_at
FROM `moonlit-grail-469521-n4.Bronze_Layer_DW.crm_sales_details`;