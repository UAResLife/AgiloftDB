CREATE TABLE [dbo].[Account]
(
	Number INT NOT NULL Constraint PK_Account_AccountNumber PRIMARY KEY
	, Name Nvarchar(64)
	, Closed bit
	, DateChanged DateTime Not Null Constraint DF_Account_DateChanged Default Current_Timestamp
)
