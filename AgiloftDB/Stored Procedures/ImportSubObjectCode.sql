CREATE PROCEDURE [dbo].[ImportSubObjectCode]
AS
	-- Get distinct rows into the local temp table

			TRUNCATE Table SubObjectCodeTemp;
			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
							SELECT SUB_OBJECT_CD "Number"
									, SUB_Object_LD Name
							FROM (
							SELECT P.SUB_OBJECT_CD
											, P.SUB_Object_LD
											, Sub_Object_Active_FLG
											, Row_Number() OVER (PARTITION BY SUB_OBJECT_CD ORDER BY FISCAL_YEAR DESC, OBJECT_CODE_SID DESC) SUB_OBJECT_CD_RANK
							FROM    KUALI_ADMIN.KF_UA_DPT_RSD_FOBJ P 
							WHERE   OBJECT_TYPE_CD IN (''IN'', ''EX'')
									AND Sub_Object_Active_FLG = ''Y''
									AND FISCAL_YEAR >= To_Number((Select Fiscal_Year from KUALI_ADMIN.KF_UA_DPT_RSD_FPRD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
									AND SUB_OBJECT_ACCOUNT_NBR IN 
										( SELECT DISTINCT ACCOUNT_NBR 
										  FROM KUALI_ADMIN.KF_UA_DPT_RSD_ACCT P)
							)
							WHERE SUB_OBJECT_CD_RANK = 1
				')
			)



			INSERT INTO SubObjectCodeTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [Number]
					, [Name]
			FROM dbo.SubObjectCode

	-- Delete distinct rows from SubObjectCode and insterting distinct ones with current date (date column has current_timestamp as default)


			Insert into SubObjectCodeHist
			SELECT [Number]
					, [Name]
					, DateChanged
					, Current_Timestamp 
			FROM SubObjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	SubObjectCodeTemp
								)
			
			DELETE SubObjectCode 
			FROM SubObjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	SubObjectCodeTemp
								)

			INSERT INTO SubObjectCode SELECT S.*, Current_TimeStamp From SubObjectCodeTemp S

Return @@Rowcount