CREATE TABLE [dbo].[ProjectCode]
(
	Code nvarchar(16) NOT NULL Constraint PK_ProjectCode_Code PRIMARY KEY
	, Name Nvarchar(64)
	, Description Nvarchar(MAX)
	, Active bit
	, DateChanged DateTime Not Null Constraint DF_ProjectCode_DateChanged Default Current_Timestamp
)
