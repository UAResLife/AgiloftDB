CREATE VIEW [dbo].[Employee_vw]
	AS 

	SELECT NetID
			, dbo.NoDashOrNull(FirstName) FirstName
			, dbo.NoDashOrNull(LastName) LastName
			, dbo.NoDashOrNull(PreferredFirstName) PreferredFirstName
			, dbo.NoDashOrNull(PreferredLastName) PreferredLastName
			, dbo.NoDashOrNull(Department) Department
			, dbo.NoDashOrNull(Unit) Unit
			, dbo.NoDashOrNull(PrimaryJobPosition) PrimaryJobPosition
			, dbo.NoDashOrNull(Email) Email
			, dbo.NoDashOrNull(OfficePhone) OfficePhone
			, dbo.NoDashOrNull(EmployeeStatus) EmployeeStatus
			, TerminationDate
			, dbo.NoDashOrNull(SupervisorNetID) SupervisorNetID
			, dbo.NoDashOrNull(EmplID) EmplID
	FROM	Employee
	WHERE	FirstName is not null
			AND LastName is not null

