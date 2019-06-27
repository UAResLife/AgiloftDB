CREATE TABLE [dbo].[SubAccountHist]
(
	Id INT NOT NULL
	, AccountNumber int
	, Number nvarchar(64)
	, Name nvarchar(64)
	, Active bit
	, DateChanged DateTime Not Null
	, DateMoved DateTime Not Null Constraint DF_SubAccountHist_DateMoved Default Current_Timestamp
)
