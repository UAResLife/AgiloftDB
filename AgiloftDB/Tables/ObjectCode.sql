CREATE TABLE [dbo].[ObjectCode]
(
	Number nvarchar(16) NOT NULL Constraint PK_ObjectCode_Number PRIMARY KEY
	, Name nvarchar(64)
	, DateChanged DateTime Not Null Constraint DF_ObjectCode_DateChanged Default Current_Timestamp
)
