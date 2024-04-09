# Club Member Data Cleaning SQL Script

## Introduction
This SQL script is designed to clean the data of club members. The dataset may contain inconsistencies, errors, and missing information, which this script aims to address through various operations.

## Operations
The script performs the following operations:
- Splitting columns into multiple columns
- Removing unnecessary spaces and special characters
- Removing duplicated entries
- Checking for empty values
- Ensuring entries are in proper format and within acceptable ranges

## Details of Operations
### 1. Splitting Full Names
The full names are split into first names and last names. Leading and trailing spaces are removed, and the names are converted to lowercase.

### 2. Addressing Unnecessary Characters in Names
Unnecessary characters in names are removed, and full names are separated into first and last names using substring functions.

### 3. Trimming Triple-Digit Ages
Triple-digit ages are trimmed to two digits assuming the last digit is duplicated or extra.

### 4. Renaming 'Martial_Status' Column
The 'martial_status' column is renamed as 'marital_status', and 'divored' entries are changed to 'divorced'.

### 5. Adjusting Email Addresses
Trailing edges from emails are removed and adjusted to lowercase.

### 6. Validating Phone Numbers
Phone numbers missing last digits or having lengths less than 12 characters are disregarded.

### 7. Splitting Addresses
Addresses are split into three parts: street address, city, and state.

### 8. Adjusting Job Titles
Job titles with Roman numerals indicating seniority levels are switched to a standardized format ('Level X').

### 9. Correcting Membership Dates
Membership dates with years in the 1900s are corrected to the 2000s.

### 10. Creating a Cleaned Table
All the cleaning operations are combined to create a new table named 'club_member_info_cleaned'.

### 11. Checking for Duplicates
Duplicate entries are checked based on email addresses, and any duplicates found are deleted from the cleaned table.

## Usage
- Download the club_member_info.csv file and run the script data_cleaning.sql against it in your SQL environment.
