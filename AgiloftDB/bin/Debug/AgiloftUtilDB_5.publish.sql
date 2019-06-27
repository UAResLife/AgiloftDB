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
PRINT N'Dropping [dbo].[FK_FiscalPeriod_FiscalYear_Year]...';


GO
ALTER TABLE [dbo].[FiscalPeriod] DROP CONSTRAINT [FK_FiscalPeriod_FiscalYear_Year];


GO
PRINT N'Dropping [dbo].[PK_FiscalYear]...';


GO
ALTER TABLE [dbo].[FiscalYear] DROP CONSTRAINT [PK_FiscalYear];


GO
PRINT N'Altering [dbo].[Account]...';


GO
ALTER TABLE [dbo].[Account]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[Employee]...';


GO
ALTER TABLE [dbo].[Employee]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[FiscalPeriod]...';


GO
ALTER TABLE [dbo].[FiscalPeriod]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[FiscalQuarter]...';


GO
ALTER TABLE [dbo].[FiscalQuarter]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[FiscalYear]...';


GO
ALTER TABLE [dbo].[FiscalYear]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Creating [dbo].[PK_FiscalYear_FiscalYear]...';


GO
ALTER TABLE [dbo].[FiscalYear]
    ADD CONSTRAINT [PK_FiscalYear_FiscalYear] PRIMARY KEY NONCLUSTERED ([FiscalYear] ASC);


GO
PRINT N'Altering [dbo].[ObjectCode]...';


GO
ALTER TABLE [dbo].[ObjectCode]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[ProjectCode]...';


GO
ALTER TABLE [dbo].[ProjectCode]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[SubAccount]...';


GO
ALTER TABLE [dbo].[SubAccount]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Altering [dbo].[SubObjectCode]...';


GO
ALTER TABLE [dbo].[SubObjectCode]
    ADD [DateChanged] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;


GO
PRINT N'Creating [dbo].[AccountHist]...';


GO
CREATE TABLE [dbo].[AccountHist] (
    [Number]      INT           NOT NULL,
    [Name]        NVARCHAR (64) NULL,
    [Closed]      BIT           NULL,
    [DateChanged] DATETIME      NOT NULL,
    [DateMoved]   DATETIME      NOT NULL
);


GO
PRINT N'Creating [dbo].[AccountTemp]...';


GO
CREATE TABLE [dbo].[AccountTemp] (
    [Number] INT           NOT NULL,
    [Name]   NVARCHAR (64) NULL,
    [Closed] BIT           NULL,
    CONSTRAINT [PK_AccountTemp_AccountNumber] PRIMARY KEY CLUSTERED ([Number] ASC)
);


GO
PRINT N'Creating [dbo].[EmployeeHist]...';


GO
CREATE TABLE [dbo].[EmployeeHist] (
    [NetID]              NVARCHAR (64)  NOT NULL,
    [PreferredFirstName] NVARCHAR (64)  NULL,
    [PreferredLastName]  NVARCHAR (64)  NULL,
    [Department]         NVARCHAR (64)  NULL,
    [Unit]               NVARCHAR (64)  NULL,
    [PrimaryJobPosition] NVARCHAR (128) NULL,
    [Email]              NVARCHAR (64)  NULL,
    [OfficePhone]        NVARCHAR (32)  NULL,
    [MobilePhone]        NVARCHAR (32)  NULL,
    [EmployeeStatus]     NVARCHAR (16)  NULL,
    [TerminationDate]    DATETIME       NULL,
    [SupervisorNetID]    NVARCHAR (64)  NULL,
    [DateChanged]        DATETIME       NOT NULL,
    [DateMoved]          DATETIME       NOT NULL,
    CONSTRAINT [PK_EmployeesTemp_NetID] PRIMARY KEY CLUSTERED ([NetID] ASC)
);


GO
PRINT N'Creating [dbo].[EmployeeTemp]...';


