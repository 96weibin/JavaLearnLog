from Employee e where e.isValid = true 
and SUBSTR(e.employee_ID, 1, 1) IN ('W','E') 
and e.department.checkFlag=true
and e.department.deptPath like '% department_ID %'

and eop.employee.employee_ID like 'WS%' 
and e.workDepartment.department_ID = '10000346'
and eop.isValid = true and eop.isMaster = true