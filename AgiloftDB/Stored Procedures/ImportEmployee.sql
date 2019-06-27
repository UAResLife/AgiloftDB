CREATE PROCEDURE [dbo].[ImportEmployee]
AS
	-- Get distinct rows into the local temp table

			TRUNCATE Table EmployeeTemp;

			WITH E AS
			(
				SELECT * FROM OPENQUERY(EPM, '
						SELECT E.NetID
								, EmplID
								, FirstName
								, LastName
								, PreferredFirstName
								, PreferredLastName
								, Department
								, UNIT
								, PrimaryJobPosition
								, Email
								, OfficePhone
								, EmployeeStatus
								, TerminationDate
								, SupervisorNetID
						FROM (
							SELECT    E.NetID
									, E.EmplID
									, E.FIRST_NAME FirstName
									, E.LAST_NAME LastName
									, E.PREF_FIRST_NAME PreferredFirstName
									, E.PREF_LAST_NAME PreferredLastName
									, E.DEPT_NAME Department
									, E.UNIT
									, E.UA_TITLE_CONCAT PrimaryJobPosition
									, E.EMAIL_ADDR Email
									, E.WORK_PHONE OfficePhone
									, E.EMPL_STAT_CD EmployeeStatus
									, E.TERMINATION_DT TerminationDate
									, E.SUPERVSR_NETID SupervisorNetID
									, Row_Number() Over (Partition by E.NetID order by CASE WHEN UNIT is not null then 1 else 2 END, CASE WHEN SUPERVSR_NETID = ''-'' then 2 else 1 END) ORD
							FROM SYSADM.PS_UA_DPT_RSD_EMPL E
						) E
						WHERE ORD = 1
				')
			)

			INSERT INTO EmployeeTemp 
			SELECT * FROM E 
			EXCEPT 
			SELECT [NetID]
					, EmplID 
					, [FirstName]
					, [LastName]
					, [PreferredFirstName]
					, [PreferredLastName]
					, [Department]
					, [Unit]
					, [PrimaryJobPosition]
					, [Email]
					, [OfficePhone]
					, [EmployeeStatus]
					, [TerminationDate]
					, [SupervisorNetID] 
			FROM dbo.Employee

	-- Delete distinct rows from Employee and insterting distinct ones with current date (date column has current_timestamp as default)

			Insert into EmployeeHist
			SELECT [NetID]
					, EmplID 
					, [FirstName]
					, [LastName]
					, [PreferredFirstName]
					, [PreferredLastName]
					, [Department]
					, [Unit]
					, [PrimaryJobPosition]
					, [Email]
					, [OfficePhone]
					, [EmployeeStatus]
					, [TerminationDate]
					, [SupervisorNetID] 
					, DateChanged
					, Current_Timestamp 
			FROM Employee A
			WHERE A.NetID in (
									SELECT	NetID
									FROM	EmployeeTemp
								)
			
			DELETE Employee 
			FROM Employee A
			WHERE A.NetID in (
									SELECT	NetID
									FROM	EmployeeTemp
								)

			INSERT INTO Employee SELECT E.*, Current_TimeStamp From EmployeeTemp E



Return @@Rowcount