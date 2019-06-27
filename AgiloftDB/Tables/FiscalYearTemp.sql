CREATE TABLE [dbo].[FiscalYearTemp]
(
	FiscalYear INT NOT NULL Constraint PK_FiscalYearTemp_FiscalYear PRIMARY KEY NonClustered
	, StartDate date
	, EndDate date
)
