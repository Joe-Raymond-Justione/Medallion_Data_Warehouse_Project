-- Docs: https://docs.mage.ai/guides/sql-blocks

-- Keeping only the latest rows for each product (dropping historical informations here). Also removed the metadata columns.
-- Giving user friendly names for the columns.
-- Adding surrogate key.
-- Ordering the columns by groups
-- Creating a view in BigQuery and exporting the data to Gold Layer.
CREATE SCHEMA IF NOT EXISTS `moonlit-grail-469521-n4.Gold_Layer_DW`;
CREATE OR REPLACE VIEW `moonlit-grail-469521-n4.Gold_Layer_DW.dim_product_view` AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcta       AS subcategory,
    pc.MAINTENANCE  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM `moonlit-grail-469521-n4.Silver_Layer_DW.crm_prd_info` pn
LEFT JOIN `moonlit-grail-469521-n4.Silver_Layer_DW.erp_px_cat` pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;