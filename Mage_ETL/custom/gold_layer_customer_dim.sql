-- Docs: https://docs.mage.ai/guides/sql-blocks
-- Giving user friendly names for the columns.
-- Adding surrogate key.
-- Ordering the columns by groups
-- Creating a view in BigQuery and exporting the data to Gold Layer.

CREATE OR REPLACE VIEW `moonlit-grail-469521-n4.Gold_Layer_DW.dim_customer_view` AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    ci.cst_id                          AS customer_id,
    ci.cst_key                         AS customer_number,
    ci.cst_firstname                   AS first_name,
    ci.cst_lastname                    AS last_name,
    la.cntry                           AS country,
    ci.cst_marital_status              AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source for gender
        ELSE COALESCE(ca.gen, 'n/a')  			   -- Fallback to ERP data
    END                                AS gender,
    ca.bdate                           AS birthdate,
    ci.cst_create_date                 AS create_date
FROM `moonlit-grail-469521-n4.Silver_Layer_DW.crm_cust_info` ci
LEFT JOIN `moonlit-grail-469521-n4.Silver_Layer_DW.erp_cust` ca
    ON ci.cst_key = ca.cid
LEFT JOIN `moonlit-grail-469521-n4.Silver_Layer_DW.erp_loc` la
    ON ci.cst_key = la.cid;
