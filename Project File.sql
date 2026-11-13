create database bank_loan;
use bank_loan;

select * from loan_approved_clean;

select * from l_approved;
select count(*) from l_approved ;

alter table loan_approved_clean rename to l_approved;
alter table l_approved drop column MyUnknownColumn;


-- What is the total number of loan application ?
select count(*) from  l_approved;

-- How many applications are approved vs rejected ?
select Loan_Status, count(*) from l_approved group by Loan_Status;

-- What is the average loan amount issued ?
select round(avg(LoanAmount),2) from l_approved where Loan_Status='Y';

-- What is the average applicant income ?
select round(avg(ApplicantIncome+CoapplicantIncome),2) from l_approved;


-- View the first 10 records from the table. 
select * from l_approved limit 10;

-- Count the total number of loan applications. 
select count(*) from l_approved;

-- List all unique property areas. 
select distinct(Property_Area) from l_approved;

-- Show all applicants who are self-employed and have an income above 5000. 
select * from l_approved where Self_Employed='Yes' and ApplicantIncome>=5000;

-- Find the total number of approved loans.
select count(Loan_Status) as approved_loan from l_approved where Loan_Status='Y';

-- Find average loan amount by education level. 
select Education,round(avg(LoanAmount),2) from l_approved group by Education;

-- Find average total income (Applicant + Coapplicant) by marital status. 
select Married,round(avg(ApplicantIncome+CoapplicantIncome),2) as average from l_approved group by Married;

-- Show average loan amount by credit history.
select Credit_History, round(avg(LoanAmount),2) from l_approved group by Credit_History;

-- Find total applications and approval rate by gender.
select 
	Gender, count(*) as applicant,
    sum(case  when Loan_Status='Y' then 1 else 0 end) as approved,
	sum(case  when Loan_Status='Y' then 1 else 0 end)/count(*)*100 as approvalRate
		from l_approved group by Gender ; 
 
-- Show approval rate by property area.
select Property_Area,
round(sum(case when Loan_Status='Y' then 1 else 0 end)/count(*)*100,2) as approvalRate
 from l_approved group by Property_Area ;
 
 
 
 
-- Show applicants who are graduates, not self-employed, and have loan amount greater than 150. 
select * from l_approved where Education='Graduate' and Self_Employed='No' and LoanAmount>150 ;
select count(*)from l_approved where Education='Graduate' and Self_Employed='No' and LoanAmount>150 ;

-- Display approved loans from urban area with good credit history. 
select * from l_approved where Property_Area='Urban' and Credit_History=1 ;
select count(*) from l_approved where Property_Area='Urban' and Credit_History=1 ;

-- List top 5 applicants with highest total income.
select * from l_approved order by ApplicantIncome+CoapplicantIncome desc limit 5; 





-- Create derived columns for total income for each applicant.
 select *, ApplicantIncome+CoapplicantIncome as totalincome from l_approved;
 -- OR
 
 alter table l_approved add column total_income decimal(10,2);
 update  l_approved set total_income= ApplicantIncome+CoapplicantIncome;
 
-- Classify applicants into income groups (Low, Medium, High) based on applicant income. 
select Loan_ID,ApplicantIncome,
		case
        when ApplicantIncome <= '1000' then 'Low Income'
		when ApplicantIncome > '1000' and ApplicantIncome < '5000' then 'Medium Income'
		else 'High Income'
		end as Income_Group from l_approved;
         
-- Find average loan amount for each income group.
select 
		case
        when ApplicantIncome<1000 then 'Low Income'
        when ApplicantIncome>1000 and ApplicantIncome<5000 then 'Medium Income'
        else 'High Income'
        end as Income_Group,
        round(avg(LoanAmount),2) as avg_loanamount
        from l_approved group by Income_Group;
        
        
        
        
        
        


-- Find applicants whose loan amount is greater than the overall average loan amount. 
select * from l_approved where LoanAmount>(select avg(LoanAmount) from l_approved) ;

-- Identify the property area with the highest average total income. 
select Property_Area,avg(ApplicantIncome+CoapplicantIncome) as avg_totalIncome from l_approved group by Property_Area order by avg_totalIncome desc;

-- List all applicants whose income is above the average income of their education category.





 -- Rank applicants based on total income (highest income rank = 1).
 select Loan_ID,
	(ApplicantIncome+CoapplicantIncome) as total_income,
	rank() over( order by (ApplicantIncome+CoapplicantIncome) desc) as Rank_number
    from l_approved;
    
-- Show average loan amount per property area using a window function.
select distinct(Property_Area), avg(LoanAmount) over(partition by Property_Area) as avg_loanAmount from l_approved;

-- Calculate approval rate by education using grouping or window function.








-- Compare approval rate by credit history and education level to find which combination performs best. 
select Credit_History,
		Education,
        count(*) as total_applicants,
        sum(case when Loan_Status='Y' then 1 else 0 end) as approvals,
        round(sum(Case when Loan_Status='Y' then 1 else 0 end)/count(*)*100) as approval_rate
        from l_approved group by Credit_History,Education order by approval_rate desc;
        
-- Find the combination of property area and education with the highest approval rate. 
select Property_Area,
		Education,
        count(*) as total_applicants,
        sum(case when Loan_Status='Y' then 1 else 0 end) as approvals,
		round(sum(Case when Loan_Status='Y' then 1 else 0 end)/count(*)*100) as approval_rate
        from l_approved group by Property_Area,Education order by approval_rate ;        

-- Compare approval rate for self-employed vs non-self-employed applicants by credit history.
select  Self_Employed,
		Credit_History,
        count(*) as total_applicants,
        sum(case when Loan_Status='Y' then 1 else 0 end) as approvals,
		round(sum(Case when Loan_Status='Y' then 1 else 0 end)/count(*)*100) as approval_rate
        from l_approved group by Self_Employed,Credit_History order by approval_rate ; 

select * from l_approved ;
select count(*) from l_approved;
