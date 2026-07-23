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