GO
CREATE TABLE [dbo].[EmployeeTemp] (
    [NetID]              NVARCHAR (64)  NOT NULL,
    [PreferredFirstName] NVARCHAR (64)  NULL,
    [PreferredLastName]  NVARCHAR (64)  NULL,
    [Department]         NVARCHAR (64)  NULL,
    [Unit]               NVARCHAR (64)  NULL,
    [PrimaryJobPosition] NVARCHAR (128) NULL,
    [Email]              NVARCHAR (64)  NULL,
    [OfficePhone]        NVARCHAR (32)  NULL,
    [MobilePhone]        NVARCHAR (32)  NULL,
    [EmployeeStatus]     NVARCHAR (16)  NULL,
    [TerminationDate]    DATETIME       NULL,
    [SupervisorNetID]    NVARCHAR (64)  NULL,
    CONSTRAINT [PK_EmployeeTemp_NetID] PRIMARY KEY CLUSTERED ([NetID] ASC)
);


GO
PRINT N'Creating [dbo].[FiscalPeriodHist]...';


GO
CREATE TABLE [dbo].[FiscalPeriodHist] (
    [Id]          INT           NOT NULL,
    [Number]      INT           NULL,
    [Name]        NVARCHAR (64) NULL,
    [StartDate]   DATE          NULL,
    [EndDate]     DATE          NULL,
    [FiscalYear]  INT           NULL,
    [QuarterID]   INT           NULL,
    [DateChanged] DATETIME      NOT NULL,
    [DateMoved]   DATETIME      NOT NULL,
    CONSTRAINT [PK_FiscalPeriodHist_ID] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FiscalPeriodTemp]...';


GO
CREATE TABLE [dbo].[FiscalPeriodTemp] (
    [Id]         INT           NOT NULL,
    [Number]     INT           NULL,
    [Name]       NVARCHAR (64) NULL,
    [StartDate]  DATE          NULL,
    [EndDate]    DATE          NULL,
    [FiscalYear] INT           NULL,
    [QuarterID]  INT           NULL,
    CONSTRAINT [PK_FiscalPeriodTemp_ID] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FiscalQuarterHist]...';


GO
CREATE TABLE [dbo].[FiscalQuarterHist] (
    [Id]          INT           NOT NULL,
    [Number]      INT           NULL,
    [Name]        NVARCHAR (64) NULL,
    [DateChanged] DATETIME      NOT NULL,
    [DateMoved]   DATETIME      NOT NULL,
    CONSTRAINT [PK_FiscalQuarterHist_ID] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FiscalQuarterTemp]...';


GO
CREATE TABLE [dbo].[FiscalQuarterTemp] (
    [Id]     INT           NOT NULL,
    [Number] INT           NULL,
    [Name]   NVARCHAR (64) NULL,
    CONSTRAINT [PK_FiscalQuarterTemp_ID] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FiscalYearHist]...';


GO
CREATE TABLE [dbo].[FiscalYearHist] (
    [FiscalYear]  INT      NOT NULL,
    [StartDate]   DATE     NULL,
    [EndDate]     DATE     NULL,
    [DateChanged] DATETIME NOT NULL,
    [DateMoved]   DATETIME NOT NULL
);


GO
PRINT N'Creating [dbo].[FiscalYearTemp]...';


GO
CREATE TABLE [dbo].[FiscalYearTemp] (
    [FiscalYear] INT  NOT NULL,
    [StartDate]  DATE NULL,
    [EndDate]    DATE NULL,
    CONSTRAINT [PK_FiscalYearTemp_FiscalYear] PRIMARY KEY NONCLUSTERED ([FiscalYear] ASC)
);


GO
PRINT N'Creating [dbo].[ObjectCodeHist]...';


GO
CREATE TABLE [dbo].[ObjectCodeHist] (
    [Number]      NVARCHAR (16) NOT NULL,
    [Name]        NVARCHAR (64) NULL,
    [DateChanged] DATETIME      NOT NULL,
    [DateMoved]   DATETIME      NOT NULL
);


