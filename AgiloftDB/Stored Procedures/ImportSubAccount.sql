CREATE PROCEDURE [dbo].[ImportSubAccount]
AS
	-- Get distinct rows into the local temp table
			TRUNCATE Table SubAccountTemp;
			
			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT DISTINCT ACCOUNT_SID "Id"
							  , ACCOUNT_NBR "AccountNumber"
							  , SUB_ACCOUNT_NBR "Number"
							  , SUB_ACCOUNT_LD "Name"
							  , CASE WHEN SUB_ACCOUNT_ACTIVE_FLG = ''Y'' THEN 1 ELSE 0 END "Active"
						FROM  KUALI_ADMIN.KF_UA_DPT_RSD_ACCT P 
						WHERE Sub_Account_NBR <> ''-''				
				')
			)

			INSERT INTO SubAccountTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [Id]
					, [AccountNumber]
					, [Number]
					, [Name]
					, [Active]
			FROM dbo.SubAccount

	-- Delete distinct rows from SubAccount and insterting distinct ones with current date (date column has current_timestamp as default)

			Insert into SubAccountHist
			SELECT [Id]
					, [AccountNumber]
					, [Number]
					, [Name]
					, [Active]
					, DateChanged
					, Current_Timestamp 
			
			FROM SubAccount A
			WHERE A.Id in (
									SELECT	Id
									FROM	SubAccountTemp
								)
			
			DELETE SubAccount 
			FROM SubAccount A
			WHERE A.Id in (
									SELECT	Id
									FROM	SubAccountTemp
								)

			INSERT INTO SubAccount SELECT S.*, Current_TimeStamp From SubAccountTemp S

Return @@Rowcount

