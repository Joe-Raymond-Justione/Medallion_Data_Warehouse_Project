-- Docs: https://docs.mage.ai/guides/sql-blocks
SELECT cst_id, COUNT(*) as cst_id_cnt 
FROM `my-first-project-moonlit-grail-469521-n4.Bronze_Layer_DW.crm_cust_info` 
GROUP BY cst_id
HAVING COUNT(*) > 1
LIMIT 100