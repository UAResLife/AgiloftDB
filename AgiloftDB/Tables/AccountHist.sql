CREATE TABLE [dbo].[AccountHist]
(
	Number INT NOT NULL
	, Name Nvarchar(64)
	, Closed bit
	, DateChanged datetime not null
	, DateMoved dateTime Not Null constraint DF_AccountHist_DateMoved default current_timestamp

)
