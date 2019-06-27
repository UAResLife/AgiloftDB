CREATE TABLE [dbo].[ObjectCodeHist]
(
	Number nvarchar(16) NOT NULL
	, Name nvarchar(64)
	, DateChanged DateTime Not Null
	, DateMoved DateTime Not Null Constraint DF_ObjectCodeHist_DateMoved Default Current_Timestamp
)
