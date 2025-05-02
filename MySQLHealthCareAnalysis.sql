-- Name of datadet: Health care analysis
-- join me as put you my procees of achieving the analysis

--  SQL basic Query
-- setting date columns to actual date types for date of admisiiion and discharge date

set sql_safe_updates = 0;

alter table healthcareanalysis
modify column date_of_admission DATE;


update healthcareanalysis
set date_of_admission = STR_TO_DATE(date_of_admission, '%m/%d/%Y');


select *
from healthcareanalysis;

-- discharge date

update healthcareanalysis
set discharge_date = STR_TO_DATE(discharge_date, '%m/%d/%Y');


alter table healthcareanalysis
modify column discharge_date date;



-- top 5 years with with the highest admissions

select
year(date_of_admission) as admission_year,
COUNT(*) as total_admissions
from healthcareanalysis
group by year(date_of_admission)
order by total_admissions desc
limit 5;



-- top 10 hospital with highest number of admissions

select distinct hospital as names_hospital, count(*) as total_num_admit
from healthcareanalysis
group by hospital
order by count(*) desc
limit 10;

-- number of hospitals

select COUNT(distinct hospital) as total_hospitals
from healthcareanalysis;


-- patient with the highest bill

select patient_id, round(sum(billing_amount),0) as total_bill
from healthcareanalysis
group by patient_id
order by round(sum(billing_amount),0) desc;

-- Find all unique medical conditions treated in the hospital

select hospital, medical_condition
from healthcareanalysis
group by hospital, medical_condition;


-- What is the total billing amount grouped by insurance provider?

select insurance_provider, round(sum(billing_amount),0) as total_billing_amt
from healthcareanalysis
group by insurance_provider;

-- Find the average stay duration (discharge - admission) by admission type

select round(AVG(DATEDIFF(discharge_date, date_of_admission)),1) AS average_stay_days, medical_condition
from healthcareanalysis
group by medical_condition;

-- Find the average stay duration (discharge - admission) by admission type.

select round(AVG(DATEDIFF(discharge_date, date_of_admission)),1) AS average_stay_days, admission_type
from healthcareanalysis
group by admission_type;

-- Which medical conditions are diagnosed the most, and do they affect certain groups of people more than others?

select medical_condition, count(*) as no_cases
from healthcareanalysis
group by medical_condition
order by count(*) desc;

select distinct min(age), max(age)
from healthcareanalysis;

SELECT 
    medical_condition,
    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 35 THEN '18 - 35'
        WHEN age BETWEEN 36 AND 60 THEN '36 - 60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_cases
    
from healthcareanalysis
group by medical_condition, age_group
order by total_cases desc;

-- How long do patients typically stay in the hospital for different conditions? Does this vary depending on the hospital or type of admission (emergency, urgent, or planned)?

select medical_condition, 
hospital,
(avg(datediff(discharge_date, date_of_admission))) AS average_stay_days
from healthcareanalysis
group by medical_condition, hospital;

-- Which hospitals are treating the most patients, and how do they compare in terms of patient outcomes, like test results?
alter table healthcareanalysis
rename column `Test Results` to test_result;

select hospital, test_result
from healthcareanalysis
group by hospital, test_result;

-- What medications are most often prescribed for each condition? Are they being used consistently across hospitals?

select medical_condition, Medication, hospital, count(*) as total_presc
from healthcareanalysis
group by medical_condition, Medication, hospital;

-- How are patients admitted - mostly through emergency, urgent, or planned admissions - and how does that impact the length of stay or treatment costs?

select admission_type,
(avg(datediff(discharge_date, date_of_admission))) AS average_stay_days,
round(avg(billing_amount),0) as avg_cost
from healthcareanalysis
group by admission_type;

 
-- Which insurance companies are covering the most patients, and how does that relate to treatment costs 
-- and patient outcomes?

select insurance_provider,
count(patient_id) as total_no_patients,
round(sum(billing_amount),0) as total_amt_spent$,
test_result
from healthcareanalysis
group by insurance_provider,test_result;
