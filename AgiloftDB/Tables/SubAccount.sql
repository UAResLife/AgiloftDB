CREATE TABLE [dbo].[SubAccount]
(
	Id INT NOT NULL Constraint PK_SubAccount_ID PRIMARY KEY
	, AccountNumber int
	, Number nvarchar(64)
	, Name nvarchar(64)
	, Active bit
	, DateChanged DateTime Not Null Constraint DF_SubAccount_DateChanged Default Current_Timestamp
)
