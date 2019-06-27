﻿/*
Deployment script for Agiloft

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Agiloft"
:setvar DefaultFilePrefix "Agiloft"
:setvar DefaultDataPath "H:\DataMigration\DB\Data\"
:setvar DefaultLogPath "I:\DataMigration\DB\Transactions\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL)
BEGIN
    DECLARE @rc      int,                       -- return code
            @fn      nvarchar(4000),            -- file name for back up
            @dir     nvarchar(4000)             -- backup directory

    EXEC @rc = [master].[dbo].[xp_instance_regread] N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', @dir output, 'no_output'
    if (@rc = 0) SELECT @dir = @dir + N'\'

    IF (@dir IS NULL)
    BEGIN 
        EXEC @rc = [master].[dbo].[xp_instance_regread] N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultData', @dir output, 'no_output'
        if (@rc = 0) SELECT @dir = @dir + N'\'
    END

    IF (@dir IS NULL)
    BEGIN
        EXEC @rc = [master].[dbo].[xp_instance_regread] N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\Setup', N'SQLDataRoot', @dir output, 'no_output'
        if (@rc = 0) SELECT @dir = @dir + N'\Backup\'
    END

    IF (@dir IS NULL)
    BEGIN
        SELECT @dir = N'$(DefaultDataPath)'
    END

    SELECT  @fn = @dir + N'$(DatabaseName)' + N'-' + 
            CONVERT(nchar(8), GETDATE(), 112) + N'-' + 
            RIGHT(N'0' + RTRIM(CONVERT(nchar(2), DATEPART(hh, GETDATE()))), 2) + 
            RIGHT(N'0' + RTRIM(CONVERT(nchar(2), DATEPART(mi, getdate()))), 2) + 
            RIGHT(N'0' + RTRIM(CONVERT(nchar(2), DATEPART(ss, getdate()))), 2) + 
            N'.bak' 
            BACKUP DATABASE [$(DatabaseName)] TO DISK = @fn
END
GO
USE [$(DatabaseName)];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Account]...';


GO
ALTER TABLE [dbo].[Account] DROP CONSTRAINT [DF__Account__DateCha__47DBAE45];


GO
PRINT N'Dropping unnamed constraint on [dbo].[AccountHist]...';


GO
ALTER TABLE [dbo].[AccountHist] DROP CONSTRAINT [DF__AccountHi__DateM__6E01572D];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Employee]...';


GO
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF__Employee__DateCh__48CFD27E];


GO
PRINT N'Dropping unnamed constraint on [dbo].[EmployeeHist]...';


GO
ALTER TABLE [dbo].[EmployeeHist] DROP CONSTRAINT [DF__EmployeeH__DateM__6EF57B66];


GO
PRINT N'Dropping unnamed constraint on [dbo].[FiscalPeriod]...';


GO
ALTER TABLE [dbo].[FiscalPeriod] DROP CONSTRAINT [DF__FiscalPer__DateC__49C3F6B7];


GO
PRINT N'Dropping unnamed constraint on [dbo].[FiscalPeriodHist]...';


GO
ALTER TABLE [dbo].[FiscalPeriodHist] DROP CONSTRAINT [DF__FiscalPer__DateM__6FE99F9F];


GO
PRINT N'Dropping unnamed constraint on [dbo].[FiscalQuarter]...';


GO
ALTER TABLE [dbo].[FiscalQuarter] DROP CONSTRAINT [DF__FiscalQua__DateC__4AB81AF0];


GO
PRINT N'Dropping unnamed constraint on [dbo].[FiscalQuarterHist]...';


GO
ALTER TABLE [dbo].[FiscalQuarterHist] DROP CONSTRAINT [DF__FiscalQua__DateM__70DDC3D8];


GO
PRINT N'Dropping unnamed constraint on [dbo].[FiscalYear]...';


GO
ALTER TABLE [dbo].[FiscalYear] DROP CONSTRAINT [DF__FiscalYea__DateC__4BAC3F29];


GO
PRINT N'Dropping unnamed constraint on [dbo].[FiscalYearHist]...';


GO
ALTER TABLE [dbo].[FiscalYearHist] DROP CONSTRAINT [DF__FiscalYea__DateM__71D1E811];


GO
PRINT N'Dropping unnamed constraint on [dbo].[ObjectCode]...';


GO
ALTER TABLE [dbo].[ObjectCode] DROP CONSTRAINT [DF__ObjectCod__DateC__4D94879B];


GO
PRINT N'Dropping unnamed constraint on [dbo].[ObjectCodeHist]...';


GO
ALTER TABLE [dbo].[ObjectCodeHist] DROP CONSTRAINT [DF__ObjectCod__DateM__72C60C4A];


GO
PRINT N'Dropping unnamed constraint on [dbo].[ProjectCode]...';


GO
ALTER TABLE [dbo].[ProjectCode] DROP CONSTRAINT [DF__ProjectCo__DateC__4E88ABD4];


GO
PRINT N'Dropping unnamed constraint on [dbo].[ProjectCodeHist]...';


GO
ALTER TABLE [dbo].[ProjectCodeHist] DROP CONSTRAINT [DF__ProjectCo__DateM__73BA3083];


GO
PRINT N'Dropping unnamed constraint on [dbo].[SubAccount]...';


GO
ALTER TABLE [dbo].[SubAccount] DROP CONSTRAINT [DF__SubAccoun__DateC__4F7CD00D];


GO
PRINT N'Dropping unnamed constraint on [dbo].[SubAccountHist]...';


GO
ALTER TABLE [dbo].[SubAccountHist] DROP CONSTRAINT [DF__SubAccoun__DateM__74AE54BC];


GO
PRINT N'Dropping unnamed constraint on [dbo].[SubObjectCode]...';


GO
ALTER TABLE [dbo].[SubObjectCode] DROP CONSTRAINT [DF__SubObject__DateC__5070F446];


GO
PRINT N'Dropping unnamed constraint on [dbo].[SubObjectCodeHist]...';


GO
ALTER TABLE [dbo].[SubObjectCodeHist] DROP CONSTRAINT [DF__SubObject__DateM__75A278F5];


GO
PRINT N'Creating unnamed constraint on [dbo].[Account]...';


GO
ALTER TABLE [dbo].[Account]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[AccountHist]...';


GO
ALTER TABLE [dbo].[AccountHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[Employee]...';


GO
ALTER TABLE [dbo].[Employee]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[EmployeeHist]...';


GO
ALTER TABLE [dbo].[EmployeeHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalPeriod]...';


GO
ALTER TABLE [dbo].[FiscalPeriod]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalPeriodHist]...';


GO
ALTER TABLE [dbo].[FiscalPeriodHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalQuarter]...';


GO
ALTER TABLE [dbo].[FiscalQuarter]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalQuarterHist]...';


GO
ALTER TABLE [dbo].[FiscalQuarterHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalYear]...';


GO
ALTER TABLE [dbo].[FiscalYear]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalYearHist]...';


GO
ALTER TABLE [dbo].[FiscalYearHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[ObjectCode]...';


GO
ALTER TABLE [dbo].[ObjectCode]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[ObjectCodeHist]...';


GO
ALTER TABLE [dbo].[ObjectCodeHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[ProjectCode]...';


GO
ALTER TABLE [dbo].[ProjectCode]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[ProjectCodeHist]...';


GO
ALTER TABLE [dbo].[ProjectCodeHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[SubAccount]...';


GO
ALTER TABLE [dbo].[SubAccount]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[SubAccountHist]...';


GO
ALTER TABLE [dbo].[SubAccountHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[SubObjectCode]...';


GO
ALTER TABLE [dbo].[SubObjectCode]
    ADD DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating unnamed constraint on [dbo].[SubObjectCodeHist]...';


GO
ALTER TABLE [dbo].[SubObjectCodeHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Altering [dbo].[ImportSubAccount]...';


GO
ALTER PROCEDURE [dbo].[ImportSubAccount]
AS

	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from SubAccountTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'SubAccountTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftSubAccountTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftSubAccountTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftSubAccountTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT DISTINCT ACCOUNT_SID "Id"
							  , ACCOUNT_NBR "AccountNumber"
							  , SUB_ACCOUNT_NBR "Number"
							  , SUB_ACCOUNT_LD "Name"
							  , CASE WHEN SUB_ACCOUNT_ACTIVE_FLG = ''Y'' THEN 1 ELSE 0 END "Active"
						FROM  Kuali_admin.KF_D_Account P 
						WHERE ACCOUNT_ORGANIZATION_CD = ''8801'' 
						AND Sub_Account_NBR <> ''-''
			'

	-- Create the Temp Table in EPM with SubAccount data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table SubAccountTemp

			INSERT INTO SubAccountTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftSubAccountTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.SubAccount'

	-- Setting SQL to delete distinct rows from SubAccount and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into SubAccountHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM SubAccount A
			WHERE A.Number in (
									SELECT	Number
									FROM	SubAccountTemp
								)
			
			DELETE SubAccount 
			FROM SubAccount A
			WHERE A.Number in (
									SELECT	Number
									FROM	SubAccountTemp
								)

			INSERT INTO SubAccount SELECT AT.*, Current_TimeStamp From SubAccountTemp AT
	'

	-- Updating local temp table
	EXEC (@updateLocalTempTable)
	-- Updating local table
	EXEC (@updateLocalTable)
	-- Truncating data from EPM's temp table
	EXEC (@truncateEpmTempTable) AT EPM	
	-- Dropping EPM's temp table
	EXEC (@dropEPMTempTable) AT EPM	




Return @@Rowcount
GO
PRINT N'Creating [dbo].[ImportSubObjectCode]...';


GO
CREATE PROCEDURE [dbo].[ImportSubObjectCode]
AS
	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from SubObjectCodeTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'SubObjectCodeTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftSubObjectCodeTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftSubObjectCodeTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftSubObjectCodeTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT DISTINCT P.SUB_OBJECT_CD "Number"
										,P2.SUB_Object_LD Name
						FROM    Kuali_admin.KF_D_Object_code P 
									INNER JOIN (
										SELECT  SUB_OBJECT_CD
												, SUB_OBJECT_LD 
												, Sub_Object_Active_FLG
												, Row_Number() OVER (PARTITION BY SUB_OBJECT_CD ORDER BY FISCAL_YEAR DESC, OBJECT_CODE_SID DESC) SUB_OBJECT_CD_RANK
										FROM    Kuali_admin.KF_D_Object_code P 
										WHERE   FISCAL_YEAR >= To_Number((Select Fiscal_Year from Kuali_admin.KF_D_FISCAL_PERIOD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
												AND OBJECT_TYPE_CD IN (''IN'', ''EX'')
									) P2
										ON P.SUB_OBJECT_CD = P2.SUB_OBJECT_CD
										AND P2.SUB_OBJECT_CD_RANK = 1
						WHERE   OBJECT_TYPE_CD IN (''IN'', ''EX'')
								AND FISCAL_YEAR >= To_Number((Select Fiscal_Year from Kuali_admin.KF_D_FISCAL_PERIOD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
								AND SUB_OBJECT_ACCOUNT_NBR IN 
									( SELECT DISTINCT ACCOUNT_NBR 
									  FROM Kuali_admin.KF_D_Account P 
									  WHERE ACCOUNT_ORGANIZATION_CD = ''8801'')
			'

	-- Create the Temp Table in EPM with SubObjectCode data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table SubObjectCodeTemp

			INSERT INTO SubObjectCodeTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftSubObjectCodeTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.SubObjectCode'

	-- Setting SQL to delete distinct rows from SubObjectCode and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into SubObjectCodeHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM SubObjectCode A
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

			INSERT INTO SubObjectCode SELECT AT.*, Current_TimeStamp From SubObjectCodeTemp AT
	'

	-- Updating local temp table
	EXEC (@updateLocalTempTable)
	-- Updating local table
	EXEC (@updateLocalTable)
	-- Truncating data from EPM's temp table
	EXEC (@truncateEpmTempTable) AT EPM	
	-- Dropping EPM's temp table
	EXEC (@dropEPMTempTable) AT EPM	




Return @@Rowcount
GO
PRINT N'Update complete.';


GO
