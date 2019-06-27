CREATE TABLE [dbo].[FiscalPeriodTemp]
(
	Id INT NOT NULL Constraint PK_FiscalPeriodTemp_ID PRIMARY KEY NonClustered
	, Number int
	, Name nvarchar(64)
	, StartDate date
	, EndDate date
	, FiscalYear int
	, QuarterID int
)
