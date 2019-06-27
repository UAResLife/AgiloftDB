CREATE TABLE [dbo].[SubAccountTemp]
(
	Id INT NOT NULL Constraint PK_SubAccountTemp_ID PRIMARY KEY
	, AccountNumber int
	, Number nvarchar(64)
	, Name nvarchar(64)
	, Active bit
)
