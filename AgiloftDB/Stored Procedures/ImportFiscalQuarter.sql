CREATE PROCEDURE [dbo].[ImportFiscalQuarter]
AS

	-- Get distinct rows into the local temp table

			TRUNCATE Table FiscalQuarterTemp;

			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT DISTINCT FPERIOD_QUARTER_NBR_UA "Id"
								, FPERIOD_QUARTER_YEAR_NBR_UA "Number"
								, FPERIOD_QUARTER_SD_UA "Name"
						FROM    KUALI_ADMIN.KF_UA_DPT_RSD_FPRD
						WHERE   CURRENT_INDC = ''Y'' 
				')
			)

			INSERT INTO FiscalQuarterTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [Id]
					, [Number]
					, [Name]
			FROM dbo.FiscalQuarter

	-- Delete distinct rows from FiscalQuarter and insterting distinct ones with current date (date column has current_timestamp as default)
	

			Insert into FiscalQuarterHist
			SELECT [Id]
					, [Number]
					, [Name]
					, DateChanged
					, Current_Timestamp 
			FROM FiscalQuarter A
			WHERE A.Id in (
									SELECT	Id
									FROM	FiscalQuarterTemp
								)
			
			DELETE FiscalQuarter 
			FROM FiscalQuarter A
			WHERE A.Id in (
									SELECT	Id
									FROM	FiscalQuarterTemp
								)

			INSERT INTO FiscalQuarter SELECT F.*, Current_TimeStamp From FiscalQuarterTemp F

Return @@Rowcount

