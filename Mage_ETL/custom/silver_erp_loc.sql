-- Docs: https://docs.mage.ai/guides/sql-blocks
CREATE OR REPLACE TABLE `moonlit-grail-469521-n4.Silver_Layer_DW.erp_loc` AS
SELECT
    -- Remove dashes from cid
    REPLACE(CID, '-', '') AS cid,

    -- Normalize country codes and handle missing/blank values
    CASE
        WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
        WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
        ELSE TRIM(CNTRY)
    END AS cntry,
    CURRENT_TIMESTAMP() AS record_inserted_at

FROM `moonlit-grail-469521-n4.Bronze_Layer_DW.erp_loc`;
