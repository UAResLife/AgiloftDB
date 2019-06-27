CREATE TABLE [dbo].[SubObjectCode]
(
	Number Nvarchar(16) NOT NULL Constraint PK_SubObjectCode_Number PRIMARY KEY
	, Name Nvarchar(64)
	, DateChanged DateTime Not Null Constraint DF_SubObjectCode_DateChanged Default Current_Timestamp
)
