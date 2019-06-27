CREATE TABLE [dbo].[FiscalPeriodHist]
(
	Id INT NOT NULL
	, Number int
	, Name nvarchar(64)
	, StartDate date
	, EndDate date
	, FiscalYear int
	, QuarterID int
	, DateChanged datetime not null
	, DateMoved DateTime Not Null Constraint DF_FiscalPeriodHist_DateMoved default current_timestamp
)
