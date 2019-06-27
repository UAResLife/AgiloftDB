CREATE TABLE [dbo].[FiscalPeriod]
(
	Id INT NOT NULL Constraint PK_FiscalPeriod_ID PRIMARY KEY NonClustered
	, Number int
	, Name nvarchar(64)
	, StartDate date
	, EndDate date
	, FiscalYear int
	, QuarterID int
	, DateChanged DateTime Not Null Constraint DF_DiscalPeriod_DateChanged Default Current_Timestamp

)
