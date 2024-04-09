-- Data cleaning project
-- In this project we have club member data that we need to clean.
--
-- We will perfomr the following operations to clean the data:
--
-- Split columns into multiple columns
-- Remove unnecessary spaces and special characters
-- Remove duplicated entries
-- Check for empty values
-- Make sure the entires are in a proper format and within an acceptable range

-- Split the full name into first name and last name
-- Some names have white spaces (multiple trailing spaces) and not all of the names follow the same case. 
-- We will use the Trim function to remove the white spaces and the Lower function to make the whole name lower case.

SELECT full_name, trim(lower(full_name))
FROM club_member_info;

-- We also need to address the issue with unneccessary characters and separate the full names into first and last names. To do this we will use substring functions.

SELECT full_name, 
left(replace(trim(lower(full_name)),'?',''),locate(' ',replace(trim(lower(full_name)),'?',''))) AS first_name,
right(replace(trim(lower(full_name)),'?',''), (length(replace(trim(lower(full_name)),'?','')) - locate(' ',replace(trim(lower(full_name)),'?','')))) AS last_name
FROM club_member_info
;


-- Some of the ages are tripple-digit numbers. Assuming that the last digit is duplicated or extra, we will trim the last digit from tripple-digit ages.
-- First let's check if there are any Realistic 3-digit ages, meaning under 120

SELECT age
FROM club_member_info
Where length(age) = 3
;

-- There are no such ages. Let's proceed with the trim

SELECT age,
	CASE
		When length(age) = 3 THEN left(age, 2)
        Else age
    END age_trimmed
FROM club_member_info
Where length(age) = 3
;

-- The column 'martial_status' should be renamed as 'marital_status'. Also there are some entries in this column named 'divored' which we will change to 'divorced'

Select martial_status,
CASE
			WHEN trim(martial_status) = 'divored' THEN 'divorced'
            ELSE trim(martial_status)
		END AS marital_status
FROM club_member_info
;


-- Let's remove trailing edges from emails and adjust them to lower case.

SELECT email, trim(lower(email)) AS email_address
FROM club_member_info
;


-- Some of the phone numbers are missing the last digits and/or have trailing edges. A proper phone number should have 10 digits and 2 dashes (length should be 12). 
-- We should disregard any phone numbers that are less than 12 in length, therefore, we'll move such entries to NULL

SELECT phone,
	CASE
		WHEN trim(phone) = '' THEN NULL
		WHEN length(trim(phone)) < 12 THEN NULL
		ELSE trim(phone)
	END AS phone_number
FROM club_member_info
;



-- Let's split the addresses into 3 parts: street_address, city and state.

SELECT full_address, 
SUBSTRING_INDEX(trim(lower(full_address)), ',', 1) AS street_address,
Right(SUBSTRING_INDEX(trim(lower(full_address)), ',', 2),length(SUBSTRING_INDEX(full_address, ',', 2))-length(SUBSTRING_INDEX(full_address, ',', 1))-1) AS city,
Right(SUBSTRING_INDEX(trim(lower(full_address)), ',', 3),length(SUBSTRING_INDEX(full_address, ',', 3))-length(SUBSTRING_INDEX(full_address, ',', 2))-1) AS state
FROM club_member_info
;

-- Let's adjust the job titles.
-- Job titles have roman numberics to indicate the level of seniority. Let's switch the roman numeric values to the following format: 'Level 1'.

SELECT job_title,
	CASE
		WHEN right(job_title, 2) = ' I' THEN trim(replace(job_title, ' I', ' Level 1'))
        WHEN right(job_title, 3) = ' II' THEN trim(replace(job_title, ' II', ' Level 2'))
		WHEN right(job_title, 4) = ' III' THEN trim(replace(job_title, ' III', ' Level 3'))
        WHEN right(job_title, 3) = ' IV' THEN trim(replace(job_title, ' IV', ' Level 4'))
        ELSE trim(job_title)
    END AS occupation
FROM club_member_info
;

-- Some values in membership dates have 1900s in years. Assuming that 19 was selected instead of 20 during data entry, we'll replace 19 to 20 for these dates.

SELECT membership_date, right(membership_date, 4), Replace(membership_date, Left(right(membership_date, 4),2), '20')
FROM club_member_info
WHERE right(membership_date, 4) <2000
;

-- Let's now put it all together and create a temp table.


DROP TABLE IF EXISTS club_member_info_cleaned;
CREATE TABLE club_member_info_cleaned AS (

SELECT
left(replace(trim(lower(full_name)),'?',''),locate(' ',replace(trim(lower(full_name)),'?',''))) AS first_name,
right(replace(trim(lower(full_name)),'?',''), (length(replace(trim(lower(full_name)),'?','')) - locate(' ',replace(trim(lower(full_name)),'?','')))) AS last_name,
	CASE
		When length(age) = 3 THEN left(age, 2)
		Else age
	END age_trimmed,
	CASE
			WHEN trim(martial_status) = 'divored' THEN 'divorced'
            ELSE trim(martial_status)
	END AS marital_status,
trim(lower(email)) AS email_address,
	CASE
		WHEN trim(phone) = '' THEN NULL
		WHEN length(trim(phone)) < 12 THEN NULL
		ELSE trim(phone)
	END AS phone_number,
SUBSTRING_INDEX(trim(lower(full_address)), ',', 1) AS street_address,
Right(SUBSTRING_INDEX(trim(lower(full_address)), ',', 2),length(SUBSTRING_INDEX(full_address, ',', 2))-length(SUBSTRING_INDEX(full_address, ',', 1))-1) AS city,
Right(SUBSTRING_INDEX(trim(lower(full_address)), ',', 3),length(SUBSTRING_INDEX(full_address, ',', 3))-length(SUBSTRING_INDEX(full_address, ',', 2))-1) AS state,
	CASE
		WHEN right(job_title, 2) = ' I' THEN trim(replace(job_title, ' I', ' Level 1'))
        WHEN right(job_title, 3) = ' II' THEN trim(replace(job_title, ' II', ' Level 2'))
		WHEN right(job_title, 4) = ' III' THEN trim(replace(job_title, ' III', ' Level 3'))
        WHEN right(job_title, 3) = ' IV' THEN trim(replace(job_title, ' IV', ' Level 4'))
        ELSE trim(job_title)
    END AS occupation,
Replace(membership_date, Left(right(membership_date, 4),2), '20') AS membership_date
FROM club_member_info
)
;

SELECT *
FROM club_member_info_cleaned;


-- Let's now check if there are any duplicate values by checking the emails. The emails should be unique.
-- We'll do this by grouping the data by email_address and check if there are more than 1 entries for any emails.


SELECT email_address, count(email_address)
FROM club_member_info_cleaned
GROUP BY email_address
HAVING count(email_address) >1
;

-- Let's now delete these entries from our new table

DELETE FROM club_member_info_cleaned
WHERE email_address IN ('tdunkersley8u@dedecms.com', 'slamble81@amazon.co.uk', 'omaccaughen1o@naver.com', 'nfilliskirkd5@newsvine.com', 'mmorralleemj@wordpress.com', 'hbradenri@freewebs.com', 'greglar4r@answers.com', 'gprewettfl@mac.com', 'ehuxterm0@marketwatch.com' )