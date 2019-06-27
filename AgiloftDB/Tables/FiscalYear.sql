/*
The database must have a MEMORY_OPTIMIZED_DATA filegroup
before the memory optimized object can be created.

The bucket count should be set to about two times the 
maximum expected number of distinct values in the 
index key, rounded up to the nearest power of two.
*/

CREATE TABLE [dbo].[FiscalYear]
(
	FiscalYear INT NOT NULL Constraint PK_FiscalYear_FiscalYear PRIMARY KEY NonClustered
	, StartDate date
	, EndDate date
	, DateChanged DateTime Not Null Constraint DF_FiscalYear_DateChanged Default Current_Timestamp
) 