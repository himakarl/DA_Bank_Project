#Drop table finance_1;
#Drop table finance_2;

Desc finance_1;
Alter table finance_1 modify column issue_d date;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank/finance_1.csv' into table finance_1
FIELDS TERMINATED by ','
optionally  enclosed by '"'
lines terminated by '\r\n'
IGNORE 1 rows;

Select * from finance_1;


Alter table finance_2 modify column last_credit_pull_d date;
Alter table finance_2 modify column last_pymnt_d date;
Alter table finance_2 modify column earliest_cr_line date;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank/finance_2.csv' into table finance_2
FIELDS TERMINATED by ','
optionally  enclosed by '"'
lines terminated by '\r\n'
IGNORE 1 rows;

Select * from finance_2;
truncate finance_2;

desc finance_2;

select count(*) from finance_1;
select * from finance_1 limit 39717;
select count(*) from finance_2;
select * from finance_2 limit 39717;

#KPI 1 Year wise loan amount 
select year(issue_D) as Year, sum(loan_amnt) as Loan_Amount
from finance_1
group by Year
order by Year;

#KPI 2 Grade and Sub Grade wise Revol_Bal
select grade as Grade, sub_grade as Sub_Grade, sum(revol_bal) as Revol_Bal
from finance_1 inner join finance_2
on(finance_1.id = finance_2.ï»¿id)
group by grade, sub_grade
order by grade, sub_grade;

#KPI 3 Total Payment for verified status Vs Total Payment for Non Verified Status
select verification_status, concat("$",format(round(sum(total_pymnt)/1000000,2),2)," ","M") as Total_Payment 
from finance_1 inner join finance_2
on(finance_1.id = finance_2.ï»¿id)
group by verification_status;

#KPI 4 State wise loan status 
select addr_state as State, loan_status as Loan_Status, sum(loan_amnt) as Loan_amnt
from finance_1 
group by addr_state, loan_status
Order by addr_state;

#KPI 5 Home Ownership Vs last payment date stats
select home_ownership, last_pymnt_d,concat("$",format(round(sum(last_pymnt_amnt)/10000,2),2)," ","K") as Last_Payment_Amount
from finance_1 inner join finance_2
on(finance_1.id = finance_2.ï»¿id)
group by home_ownership, last_pymnt_d
order by last_pymnt_d desc, home_ownership desc;

select count(id) as Number_of_customers from finance_1;
select concat("$",format(round(sum(loan_amnt)/10000,2),2)," ","k") as Total_loan_amt from finance_1;
select concat(format(round(avg(int_rate)*100,2),2)," ","%") as Average_int_rate from finance_1;
select concat(format(round(avg(dti),2),2)," ","%") as Average_dti from finance_1;
