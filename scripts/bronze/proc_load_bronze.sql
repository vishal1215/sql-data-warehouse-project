/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.
    - Records a row in dbo.load_audit for every table loaded (success or failure),
      grouped by a run_id so one EXEC's audit trail can be queried together.

Parameters:
    None.
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	DECLARE @run_id UNIQUEIDENTIFIER = NEWID();
	DECLARE @current_table NVARCHAR(128);
	DECLARE @rows INT;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		SET @current_table = 'bronze.crm_cust_info';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM '/var/opt/mssql/import/dwh_project/datasets/source_crm/cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @rows = @@ROWCOUNT;
		SET @end_time = GETDATE();
		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, @end_time, DATEDIFF(MILLISECOND, @start_time, @end_time), @rows, 'SUCCESS');
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @current_table = 'bronze.crm_prd_info';
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM '/var/opt/mssql/import/dwh_project/datasets/source_crm/prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @rows = @@ROWCOUNT;
		SET @end_time = GETDATE();
		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, @end_time, DATEDIFF(MILLISECOND, @start_time, @end_time), @rows, 'SUCCESS');
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @current_table = 'bronze.crm_sales_details';
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM '/var/opt/mssql/import/dwh_project/datasets/source_crm/sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @rows = @@ROWCOUNT;
		SET @end_time = GETDATE();
		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, @end_time, DATEDIFF(MILLISECOND, @start_time, @end_time), @rows, 'SUCCESS');
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

		SET @current_table = 'bronze.erp_loc_a101';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM '/var/opt/mssql/import/dwh_project/datasets/source_erp/LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @rows = @@ROWCOUNT;
		SET @end_time = GETDATE();
		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, @end_time, DATEDIFF(MILLISECOND, @start_time, @end_time), @rows, 'SUCCESS');
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @current_table = 'bronze.erp_cust_az12';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM '/var/opt/mssql/import/dwh_project/datasets/source_erp/CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @rows = @@ROWCOUNT;
		SET @end_time = GETDATE();
		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, @end_time, DATEDIFF(MILLISECOND, @start_time, @end_time), @rows, 'SUCCESS');
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @current_table = 'bronze.erp_px_cat_g1v2';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM '/var/opt/mssql/import/dwh_project/datasets/source_erp/PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @rows = @@ROWCOUNT;
		SET @end_time = GETDATE();
		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, @end_time, DATEDIFF(MILLISECOND, @start_time, @end_time), @rows, 'SUCCESS');
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==========================================';

		INSERT INTO dbo.load_audit (run_id, layer, procedure_name, table_name, start_time, end_time, duration_ms, rows_affected, status, error_message)
		VALUES (@run_id, 'bronze', 'bronze.load_bronze', @current_table, @start_time, GETDATE(), DATEDIFF(MILLISECOND, @start_time, GETDATE()), NULL, 'FAILED', ERROR_MESSAGE());

		THROW;
	END CATCH
END
