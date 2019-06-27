CREATE TABLE [dbo].[EmployeeTemp]
(
	[NetID] NVARCHAR(64) NOT NULL Constraint PK_EmployeeTemp_NetID Primary Key Clustered
	,EmplID nvarchar(16)
	,FirstName Nvarchar(64)
	,LastName Nvarchar(64)
	,PreferredFirstName NVARCHAR(64)
	,PreferredLastName NVARCHAR(64)
	,Department NVARCHAR(64)
	,Unit NVARCHAR(64)
	,PrimaryJobPosition NVARCHAR(128)
	,Email NVARCHAR(64)
	,OfficePhone NVARCHAR(32)
	,EmployeeStatus NVARCHAR(16)
	,TerminationDate DateTime
	,SupervisorNetID NVARCHAR(64) NULL
)