GO
PRINT N'Creating [dbo].[ObjectCodeTemp]...';


GO
CREATE TABLE [dbo].[ObjectCodeTemp] (
    [Number] NVARCHAR (16) NOT NULL,
    [Name]   NVARCHAR (64) NULL,
    CONSTRAINT [PK_ObjectCodeTemp_Number] PRIMARY KEY CLUSTERED ([Number] ASC)
);


GO
PRINT N'Creating [dbo].[ProjectCodeHist]...';


GO
CREATE TABLE [dbo].[ProjectCodeHist] (
    [Code]        NVARCHAR (16)  NOT NULL,
    [Name]        NVARCHAR (64)  NULL,
    [Description] NVARCHAR (MAX) NULL,
    [Active]      BIT            NULL,
    [DateChanged] DATETIME       NOT NULL,
    [DateMoved]   DATETIME       NOT NULL
);


GO
PRINT N'Creating [dbo].[ProjectCodeTemp]...';


GO
CREATE TABLE [dbo].[ProjectCodeTemp] (
    [Code]        NVARCHAR (16)  NOT NULL,
    [Name]        NVARCHAR (64)  NULL,
    [Description] NVARCHAR (MAX) NULL,
    [Active]      BIT            NULL,
    CONSTRAINT [PK_ProjectCodeTemp_Code] PRIMARY KEY CLUSTERED ([Code] ASC)
);


GO
PRINT N'Creating [dbo].[SubAccountHist]...';


GO
CREATE TABLE [dbo].[SubAccountHist] (
    [Id]            INT           NOT NULL,
    [AccountNumber] INT           NULL,
    [Number]        NVARCHAR (64) NULL,
    [Name]          NVARCHAR (64) NULL,
    [Active]        BIT           NULL,
    [DateChanged]   DATETIME      NOT NULL,
    [DateMoved]     DATETIME      NOT NULL
);


GO
PRINT N'Creating [dbo].[SubAccountTemp]...';


