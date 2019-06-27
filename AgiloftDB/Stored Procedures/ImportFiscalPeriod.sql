CREATE PROCEDURE [dbo].[ImportFiscalPeriod]
AS
	-- Get distinct rows into the local temp table

			TRUNCATE Table FiscalPeriodTemp;

			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT FISCAL_PERIOD_SID "Id"
								, FPERIOD_YEAR_NBR "Number"
								, FPERIOD_SD "Name"
								, FPERIOD_START_DT_UA "StartDate"
								, FPERIOD_END_DT "EndDate"
								, FISCAL_YEAR "FiscalYear"
								, FPERIOD_QUARTER_NBR_UA "QuarterID"
						FROM    KUALI_ADMIN.KF_UA_DPT_RSD_FPRD
						WHERE   CURRENT_INDC = ''Y'' 
				')
			)


			INSERT INTO FiscalPeriodTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [Id]
					, [Number]
					, [Name]
					, [StartDate]
					, [EndDate]
					, [FiscalYear]
					, [QuarterID]
			FROM dbo.FiscalPeriod

	-- Delete distinct rows from FiscalPeriod and insterting distinct ones with current date (date column has current_timestamp as default)


			Insert into FiscalPeriodHist
			SELECT [Id]
					, [Number]
					, [Name]
					, [StartDate]
					, [EndDate]
					, [FiscalYear]
					, [QuarterID]
					, DateChanged
					, Current_Timestamp 
			FROM FiscalPeriod A
			WHERE A.Id in (
									SELECT	Id
									FROM	FiscalPeriodTemp
								)
			
			DELETE FiscalPeriod 
			FROM FiscalPeriod A
			WHERE A.Id in (
									SELECT	Id
									FROM	FiscalPeriodTemp
								)

			INSERT INTO FiscalPeriod SELECT F.*, Current_TimeStamp From FiscalPeriodTemp F
	

Return @@Rowcount
