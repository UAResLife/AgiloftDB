CREATE TABLE [dbo].[FiscalQuarter]
(
	Id INT NOT NULL Constraint PK_FiscalQuarter_ID PRIMARY KEY NonClustered
	, Number int
	, Name nvarchar(64)
	, DateChanged DateTime Not Null Constraint DF_FiscalQuarter_DateChanged Default Current_Timestamp
)
