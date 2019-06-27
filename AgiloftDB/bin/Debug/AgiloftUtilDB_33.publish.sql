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
PRINT N'Dropping [dbo].[DF_Account_DateChanged]...';


GO
ALTER TABLE [dbo].[Account] DROP CONSTRAINT [DF_Account_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_AccountHist_DateMoved]...';


GO
ALTER TABLE [dbo].[AccountHist] DROP CONSTRAINT [DF_AccountHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_Employee_DateChanged]...';


GO
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF_Employee_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_EmployeeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[EmployeeHist] DROP CONSTRAINT [DF_EmployeeHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_DiscalPeriod_DateChanged]...';


GO
ALTER TABLE [dbo].[FiscalPeriod] DROP CONSTRAINT [DF_DiscalPeriod_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_FiscalPeriodHist_DateMoved]...';


GO
ALTER TABLE [dbo].[FiscalPeriodHist] DROP CONSTRAINT [DF_FiscalPeriodHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_FiscalQuarter_DateChanged]...';


GO
ALTER TABLE [dbo].[FiscalQuarter] DROP CONSTRAINT [DF_FiscalQuarter_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_FiscalQuarterHist_DateMoved]...';


GO
ALTER TABLE [dbo].[FiscalQuarterHist] DROP CONSTRAINT [DF_FiscalQuarterHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_FiscalYear_DateChanged]...';


GO
ALTER TABLE [dbo].[FiscalYear] DROP CONSTRAINT [DF_FiscalYear_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_FiscalYearHist_DateMoved]...';


GO
ALTER TABLE [dbo].[FiscalYearHist] DROP CONSTRAINT [DF_FiscalYearHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_ObjectCode_DateChanged]...';


GO
ALTER TABLE [dbo].[ObjectCode] DROP CONSTRAINT [DF_ObjectCode_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_ObjectCodeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[ObjectCodeHist] DROP CONSTRAINT [DF_ObjectCodeHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_ProjectCode_DateChanged]...';


GO
ALTER TABLE [dbo].[ProjectCode] DROP CONSTRAINT [DF_ProjectCode_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_ProjectCodeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[ProjectCodeHist] DROP CONSTRAINT [DF_ProjectCodeHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_SubAccount_DateChanged]...';


GO
ALTER TABLE [dbo].[SubAccount] DROP CONSTRAINT [DF_SubAccount_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_SubAccountHist_DateMoved]...';


GO
ALTER TABLE [dbo].[SubAccountHist] DROP CONSTRAINT [DF_SubAccountHist_DateMoved];


GO
PRINT N'Dropping [dbo].[DF_SubObjectCode_DateChanged]...';


GO
ALTER TABLE [dbo].[SubObjectCode] DROP CONSTRAINT [DF_SubObjectCode_DateChanged];


GO
PRINT N'Dropping [dbo].[DF_SubObjectCodeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[SubObjectCodeHist] DROP CONSTRAINT [DF_SubObjectCodeHist_DateMoved];


GO
PRINT N'Creating [dbo].[DF_Account_DateChanged]...';


GO
ALTER TABLE [dbo].[Account]
    ADD CONSTRAINT [DF_Account_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_AccountHist_DateMoved]...';


GO
ALTER TABLE [dbo].[AccountHist]
    ADD CONSTRAINT [DF_AccountHist_DateMoved] DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_Employee_DateChanged]...';


GO
ALTER TABLE [dbo].[Employee]
    ADD CONSTRAINT [DF_Employee_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_EmployeeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[EmployeeHist]
    ADD CONSTRAINT [DF_EmployeeHist_DateMoved] DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_DiscalPeriod_DateChanged]...';


GO
ALTER TABLE [dbo].[FiscalPeriod]
    ADD CONSTRAINT [DF_DiscalPeriod_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_FiscalPeriodHist_DateMoved]...';


GO
ALTER TABLE [dbo].[FiscalPeriodHist]
    ADD CONSTRAINT [DF_FiscalPeriodHist_DateMoved] DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_FiscalQuarter_DateChanged]...';


GO
ALTER TABLE [dbo].[FiscalQuarter]
    ADD CONSTRAINT [DF_FiscalQuarter_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_FiscalQuarterHist_DateMoved]...';


GO
ALTER TABLE [dbo].[FiscalQuarterHist]
    ADD CONSTRAINT [DF_FiscalQuarterHist_DateMoved] DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_FiscalYear_DateChanged]...';


GO
ALTER TABLE [dbo].[FiscalYear]
    ADD CONSTRAINT [DF_FiscalYear_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_FiscalYearHist_DateMoved]...';


GO
ALTER TABLE [dbo].[FiscalYearHist]
    ADD CONSTRAINT [DF_FiscalYearHist_DateMoved] DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_ObjectCode_DateChanged]...';


GO
ALTER TABLE [dbo].[ObjectCode]
    ADD CONSTRAINT [DF_ObjectCode_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_ObjectCodeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[ObjectCodeHist]
    ADD CONSTRAINT [DF_ObjectCodeHist_DateMoved] DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_ProjectCode_DateChanged]...';


GO
ALTER TABLE [dbo].[ProjectCode]
    ADD CONSTRAINT [DF_ProjectCode_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_ProjectCodeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[ProjectCodeHist]
    ADD CONSTRAINT [DF_ProjectCodeHist_DateMoved] DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_SubAccount_DateChanged]...';


GO
ALTER TABLE [dbo].[SubAccount]
    ADD CONSTRAINT [DF_SubAccount_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_SubAccountHist_DateMoved]...';


GO
ALTER TABLE [dbo].[SubAccountHist]
    ADD CONSTRAINT [DF_SubAccountHist_DateMoved] DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[DF_SubObjectCode_DateChanged]...';


GO
ALTER TABLE [dbo].[SubObjectCode]
    ADD CONSTRAINT [DF_SubObjectCode_DateChanged] DEFAULT Current_Timestamp FOR [DateChanged];


GO
PRINT N'Creating [dbo].[DF_SubObjectCodeHist_DateMoved]...';


GO
ALTER TABLE [dbo].[SubObjectCodeHist]
    ADD CONSTRAINT [DF_SubObjectCodeHist_DateMoved] DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Altering [dbo].[ImportSubObjectCode]...';


GO
ALTER PROCEDURE [dbo].[ImportSubObjectCode]
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
GO
PRINT N'Update complete.';


GO