# HR-MANAGEMENT-ANALYSIS
## Executive Summary
This report presents an analysis of HR Management data aimed at uncovering insights to assist the HR department in making informed decisions and strategic workforce planning. The analysis uses SQL for data querying and Power BI for visualization. Key insights include the gender breakdown, remote work distribution, race distribution, employee termination statistics, and tenure distribution across departments.
## Introduction
The purpose of this analysis is to leverage HR data to provide insights that support strategic HR decision-making and workforce planning. The scope of the project covers various aspects of employee demographics and employment patterns.
## Tools
- SQL for data extraction and manipulation.
- Power BI for visualization and reporting.
## Data Collection and Preparation
Data was collected from the company's HR database, which includes the following columns:
- id
- first_name
- last_name
- birthdate
- gender
- race
- department
- jobtitle
- location
- hire_date
- termdate
- location_city
- location_state
-- The data was cleaned to handle any missing values, duplicates, and inconsistencies. SQL queries were used to extract relevant data points, and the cleaned data was then imported into Power BI for visualization.
### Data importation 
```SQL
SET SQL_SAFE_UPDATES=0;
CREATE DATABASE IF NOT EXISTS HR_DB;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\hr_dat.csv"
INTO TABLE hr_dat
FIELDS TERMINATED BY ','     -- this was imployed in other to get the datafile imported into the database
ENCLOSED BY '"'                                         
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
select * from hr_dat;
```
### Data cleaning
```SQL
select * from hh_da
 group by id
 having count(*)>1; --checking for duplicte

update hr_dat
set birthdate = replace(birthdate,'-','/') ;

update hr_dat
set hire_date = replace(hire_date,'-','/');	

update hr_dat set birthdate = str_to_date(birthdate,'%m/%d/%Y');
update hr_dat set hire_date = str_to_date(hire_date,'%m/%d/%Y');


update hr_dat 
	set birthdate = DATE_sub(birthdate,interval 100 year) 
		where birthdate between '2065-11-01' and '2069-12-12'
        order by rand(); 
        
update hr_dat
	set race = replace (race,'American Indian or Alaska Native','American Indian')
    order by rand();
        
update hr_dat
	set race = replace (race,'Black or African American','African American')
    order by rand();        
    
update hr_dat
	set race = replace (race,'Hispanic or Latino','Latino')
    order by rand();       
    
update hr_dat
	set race = replace (race,'Native Hawaiian or Other Pacific Islander','Native Hawaiian')
    order by rand();     
    
update hr_dat
	set race = replace (race,'Two or More Races','Other Races')
    order by rand();         
            
alter table hr_dat
add column Full_name varchar(50) after last_name;
select concat(first_name,' ',last_name) Full_name
from hh_dat;

update hr_dat
set Full_name = concat(first_name,' ',last_name);

alter table hr_dat
add column Age__group varchar(20)after birthdate;

update hr_dat
set Age__group = 
case
when age >='22' and age <= '31' then 'Young Adult'
when age >='32' and age <= '41' then 'Adult'
when age >='42' and age <= '51' then 'Old'
else 'Very old'
end;
```
## Data Analysis
The analysis focuses on the following key questions and metrics:
### Gender Breakdown in the Company
- Analysis of the gender distribution among employees:
```SQL
select gender,count(*)gender_breakdown,
concat(round((select count(gender)/(select count(*) from hh_data)*100),1),'%')percent
	from hr_dat
    group by gender;
```
### Remote Work by Department
- Number of employees working remotely in each department.
```SQL
select department,
count(*) Remote,
concat(round((select count(location)/(select count(*) from hr_data)*100),1),'%') percent 
from hr_dat 
where location ='remote'
group by department;
```
### Remote vs HQ Work Distribution
- Distribution of employees working remotely versus at the headquarters.
```SQL
select location, 
count(*) frequency,
concat(round((select count(location)/(select count(*) from hr_dat)*100),1),'%')percent
from hr_dat
group by location;
```
### Race Distribution in the Company
- Analysis of the racial composition of employees.
```SQL
select race,
count(*) racial_breakdown,
concat(round((select count(race)/(select count(*) from hh_dat)*100),1),'%')percent
from hr_dat
group by race;
```
### Employee Distribution Across States
- Geographic distribution of employees across different states.
```SQL
select location_state,
count(*) state_breakdown,
concat(round((select count(location_state)/(select count(*) from hr_dat)*100),1),'%') percent
from hr_dat
group by location_state;
```
### Employee Termination Statistics
- Number of employees whose employment has been terminated.
```SQL
select count(date(termdate)) Laidoff 
from hr_dat
where termdate is not null and
date(termdate) < current_date();
```
### Longest Serving Employee
- Identification of the longest-serving employees in the organization.
```SQL
select Age__group,gender,race,department,jobtitle,hire_date,termdate,location_city 
from hr_dat
order by hire_date asc
limit 2;
```
### Terminated Employees by Race
- Analysis of terminated employees categorized by race.
```SQL
select race,count(*) Frequency ,
concat(round((select count(race)/(select count(*) from hr_dat)*100),1),'%') percent 
from hr_dat
where date(termdate) < current_date()
group by race;
```



