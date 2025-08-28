-- Docs: https://docs.mage.ai/guides/sql-blocks
CREATE OR REPLACE TABLE `moonlit-grail-469521-n4.Silver_Layer_DW.erp_px_cat` AS
SELECT
ID as id,
CAT as cat,
SUBCAT as subcta,	
MAINTENANCE as MAINTENANCE,
CURRENT_TIMESTAMP() AS record_inserted_at
FROM `moonlit-grail-469521-n4.Bronze_Layer_DW.erp_px_cat`