CREATE TABLE [dbo].[AccountTemp]
(
	Number INT NOT NULL Constraint PK_AccountTemp_AccountNumber PRIMARY KEY
	, Name Nvarchar(64)
	, Closed bit
)