Age Distribution in the Company

Distribution of employee ages.
sql
Copy code
SELECT DATEDIFF(year, birthdate, GETDATE()) AS age, COUNT(*) AS count
FROM employees
GROUP BY age;
Employee Hire Counts Over Time

Trends in employee hiring over time.
sql
Copy code
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS count
FROM employees
GROUP BY hire_year;
Tenure Distribution by Department

Analysis of employee tenure across different departments.
sql
Copy code
SELECT department, AVG(DATEDIFF(day, hire_date, ISNULL(termdate, GETDATE()))) AS avg_tenure
FROM employees
GROUP BY department;
Average Length of Employment

Calculation of the average length of employment in the company.
sql
Copy code
SELECT AVG(DATEDIFF(day, hire_date, ISNULL(termdate, GETDATE()))) AS avg_tenure
FROM employees;
Department with the Highest Turnover Rate

Identification of the department with the highest employee turnover rate.
sql
Copy code
SELECT department, COUNT(*) AS turnover_count
FROM employees
WHERE termdate IS NOT NULL
GROUP BY department
ORDER BY turnover_count DESC
LIMIT 1;
5. Visualizations
Key visualizations created in Power BI include:

Gender Breakdown:

Remote Work by Department:

Remote vs HQ Work Distribution:

Race Distribution:

Employee Distribution Across States:

Employee Termination Statistics:

Longest Serving Employee:

Terminated Employees by Race:

Age Distribution:

Employee Hire Counts Over Time:

Tenure Distribution by Department:

Average Length of Employment:

Department with the Highest Turnover Rate:

6. Insights and Recommendations
Key Insights:

Gender Breakdown: The gender distribution is relatively balanced, with a slight majority of male employees.
Remote Work: Certain departments have a higher number of remote workers, indicating a potential need for better remote work policies.
Race Distribution: The company has a diverse racial composition, but certain races are underrepresented.
Employee Terminations: The highest number of terminations occur in specific departments, highlighting potential areas for HR intervention.
Tenure Distribution: Some departments have higher tenure, indicating job satisfaction and stability.
Recommendations:

Enhance Remote Work Policies: Develop and implement comprehensive remote work policies to support departments with high remote work participation.
Diversity and Inclusion Programs: Launch initiatives to address racial underrepresentation and promote diversity.
Employee Retention Strategies: Focus on departments with high turnover rates by investigating underlying causes and implementing retention strategies.
Long-term Employee Recognition: Recognize and reward long-serving employees to promote job satisfaction and loyalty.
7. Conclusion
The HR management analysis has provided valuable insights into employee demographics, work distribution, and employment patterns. By implementing the recommended strategies, the company can improve employee satisfaction, retention rates, and overall HR processes. Continuous monitoring and analysis are essential to sustain these improvements.
  

  
