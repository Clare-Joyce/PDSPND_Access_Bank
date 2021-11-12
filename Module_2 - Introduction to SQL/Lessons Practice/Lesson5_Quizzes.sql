-- SQL Data Cleaning.
-- LEFT pulls a specified number of characters for each row in a specified column starting at the beginning (or from the left)
-- RIGHT pulls a specified number of characters for each row in a specified column starting at the end (or from the right)
-- LENGTH provides the number of characters for each row of a specified column

-- Quiz 1
-- Question 1
-- In the accounts table, there is a column holding the website for each company.
-- The last three digits specify what type of web address they are using. A list
-- of extensions (and pricing) is provided here. Pull these extensions and provide
-- how many of each website type exist in the accounts table.
with t1 as (select right(website, 3) as website_type
			from accounts)

select website_type,
	   count(website_type)
from t1
group by website_type


-- Question 2
-- There is much debate about how much the name (or even the first letter of a company name) 
-- matters. Use the accounts table to pull the first letter of each company name to see the
-- distribution of company names that begin with each letter (or number).
with t1 as (select left(name, 1) as company_name
			from accounts)
select company_name,
	   count(company_name) as letter_count
from t1
group by company_name
order by company_name

-- Question 3
-- Use the accounts table and a CASE statement to create two groups: one group of company names 
-- that start with a number and a second group of those company names that start with a letter.
-- sWhat proportion of company names start with a letter?
with t1 as (select left(name, 1) as company_name
			from accounts),

     t2 as (select company_name,
                   count(company_name) as letter_count
            from t1
            group by company_name
            order by company_name),
            
     t3 as (select letter_count,
            case when upper(company_name) in ('0','1','2','3','4','5','6','7','8','9') then 'num'
                 else 'letter'
            end as num_or_letter
            from t2)

select num_or_letter, sum(letter_count)
from t3
group by num_or_letter

-- Question 4
-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
-- and what percent start with anything else?
with t1 as (select left(name, 1) as company_name
			from accounts),
     t2 as (select company_name,
                   count(company_name) as letter_count
            from t1
            group by company_name
            order by company_name),
            
     t3 as (select letter_count,
            case when lower(company_name) in ('a','e','i','o','u') then 'vowel'
                 else 'other'
            end as vowel_or_not
            from t2)

select vowel_or_not, sum(letter_count)
from t3
group by vowel_or_not


-- POSITION takes a character and a column, and provides the index where that character is for each row.
-- POSITION(',' IN city_state)
-- STRPOS provides the same result as POSITION, but the syntax for achieving those results is a bit different.
-- STRPOS(city_state, ',')
-- POSITION and STRPOS are case sensitive
-- LOWER or UPPER to make all of the characters lower or uppercase

-- QUIZ 2
-- Question 1
-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc

select left(primary_poc, strpos(primary_poc, ' ')-1) as first_name,
       right(primary_poc, length(primary_poc)- strpos(primary_poc, ' ')) as last_name
from accounts;


-- Question 2
-- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns

select left(name, strpos(name, ' ')-1) as first_name,
       right(name, length(name)- strpos(name, ' ')+1) as last_name
from sales_reps;

-- CONCAT(first_name, ' ', last_name) 
-- piping: first_name || ' ' || last_name.

-- QUIZ 3
-- Question 1
-- Each company in the accounts table wants to create an email address for each primary_poc.
-- The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
with names as (select id,
                      left(primary_poc, strpos(primary_poc, ' ')-1) as first_name,
                      right(primary_poc, length(primary_poc)- strpos(primary_poc, ' ')) as last_name
               from accounts),

    fullnames as (select id,
                         concat(names.first_name,'.', names.last_name) as full_name
                  from names),

    company_names as (select id,
                            accounts.name as c_name
                     from accounts)

select concat(fullnames.full_name, '@', company_names.c_name, '.com')
from fullnames
join company_names
on fullnames.id=company_names.id;

-- Question 2
-- You may have noticed that in the previous solution some of the company names include spaces, which will
-- certainly not work in an email address. See if you can create an email address that will work by removing
-- all of the spaces in the account name, but otherwise your solution should be just as in question 1.
-- Some helpful documentation is here.
with names as (select id,
                      left(primary_poc, strpos(primary_poc, ' ')-1) as first_name,
                      right(primary_poc, length(primary_poc)- strpos(primary_poc, ' ')) as last_name
               from accounts),

    fullnames as (select id,
                         concat(names.first_name,'.', names.last_name) as full_name
                  from names),

    company_names as (select id,
                            replace(accounts.name, ' ', '')as c_name
                     from accounts)

select concat(fullnames.full_name, '@', company_names.c_name, '.com')
from fullnames
join company_names
on fullnames.id=company_names.id;

-- Question 3
-- We would also like to create an initial password, which they will change after their first log in. The first
-- password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their
-- first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name
-- (lowercase), the number of letters in their first name, the number of letters in their last name, and then the
-- name of the company they are working with, all capitalized with no spaces.

with names as (select id,
                      left(primary_poc, strpos(primary_poc, ' ')-1) as first_name,
                      right(primary_poc, length(primary_poc)- strpos(primary_poc, ' ')) as last_name
               from accounts),

    fullnames as (select id as fid,
                         concat(names.first_name,'.', names.last_name) as full_name
                  from names),

    company_names as (select id as cid,
                            replace(accounts.name, ' ', '')as c_name
                     from accounts),
    
    passwords as (select id as pid,
                         concat(lower(left(names.first_name, 1)),
                                lower(right(names.first_name, 1)),
                                lower(left(names.last_name, 1)), 
                                lower(right(names.last_name, 1)),
                                length(names.first_name),
                                length(names.last_name),
                                upper(company_names.c_name)
                                ) as pw
                  from names
                  join company_names
                  on names.id=company_names.cid
                  )            

select fullnames.fid,
       lower(concat(fullnames.full_name, '@', company_names.c_name, '.com')) as email,
       passwords.pw as init_password
from fullnames
join company_names
on fullnames.fid=company_names.cid
join passwords
on fullnames.fid=passwords.pid;

-- TO_DATE
-- CAST: CAST(date_column AS DATE)
-- Casting with :: e.g date_column::DATE

-- Quiz 4: new data set used here
with dates as (select date,
                      replace(left(date, strpos(date, ' ')), '/', '-') as new_date
               from sf_crime_data)
                                   
select cast(concat(substr(new_date, 7, 4),
                   '-',
                   substr(new_date, 1, 3),
                   substr(new_date, 4, 2)
                   ) as date
            ) as correct_format
from dates;

-- simple way to do the above
select date,
       cast(date as date) as new_date
from sf_crime_data;


-- COALESCE returns the first non-NULL value passed for each row