GO
CREATE TABLE [dbo].[SubAccountTemp] (
    [Id]            INT           NOT NULL,
    [AccountNumber] INT           NULL,
    [Number]        NVARCHAR (64) NULL,
    [Name]          NVARCHAR (64) NULL,
    [Active]        BIT           NULL,
    CONSTRAINT [PK_SubAccountTemp_ID] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[SubObjectCodeHist]...';


GO
CREATE TABLE [dbo].[SubObjectCodeHist] (
    [Number]      NVARCHAR (16) NOT NULL,
    [Name]        NVARCHAR (64) NULL,
    [DateChanged] DATETIME      NOT NULL,
    [DateMoved]   DATETIME      NOT NULL
);


GO
PRINT N'Creating [dbo].[SubObjectCodeTemp]...';


GO
CREATE TABLE [dbo].[SubObjectCodeTemp] (
    [Number] NVARCHAR (16) NOT NULL,
    [Name]   NVARCHAR (64) NULL,
    CONSTRAINT [PK_SubObjectCodeTemp_Number] PRIMARY KEY CLUSTERED ([Number] ASC)
);


GO
PRINT N'Creating unnamed constraint on [dbo].[AccountHist]...';


GO
ALTER TABLE [dbo].[AccountHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[EmployeeHist]...';


GO
ALTER TABLE [dbo].[EmployeeHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalPeriodHist]...';


GO
ALTER TABLE [dbo].[FiscalPeriodHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalQuarterHist]...';


GO
ALTER TABLE [dbo].[FiscalQuarterHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[FiscalYearHist]...';


GO
ALTER TABLE [dbo].[FiscalYearHist]
    ADD DEFAULT current_timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[ObjectCodeHist]...';


GO
ALTER TABLE [dbo].[ObjectCodeHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[ProjectCodeHist]...';


GO
ALTER TABLE [dbo].[ProjectCodeHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[SubAccountHist]...';


GO
ALTER TABLE [dbo].[SubAccountHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating unnamed constraint on [dbo].[SubObjectCodeHist]...';


GO
ALTER TABLE [dbo].[SubObjectCodeHist]
    ADD DEFAULT Current_Timestamp FOR [DateMoved];


GO
PRINT N'Creating [dbo].[FK_FiscalPeriod_FiscalYear_Year]...';


GO
ALTER TABLE [dbo].[FiscalPeriod] WITH NOCHECK
    ADD CONSTRAINT [FK_FiscalPeriod_FiscalYear_Year] FOREIGN KEY ([FiscalYear]) REFERENCES [dbo].[FiscalYear] ([FiscalYear]);


GO
PRINT N'Creating [dbo].[ImportAccount]...';


GO
CREATE PROCEDURE [dbo].[ImportAccount]
AS
	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from AccountTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'AccountTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftAccountTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftAccountTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftAccountTemp
					ON COMMIT PRESERVE ROWS 
					AS
					Select DISTINCT ACCOUNT_NBR "Number"
						  , ACCOUNT_LD Name
						  , CASE WHEN ACCOUNT_CLOSED_FLG = ''Y'' THEN 1 ELSE 0 END Closed

					FROM Kuali_admin.KF_D_Account P 

					WHERE ACCOUNT_ORGANIZATION_CD = ''8801''
			'

	-- Create the Temp Table in EPM with Account data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table AccountTemp

			INSERT INTO AccountTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftAccountTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.Account'

	-- Setting SQL to delete distinct rows from Account and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into AccountHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM Account A
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

			INSERT INTO Account SELECT AT.*, Current_TimeStamp From AccountTemp AT
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
PRINT N'Creating [dbo].[ImportEmployee]...';


GO
CREATE PROCEDURE [dbo].[ImportEmployee]
AS
	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from EmployeeTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'EmployeeTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftEmployeeTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftEmployeeTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftEmployeeTemp
					ON COMMIT PRESERVE ROWS 
					AS
						WITH E AS (
							SELECT  	
									E.NETID_OPRID NetID
									, E.PREF_FIRST_NAME PreferredFirstName
									, E.PREF_LAST_NAME PreferredLastName
									, J.DEPT_NAME Department
									, J.UA_TITLE_CONCAT PrimaryJobPosition
									, E.EMAIL_ADDR Email
									, Replace(Replace(E.WORK_PHONE, ''/'', ''''),''-'','''') OfficePhone
									, REPLACE(REPLACE(E.CELL_PHONE, ''/'', ''''),''-'','''') MobilePhone
									, E.EMPL_STAT_CD EmployeeStatus
									, E.TERMINATION_DT TerminationDate
									, J.SUPERVSR_EMPLID
									, E.Day_SID
									, '''' UNIT
									, Row_Number() OVER (PARTITION BY J.EmplID ORDER BY J.PRIMARY_JOB_INDC DESC, J.LAST_HIRE_DT  DESC) PosRank

							FROM  SYSADM.PS_UA_EMPL_PROF_PP E
									INNER JOIN SYSADM.PS_UA_EMPL_JOB_DTL J
									  ON E.EMPLID = J.EMPLID

							WHERE E.DAY_SID = ''20180225'' --Previous sunday to payday  
          
								  AND J.Active_Job_Indc = ''A''
								  AND ((J.DEPTID IN (8801, 8802, 8804, 8810, 8814) OR E.UA_ACCT_STRING LIKE ''%1699000%''))
						)

						SELECT    E.NetID
								, E.EmplID
								, E.FirstName
								, E.LastName
								, E.PreferredFirstName
								, E.PreferredLastName
								, E.Department
								, E.UNIT
								, E.PrimaryJobPosition
								, E.Email
								, E.OfficePhone
								, E.MobilePhone
								, E.EmployeeStatus
								, E.TerminationDate
								, Supv.NETID_OPRID SupervisorNetID
				
						FROM E
						  LEFT JOIN SYSADM.PS_UA_EMPL_PROF_PP Supv
							  ON Supv.EmplID = E.SUPERVSR_EMPLID
							  AND Supv.Day_SID = E.Day_SID
							  AND Supv.EmplID in (Select E2.EMPLID FROM E E2)
						WHERE E.PosRank = 1 
			'

	-- Create the Temp Table in EPM with Employee data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table EmployeeTemp

			INSERT INTO EmployeeTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftEmployeeTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.Employee'

	-- Setting SQL to delete distinct rows from Employee and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into EmployeeHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM Employee A
			WHERE A.Number in (
									SELECT	Number
									FROM	EmployeeTemp
								)
			
			DELETE Employee 
			FROM Employee A
			WHERE A.Number in (
									SELECT	Number
									FROM	EmployeeTemp
								)

			INSERT INTO Employee SELECT AT.*, Current_TimeStamp From EmployeeTemp AT
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
PRINT N'Creating [dbo].[ImportFiscalPeriod]...';


GO
CREATE PROCEDURE [dbo].[ImportFiscalPeriod]
AS

	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from FiscalPeriodTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'FiscalPeriodTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftFiscalPeriodTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftFiscalPeriodTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftFiscalPeriodTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT FISCAL_PERIOD_SID "Id"
								, FPERIOD_YEAR_NBR "Number"
								, FPERIOD_SD "Name"
								, FPERIOD_START_DT_UA "StartDate"
								, FPERIOD_END_DT "EndDate"
								, FISCAL_YEAR "FiscalYear"
								, FPERIOD_QUARTER_NBR_UA "QuarterID"
						FROM    Kuali_admin.KF_D_FISCAL_PERIOD 
						WHERE   CURRENT_INDC = ''Y'' 
								AND FISCAL_YEAR >= 2017 
								AND FPERIOD_YEAR_NBR NOT IN (''AB'',''BB'',''CB'',''13'')
			'

	-- Create the Temp Table in EPM with FiscalPeriod data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table FiscalPeriodTemp

			INSERT INTO FiscalPeriodTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftFiscalPeriodTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.FiscalPeriod'

	-- Setting SQL to delete distinct rows from FiscalPeriod and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into FiscalPeriodHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM FiscalPeriod A
			WHERE A.Number in (
									SELECT	Number
									FROM	FiscalPeriodTemp
								)
			
			DELETE FiscalPeriod 
			FROM FiscalPeriod A
			WHERE A.Number in (
									SELECT	Number
									FROM	FiscalPeriodTemp
								)

			INSERT INTO FiscalPeriod SELECT AT.*, Current_TimeStamp From FiscalPeriodTemp AT
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
PRINT N'Creating [dbo].[ImportFiscalQuarter]...';


GO
CREATE PROCEDURE [dbo].[ImportFiscalQuarter]
AS
	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from FiscalQuarterTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'FiscalQuarterTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftFiscalQuarterTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftFiscalQuarterTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftFiscalQuarterTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT DISTINCT FPERIOD_QUARTER_NBR_UA "Id"
								, FPERIOD_QUARTER_YEAR_NBR_UA "Number"
								, FPERIOD_QUARTER_SD_UA "Name"
						FROM    Kuali_admin.KF_D_FISCAL_PERIOD 
						WHERE   CURRENT_INDC = ''Y'' 
								AND FISCAL_YEAR >= 2017 
								AND FPERIOD_YEAR_NBR NOT IN (''AB'',''BB'',''CB'',''13'')
			'

	-- Create the Temp Table in EPM with FiscalQuarter data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table FiscalQuarterTemp

			INSERT INTO FiscalQuarterTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftFiscalQuarterTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.FiscalQuarter'

	-- Setting SQL to delete distinct rows from FiscalQuarter and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into FiscalQuarterHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM FiscalQuarter A
			WHERE A.Number in (
									SELECT	Number
									FROM	FiscalQuarterTemp
								)
			
			DELETE FiscalQuarter 
			FROM FiscalQuarter A
			WHERE A.Number in (
									SELECT	Number
									FROM	FiscalQuarterTemp
								)

			INSERT INTO FiscalQuarter SELECT AT.*, Current_TimeStamp From FiscalQuarterTemp AT
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
PRINT N'Creating [dbo].[ImportFiscalYear]...';


GO
CREATE PROCEDURE [dbo].[ImportFiscalYear]
AS

	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from FiscalYearTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'FiscalYearTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftFiscalYearTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftFiscalYearTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftFiscalYearTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT DISTINCT FISCAL_YEAR FiscalYear
								, FPERIOD_YEAR_START_DT_UA StartDate
								, FPERIOD_YEAR_END_DT_UA EndDate
						FROM    Kuali_admin.KF_D_FISCAL_PERIOD 
						WHERE   CURRENT_INDC = ''Y'' 
								AND FISCAL_YEAR >= 2017 
								AND FPERIOD_YEAR_NBR NOT IN (''AB'',''BB'',''CB'',''13'')
			'

	-- Create the Temp Table in EPM with FiscalYear data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table FiscalYearTemp

			INSERT INTO FiscalYearTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftFiscalYearTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.FiscalYear'

	-- Setting SQL to delete distinct rows from FiscalYear and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into FiscalYearHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM FiscalYear A
			WHERE A.Number in (
									SELECT	Number
									FROM	FiscalYearTemp
								)
			
			DELETE FiscalYear 
			FROM FiscalYear A
			WHERE A.Number in (
									SELECT	Number
									FROM	FiscalYearTemp
								)

			INSERT INTO FiscalYear SELECT AT.*, Current_TimeStamp From FiscalYearTemp AT
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
PRINT N'Creating [dbo].[ImportObjectCode]...';


GO
CREATE PROCEDURE [dbo].[ImportObjectCode]
AS

	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from ObjectCodeTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'ObjectCodeTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftObjectCodeTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftObjectCodeTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftObjectCodeTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT DISTINCT P.OBJECT_CD "Number"
										,P2.Object_LD Name
						FROM    Kuali_admin.KF_D_Object_code P 
									INNER JOIN (
										SELECT  OBJECT_CD
												, OBJECT_LD 
												, Row_Number() OVER (PARTITION BY OBJECT_CD ORDER BY FISCAL_YEAR DESC, OBJECT_CODE_SID DESC) OBJECT_CD_RANK
										FROM    Kuali_admin.KF_D_Object_code P 
										WHERE   FISCAL_YEAR >= To_Number((Select Fiscal_Year from Kuali_admin.KF_D_FISCAL_PERIOD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
												AND OBJECT_TYPE_CD IN (''IN'', ''EX'')
									) P2
										ON P.OBJECT_CD = P2.OBJECT_CD
										AND P2.OBJECT_CD_RANK = 1
						WHERE   OBJECT_TYPE_CD IN (''IN'', ''EX'')
								AND FISCAL_YEAR >= To_Number((Select Fiscal_Year from Kuali_admin.KF_D_FISCAL_PERIOD WHERE sysdate between FPERIOD_YEAR_START_DT_UA AND FPERIOD_YEAR_END_DT_UA AND ROWNUM = 1)) - 5
								AND SUB_OBJECT_ACCOUNT_NBR IN 
									( SELECT DISTINCT ACCOUNT_NBR 
									  FROM Kuali_admin.KF_D_Account P 
									  WHERE ACCOUNT_ORGANIZATION_CD = ''8801'')
			'

	-- Create the Temp Table in EPM with ObjectCode data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table ObjectCodeTemp

			INSERT INTO ObjectCodeTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftObjectCodeTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.ObjectCode'

	-- Setting SQL to delete distinct rows from ObjectCode and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into ObjectCodeHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM ObjectCode A
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

			INSERT INTO ObjectCode SELECT AT.*, Current_TimeStamp From ObjectCodeTemp AT
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
PRINT N'Creating [dbo].[ImportProjectCode]...';


GO
CREATE PROCEDURE [dbo].[ImportProjectCode]
AS

	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from ProjectCodeTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'ProjectCodeTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftProjectCodeTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftProjectCodeTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftProjectCodeTemp
					ON COMMIT PRESERVE ROWS 
					AS
						SELECT  PROJECT_CD Code
								, PROJECT_SD Name
								, PROJECT_LD Description
								, CASE WHEN PROJECT_ACTIVE_FLG = ''Y'' THEN 1 ELSE 0 END Active
						FROM    Kuali_admin.KF_D_Project P 
						WHERE ORGANIZATION_CD = ''8801''
			'

	-- Create the Temp Table in EPM with ProjectCode data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table ProjectCodeTemp

			INSERT INTO ProjectCodeTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftProjectCodeTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.ProjectCode'

	-- Setting SQL to delete distinct rows from ProjectCode and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into ProjectCodeHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM ProjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	ProjectCodeTemp
								)
			
			DELETE ProjectCode 
			FROM ProjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	ProjectCodeTemp
								)

			INSERT INTO ProjectCode SELECT AT.*, Current_TimeStamp From ProjectCodeTemp AT
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
PRINT N'Creating [dbo].[ImportSubAccount]...';


GO
CREATE PROCEDURE [dbo].[ImportSubAccount]
AS

	DECLARE @listStr varchar(MAX)					--To hold the list of columns in the local Table

	-- Getting list of columns from ProjectCodeTemp
	select	@listStr = COALESCE(@listStr+',' ,'') + column_name
	from	information_schema.columns
	where	table_schema = 'dbo'
			and table_name = 'ProjectCodeTemp'


	SET NOCOUNT ON;

	-- Declaring variables
	
	DECLARE @strSQL varchar(max)					--To hold SQL to insert data into a EPM's temp table
			, @dropEPMTempTable varchar(max)		--To hold SQL to drop EPM's temp table
			, @truncateEpmTempTable varchar(max)	--To hold SQL to truncate EPM's temp table
			, @updateLocalTable varchar(max)		--To hold SQL to update the local table
			, @updateLocalTempTable varchar(max)	--To hold SQL to update the local temp table
			

	-- Assigning queries to variables

	SELECT	
			@dropEPMTempTable = 'DROP TABLE agiloftProjectCodeTemp PURGE'
			,@truncateEpmTempTable = 'Truncate Table agiloftProjectCodeTemp'
			,@strSQL = N'
				CREATE GLOBAL TEMPORARY TABLE agiloftProjectCodeTemp
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

	-- Create the Temp Table in EPM with ProjectCode data
	EXEC (@strSQL) AT EPM

	-- Setting SQL to get distinct rows into the local temp table
	SET		@updateLocalTempTable = '
			TRUNCATE Table ProjectCodeTemp

			INSERT INTO ProjectCodeTemp 
			SELECT * FROM OPENQUERY(EPM, ''SELECT * FROM agiloftProjectCodeTemp'') EPM 
			EXCEPT 
			SELECT '+ @listStr +' FROM dbo.ProjectCode'

	-- Setting SQL to delete distinct rows from ProjectCode and insterting distinct ones with current date (date column has current_timestamp as default)
	SET		@updateLocalTable = '

			Insert into ProjectCodeHist
			SELECT '+ @listStr +', DateChanged, Current_Timestamp FROM ProjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	ProjectCodeTemp
								)
			
			DELETE ProjectCode 
			FROM ProjectCode A
			WHERE A.Number in (
									SELECT	Number
									FROM	ProjectCodeTemp
								)

			INSERT INTO ProjectCode SELECT AT.*, Current_TimeStamp From ProjectCodeTemp AT
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
	Truncate Table SubObjectCode

	Insert into SubObjectCode
	Select *
	FROM	Openquery(EPM, '
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
	')
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FiscalPeriod] WITH CHECK CHECK CONSTRAINT [FK_FiscalPeriod_FiscalYear_Year];


GO
PRINT N'Update complete.';


GO
