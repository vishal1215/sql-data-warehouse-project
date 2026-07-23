# SQL Data Warehouse — Mac + Docker Setup

This edition keeps the tutor's original project structure while making it work with SQL Server in Docker on macOS.

## What is already corrected

- All six `BULK INSERT` paths use the Linux path inside the container.
- ERP filenames use their correct uppercase spelling.
- CSV files use Unix line endings, preventing hidden carriage-return characters.
- Silver cleans carriage returns defensively and rejects birthdates outside the quality-check range.
- Every SQL file selects `DataWarehouse`, avoiding accidental execution in `master`.
- Load procedures re-throw errors instead of silently hiding them.

## One-time setup

1. Start Docker Desktop and wait until the engine is running.
2. Open Terminal in this project folder and run:

   ```bash
   bash mac-docker-copy-data.sh
   ```

3. Open the parent `sqlserver` folder in VS Code.
4. Connect the MSSQL extension to `sql_server_container`.
5. Run these files and commands in this exact order:

   1. `scripts/init_database.sql`
   2. `scripts/bronze/ddl_bronze.sql`
   3. `scripts/bronze/proc_load_bronze.sql`
   4. `EXEC bronze.load_bronze;`
   5. `scripts/silver/ddl_silver.sql`
   6. `scripts/silver/proc_load_silver.sql`
   7. `EXEC silver.load_silver;`
   8. `tests/quality_checks_silver.sql`
   9. `scripts/gold/ddl_gold.sql`
   10. `tests/quality_checks_gold.sql`
   11. `tests/setup_verification.sql`

The initialization script drops and recreates `DataWarehouse`. Run this setup sequence once, not at the start of every lesson.

## Expected source counts

- Bronze CRM customers: 18,493
- Bronze CRM products: 397
- Bronze CRM sales: 60,398
- Silver CRM customers: 18,484
- ERP product categories: 37

## Daily use

Start Docker Desktop, start `sql_server_container` if necessary, open VS Code, and connect. When finished, stop the container if desired—do not delete it.
