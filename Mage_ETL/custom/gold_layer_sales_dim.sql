-- Docs: https://docs.mage.ai/guides/sql-blocks
-- Giving user friendly names for the columns.
-- Adding surrogate key from the Dimension Tables so the dimensions can be connected with the fact table.
-- Ordering the columns by groups
-- Creating a view in BigQuery and exporting the data to Gold Layer.

CREATE OR REPLACE VIEW `moonlit-grail-469521-n4.Gold_Layer_DW.fact_sales_view` AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM `moonlit-grail-469521-n4.Silver_Layer_DW.crm_sales_details` sd
LEFT JOIN `moonlit-grail-469521-n4.Gold_Layer_DW.dim_product_view` pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN `moonlit-grail-469521-n4.Gold_Layer_DW.dim_customer_view` cu
    ON sd.sls_cust_id = cu.customer_id
ORDER BY product_key;