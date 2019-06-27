CREATE TABLE [dbo].[ProjectCodeTemp]
(
	Code nvarchar(16) NOT NULL Constraint PK_ProjectCodeTemp_Code PRIMARY KEY
	, Name Nvarchar(64)
	, Description Nvarchar(MAX)
	, Active bit
)
