CREATE TABLE [dbo].[FiscalYearHist]
(
	FiscalYear INT NOT NULL
	, StartDate date
	, EndDate date
	, DateChanged DateTime not null
	,DateMoved DateTime Not Null Constraint DF_FiscalYearHist_DateMoved default current_timestamp
)
