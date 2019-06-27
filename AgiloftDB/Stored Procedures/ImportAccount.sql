CREATE PROCEDURE [dbo].[ImportAccount]
AS
	-- Get distinct rows into the local temp table

		TRUNCATE Table AccountTemp;

		WITH E AS (
			SELECT *
			FROM OPENQUERY(EPM, '
				Select DISTINCT ACCOUNT_NBR "Number"
						, ACCOUNT_LD Name
						, CASE WHEN ACCOUNT_CLOSED_FLG = ''Y'' THEN 1 ELSE 0 END Closed

				FROM KUALI_ADMIN.KF_UA_DPT_RSD_ACCT
			')
		)

		INSERT INTO AccountTemp 
		
		SELECT * FROM E 
		EXCEPT 
		SELECT [Number], [Name], [Closed] FROM dbo.Account

	-- Delete distinct rows from Account and insterting distinct ones with current date (date column has current_timestamp as default)
	

		Insert into AccountHist
		SELECT [Number]
				, [Name]
				, [Closed]
				, DateChanged
				, Current_Timestamp 
		FROM Account A
		WHERE A.Number in (
								SELECT	Number
								FROM	AccountTemp
							)
			
		DELETE Account 
		FROM Account A
		WHERE A.Number in (
								SELECT	Number
								FROM	AccountTemp
							)

		INSERT INTO Account SELECT A.*, Current_TimeStamp From AccountTemp A
	

Return @@Rowcount