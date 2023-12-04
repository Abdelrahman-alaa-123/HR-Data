-- Retrieve the total number of employees in the dataset. 
   select count([Emp Name])from general_data$
--List all unique job roles in the dataset. 
   select distinct JobRole from general_data$
--Find the average age of employees. 
	select AVG(Age) from general_data$
--Retrieve the names and ages of employees who have worked at the company for more than 5 years
	select [Emp Name],Age from general_data$ where TotalWorkingYears>5 order by Age
--Get a count of employees grouped by their department. 
	select count([Emp Name]) as [Total employees per depatment] from general_data$ group by Department 
--List employees who have 'High' Job Satisfaction.
	select [Emp Name],(select max(JobSatisfaction)) as [high]
	from general_data$ g join employee_survey_data$ e on g.EmployeeID=e.EmployeeID
	group by [Emp Name],e.EmployeeID
	having max(JobSatisfaction)>3
	order by  [Emp Name] desc
--another solution:
	select [Emp Name]from general_data$ where EmployeeID in  (select max(JobSatisfaction)from employee_survey_data$ )
--Find the highest Monthly Income in the dataset
	select max(MonthlyIncome) as [highest Monthly Income] from general_data$
--List employees who have 'Travel_Rarely' as their BusinessTravel type.
	select [Emp Name] from general_data$ where BusinessTravel='Travel_Rarely' 
--Retrieve the distinct MaritalStatus categories in the dataset. 
	select distinct MaritalStatus from general_data$
--GET a list of employees with more than 2 years of work experience but less than 4 years in their current role. 
	select [Emp Name] from general_data$ where TotalWorkingYears>=2 and YearsSinceLastPromotion<4
--List employees who have changed their job roles within the company (JobLevel and JobRole differ from their previous job). 
	SELECT e.EmployeeID,e.JobRole AS currentrole,j.JobRole AS previousrole FROM general_data$ e JOIN general_data$ j ON e.EmployeeID = j.EmployeeID WHERE e.JobRole <> j.JobRole
--the average distance from home for employees in each department. 
	select AVG(DistanceFromHome) from general_data$ group by Department
--the top 5 employees with the highest MonthlyIncome. 
	select top 5[Emp Name] from general_data$  order by MonthlyIncome desc
--Calculate the percentage of employees who have had a promotion in the last year. 
	SELECT round(SUM(CASE WHEN YearsSinceLastPromotion = 0 THEN 1 ELSE 0 END) / NULLIF(COUNT(*) * 100, 0),2)AS PromotionPercentage
	FROM general_data$;
--the employees with the highest and lowest EnvironmentSatisfaction
	select * from general_data$ where  EmployeeID = (SELECT MAX(EnvironmentSatisfaction) FROM employee_survey_data$);
	select * from general_data$ where  EmployeeID = (SELECT min(EnvironmentSatisfaction) FROM employee_survey_data$);*/
--the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4. 
	SELECT * FROM general_data$
	WHERE TotalWorkingYears = ( SELECT max(TotalWorkingYears) FROM general_data$
    WHERE EmployeeID IN ( SELECT EmployeeID FROM manager_survey_data$ WHERE PerformanceRating = 4 ))
--the employees who have the same JobRole and MaritalStatus
	SELECT * FROM general_data$ e1 JOIN general_data$ e2 ON e1.JobRole = e2.JobRole AND e1.MaritalStatus = e2.MaritalStatus;
--the average Age and JobSatisfaction for each BusinessTravel type. 
	select DISTINCT BusinessTravel, AVG(Age) OVER (PARTITION BY BusinessTravel) AS AvgAge,JobSatisfaction from general_data$ 
	join employee_survey_data$ on general_data$.EmployeeID=employee_survey_data$.EmployeeID
	where JobSatisfaction is not null
	order by BusinessTravel ,JobSatisfaction
--the average Age for each BusinessTravel type. 
	SELECT DISTINCT BusinessTravel, AVG(Age) OVER (PARTITION BY BusinessTravel) AS AvgAge FROM general_data$;
--the most common EducationField among employees.  
	select top 1 EducationField as [Common Education Field ] , count(*) AS Fieldcount from general_data$
	GROUP BY EducationField ORDER BY FieldCount DESC 
--List the employees who have worked for the company the longest
	SELECT *
	FROM general_data$
	WHERE YearsAtCompany = (
    SELECT MAX(YearsAtCompany)
    FROM general_data$
    WHERE YearsSinceLastPromotion =0
	);
--List the employees who have worked for the company the longest but haven't had a promotion
	SELECT top 5 *
	FROM general_data$
	WHERE YearsSinceLastPromotion = 0
	ORDER BY YearsAtCompany DESC
--another solution advanced
	SELECT *
	FROM (
    SELECT *,
           RANK() OVER (ORDER BY YearsAtCompany desc) AS rnk
    FROM general_data$
    WHERE YearsSinceLastPromotion = 0
	) ranked_data
	WHERE rnk = 1;
--List all unique Department in the dataset
	select distinct Department from general_data$


