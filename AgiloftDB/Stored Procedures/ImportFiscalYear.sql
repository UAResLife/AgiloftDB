CREATE PROCEDURE [dbo].[ImportFiscalYear]
AS

	-- Get distinct rows into the local temp table

			TRUNCATE Table FiscalYearTemp;

			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT DISTINCT FISCAL_YEAR FiscalYear
								, FPERIOD_YEAR_START_DT_UA StartDate
								, FPERIOD_YEAR_END_DT_UA EndDate
						FROM    KUALI_ADMIN.KF_UA_DPT_RSD_FPRD
						WHERE   CURRENT_INDC = ''Y'' 
				')
			)



			INSERT INTO FiscalYearTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [FiscalYear]
					, [StartDate]
					, [EndDate]
			FROM dbo.FiscalYear

	-- Delete distinct rows from FiscalYear and insterting distinct ones with current date (date column has current_timestamp as default)
	

			Insert into FiscalYearHist
			SELECT [FiscalYear]
					, [StartDate]
					, [EndDate]
					, DateChanged
					, Current_Timestamp 
			FROM FiscalYear A
			WHERE A.FiscalYear in (
									SELECT	FiscalYear
									FROM	FiscalYearTemp
								)
			
			DELETE FiscalYear 
			FROM FiscalYear A
			WHERE A.FiscalYear in (
									SELECT	FiscalYear
									FROM	FiscalYearTemp
								)

			INSERT INTO FiscalYear SELECT F.*, Current_TimeStamp From FiscalYearTemp F

Return @@Rowcount


