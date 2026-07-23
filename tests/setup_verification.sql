USE DataWarehouse;
GO

SELECT 'bronze.crm_cust_info' AS object_name, COUNT(*) AS row_count
FROM bronze.crm_cust_info
UNION ALL
SELECT 'bronze.crm_prd_info', COUNT(*) FROM bronze.crm_prd_info
UNION ALL
SELECT 'bronze.crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
UNION ALL
SELECT 'silver.crm_cust_info', COUNT(*) FROM silver.crm_cust_info
UNION ALL
SELECT 'silver.crm_prd_info', COUNT(*) FROM silver.crm_prd_info
UNION ALL
SELECT 'silver.crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL
SELECT 'gold.dim_customers', COUNT(*) FROM gold.dim_customers
UNION ALL
SELECT 'gold.dim_products', COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'gold.fact_sales', COUNT(*) FROM gold.fact_sales;
GO

SELECT DISTINCT gen
FROM silver.erp_cust_az12
ORDER BY gen;

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2
ORDER BY maintenance;
GO

-- Most recent bronze + silver load run, per table
SELECT run_id, layer, table_name, start_time, duration_ms, rows_affected, status
FROM dbo.load_audit
WHERE run_id IN (
    SELECT TOP 1 run_id FROM dbo.load_audit WHERE layer = 'bronze' ORDER BY start_time DESC
)
OR run_id IN (
    SELECT TOP 1 run_id FROM dbo.load_audit WHERE layer = 'silver' ORDER BY start_time DESC
)
ORDER BY layer, start_time;
GO
