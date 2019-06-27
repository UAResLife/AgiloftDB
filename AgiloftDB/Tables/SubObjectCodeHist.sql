CREATE TABLE [dbo].[SubObjectCodeHist]
(
	Number Nvarchar(16) NOT NULL
	, Name Nvarchar(64)
	, DateChanged DateTime Not Null
	, DateMoved DateTime Not Null Constraint DF_SubObjectCodeHist_DateMoved Default Current_Timestamp
)
