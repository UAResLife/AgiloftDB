CREATE PROCEDURE [dbo].[ImportProjectCode]
AS
	-- Setting SQL to get distinct rows into the local temp table
			TRUNCATE Table ProjectCodeTemp;

			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT  PROJECT_CD Code
								, PROJECT_SD Name
								, PROJECT_LD Description
								, CASE WHEN PROJECT_ACTIVE_FLG = ''Y'' THEN 1 ELSE 0 END Active
						FROM    KUALI_ADMIN.KF_UA_DPT_RSD_PROJ P 
				')
			)


			INSERT INTO ProjectCodeTemp 
			SELECT * FROM E
			EXCEPT 
			SELECT [Code]
					, [Name]
					, [Description]
					, [Active]
			FROM dbo.ProjectCode

	-- Distinct rows from ProjectCode and insterting distinct ones with current date (date column has current_timestamp as default)

			Insert into ProjectCodeHist
			SELECT [Code]
					, [Name]
					, [Description]
					, [Active]
					, DateChanged
					, Current_Timestamp 
			FROM ProjectCode A
			WHERE A.Code in (
									SELECT	Code
									FROM	ProjectCodeTemp
								)
			
			DELETE ProjectCode 
			FROM ProjectCode A
			WHERE A.Code in (
									SELECT	Code
									FROM	ProjectCodeTemp
								)

			INSERT INTO ProjectCode SELECT P.*, Current_TimeStamp From ProjectCodeTemp P

Return @@Rowcount