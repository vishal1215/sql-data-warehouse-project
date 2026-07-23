/*
===============================================================================
DDL Script: Create Load Audit Table
===============================================================================
Script Purpose:
    Creates dbo.load_audit, a run-history table that both bronze.load_bronze
    and silver.load_silver write to on every table they load. This replaces
    PRINT-statement-only logging (which disappears once the session closes)
    with a queryable record of every load run: duration, row counts, and
    success/failure per table.

    Not part of the original course material — added to make load runs
    auditable and to demonstrate a pattern used in production ETL pipelines.

Usage:
    Run once after init_database.sql, before creating the bronze/silver
    load procedures.
===============================================================================
*/
USE DataWarehouse;
GO

IF OBJECT_ID('dbo.load_audit', 'U') IS NOT NULL
    DROP TABLE dbo.load_audit;
GO

CREATE TABLE dbo.load_audit (
    audit_id        INT IDENTITY(1,1) PRIMARY KEY,
    run_id          UNIQUEIDENTIFIER NOT NULL,   -- groups every table loaded by one EXEC together
    layer           NVARCHAR(10)     NOT NULL,   -- 'bronze' or 'silver'
    procedure_name  NVARCHAR(128)    NOT NULL,
    table_name      NVARCHAR(128)    NOT NULL,
    start_time      DATETIME2        NOT NULL,
    end_time        DATETIME2        NULL,
    duration_ms     INT              NULL,
    rows_affected   INT              NULL,
    status          NVARCHAR(10)     NOT NULL,   -- 'SUCCESS' or 'FAILED'
    error_message   NVARCHAR(4000)   NULL
);
GO
