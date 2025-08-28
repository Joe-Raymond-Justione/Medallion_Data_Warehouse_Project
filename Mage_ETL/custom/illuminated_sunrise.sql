-- Docs: https://docs.mage.ai/guides/sql-blocks
CREATE OR REPLACE TABLE `moonlit-grail-469521-n4.Silver_Layer_DW.erp_cust` AS
SELECT
    -- Remove 'NAS' prefix if present
    CASE
        WHEN CID LIKE 'NAS%' THEN SUBSTR(CID, 4)  
        ELSE CID
    END AS cid, 

    -- Set future birthdates to NULL
    CASE
        WHEN BDATE > CURRENT_DATE() THEN NULL
        ELSE BDATE
    END AS bdate, 

    -- Normalize gender values
    CASE
        WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen,
    CURRENT_TIMESTAMP() AS record_inserted_at

FROM `moonlit-grail-469521-n4.Bronze_Layer_DW.erp_cust`;
