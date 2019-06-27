CREATE PROCEDURE [dbo].[ImportObjectCode]
AS
	-- Get distinct rows into the local temp table

			TRUNCATE Table ObjectCodeTemp;

			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT DISTINCT P.OBJECT_CD "Number"
										,P2.Object_LD Name
						FROM    KUALI_ADMIN.KF_UA_DPT_RSD_FOBJ P
									INNER JOIN (
										SELECT  OBJECT_CD
												, OBJECT_LD 
												, Row_Number() OVER (PARTITION BY OBJECT_CD ORDER BY FISCAL_YEAR DESC, OBJECT_CODE_SID DESC) OBJECT_CD_RANK
										FROM    KUALI_ADMIN.KF_UA_DPT_RSD_FOBJ P 
										WHERE   FISCAL_YEAR >= To_Number((Select Fiscal_Year from KUALI_ADMIN.KF_UA_DPT_RSD_FPRD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
												AND OBJECT_TYPE_CD IN (''IN'', ''EX'')
									) P2
										ON P.OBJECT_CD = P2.OBJECT_CD
										AND P2.OBJECT_CD_RANK = 1
						WHERE   FISCAL_YEAR >= To_Number((Select Fiscal_Year from KUALI_ADMIN.KF_UA_DPT_RSD_FPRD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
								AND SUB_OBJECT_ACCOUNT_NBR IN 
									( SELECT DISTINCT ACCOUNT_NBR 
									  FROM KUALI_ADMIN.KF_UA_DPT_RSD_ACCT P 
									  WHERE ACCOUNT_ORGANIZATION_CD = ''8801'')				
				')
			)

			INSERT INTO ObjectCodeTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [Number]
					, [Name]
			FROM dbo.ObjectCode

	-- Delete distinct rows from ObjectCode and insterting distinct ones with current date (date column has current_timestamp as default)
			Insert into ObjectCodeHist
			SELECT [Number]
					, [Name]
					, DateChanged
					, Current_Timestamp 
			FROM ObjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	ObjectCodeTemp
								)
			
			DELETE ObjectCode 
			FROM ObjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	ObjectCodeTemp
								)

			INSERT INTO ObjectCode SELECT O.*, Current_TimeStamp From ObjectCodeTemp O

Return @@Rowcount