
SET SQL_SAFE_UPDATES=0;
CREATE DATABASE IF NOT EXISTS HR_DB;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\hr_dat.csv"
INTO TABLE hr_dat
FIELDS TERMINATED BY ','     -- this was imployed in other to get the datafile imported into the database
ENCLOSED BY '"'                                         
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
select * from hr_dat;

-- Data preprocessing:
-- then we need to format the date format --
-- YYYY-MM-DD
-- CONFIG M/D/Y;

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
    
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>     
        
alter table hr_dat
add column Full_name varchar(50) after last_name;
select concat(first_name,' ',last_name) Full_name
from hh_dat;

update hr_dat
set Full_name = concat(first_name,' ',last_name);
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
        
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   
-- QSTN1: What is the gender breakdown in the Company?
select gender,count(*)gender_breakdown,
concat(round((select count(gender)/(select count(*) from hh_data)*100),1),'%')percent
	from hr_dat
    group by gender;
    
    
-- QSTN 2:  How many employees work remotely for each department?
select department,
count(*) Remote,
concat(round((select count(location)/(select count(*) from hr_data)*100),1),'%') percent 
from hr_dat 
where location ='remote'
group by department;


-- QSTN 3:  What is the distribution of employees who work remotely and HQ?
select location, 
count(*) frequency,
concat(round((select count(location)/(select count(*) from hr_dat)*100),1),'%')percent
from hr_dat
group by location;
    

-- QSTN 4:  What is the race distribution in the Company?
select race,
count(*) racial_breakdown,
concat(round((select count(race)/(select count(*) from hr_dat)*100),1),'%')percent
from hr_dat
group by race;
    
    
-- QSTN 5: What is the distribution of employee across different states?
select location_state,
count(*) state_breakdown,
concat(round((select count(location_state)/(select count(*) from hr_dat)*100),1),'%') percent
from hr_dat
group by location_state;


-- QSTN 6:  What is the number of employees whose employment has been terminated?
select count(date(termdate)) Laidoff 
from hr_dat
where termdate is not null and
date(termdate) < current_date();



-- QSTN 7:  Who is/are the longest serving employee in the organization.
select Age__group,gender,race,department,jobtitle,hire_date,termdate location_city 
from hr_dat
order by hire_date asc
limit 2;
 

-- QSTN 8:  Return the terminated employees by their race
select race,count(*) Frequency ,
concat(round((select count(race)/(select count(*) from hr_dat)*100),1),'%') percent 
from hr_dat
where date(termdate) < current_date()
group by race;


-- QSTN 9:  What is the age distribution in the Company?
select birthdate, round(datediff(curdate(),birthdate)/365) as staff_age from hr_dat;

alter table hr_dat
add column Age int after birthdate;

update hr_dat
set Age = round(datediff(curdate(),birthdate)/365);


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

select Age__group, 
count(*) Frequency ,
concat(round((select count(Age__group)/(select count(*) from hh_dat)*100),1),'%') percent 
from hr_dat
group by Age__group;



 -- QSTN 10: How have employee hire counts varied over time?
 select hire_date,
 year(hire_date) hire_year,
count(hire_date) frequency,
concat(round((select count(hire_date)/(select count(*) from hr_dat)*100),1),'%') percent 
from hr_dat
group by hire_year
order by hire_year asc;
 
 
 
 -- QSTN 11:  What is the tenure distribution for each department?
select department,
sum(case when datediff(termdate,hire_date) is null then 1
	when datediff(termdate,hire_date)< 365 then 1 
    else 0
    end) as '<1 year',
sum(case when datediff(termdate,hire_date) between 365 and 1825 then 1
else 0
end) as '1-5years',
sum(case when datediff(termdate,hire_date) between 1826 and 3650 then 1
else 0 
end ) as '5-10years',
sum(case when datediff(termdate,hire_date)>=3651 then 1
else 0
end) as '11 years+'
from hr_dat
group by department;


-- QSTN 12: What is the average length of employment in the company?
select round(avg(datediff(curdate(),hire_date)/365),1) Avg_emp from hr_dat;



-- QSTN 13:  Which department has the highest turnover rate?
 
select department,hire_date, 
(select count(id) from hr_dat where year(hire_date) <='2020')TOTAL_HIRE,
(select count(id) from hr_dat where date(termdate) < current_date())LEFTT,
CONCAT(ROUND((select count(id) from hr_dat where date(termdate) < current_date()) /
(select ROUND(count(id)/2,1) from hr_dat where year(hire_date) <='2020')*100,1),'%') COMPANY_TURNOVER,
CONCAT(ROUND((select count(id)) /
(select ROUND(count(id)/2,1) from hr_dat where year(hire_date) <='2020')*100,1),'%')DEPARTMENT_RATE from hr_dat
where date(termdate) < current_date()
group by department;


 






   
    
    




     