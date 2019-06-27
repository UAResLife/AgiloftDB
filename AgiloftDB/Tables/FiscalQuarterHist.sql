CREATE TABLE [dbo].[FiscalQuarterHist]
(
	Id INT NOT NULL
	, Number int
	, Name nvarchar(64)
	, DateChanged DateTime not null
	, DateMoved DateTime Not Null Constraint DF_FiscalQuarterHist_DateMoved default current_timestamp
)
