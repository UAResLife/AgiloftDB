CREATE TABLE [dbo].[ProjectCodeHist]
(
	Code nvarchar(16) NOT NULL
	, Name Nvarchar(64)
	, Description Nvarchar(MAX)
	, Active bit
	, DateChanged DateTime Not Null
	, DateMoved DateTime Not Null Constraint DF_ProjectCodeHist_DateMoved Default Current_Timestamp
)
