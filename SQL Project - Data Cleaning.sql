-- SQL Project - Data Cleaning
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns or Rows

-- Create a staging table
CREATE TABLE layoffs_staging
LIKE layoffs;


-- Insert data into the staging table "layoffs_staging" from the raw table  "layoffs"
INSERT layoffs_staging
SELECT *
FROM layoffs;


-- Confirm data inserted into the staging table "layoffs_staging"
SELECT *
FROM layoffs_staging;


-- Identify duplicates with ROW_NUMBER()
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- Create a CTE
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Investigate the company 'Casper' further
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



-- Create a second staging table "layoffs_staging2" to handle duplicates and also add row_num column
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Confirm table creation
SELECT *
FROM layoffs_staging2;


-- Insert data into the second staging table "layoffs_stagings2" from the first staging table "layoffs_staging"
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


-- Confirm table population
SELECT *
FROM layoffs_staging2;


-- Confirm table population
SELECT *
FROM layoffs_staging2;


-- Identify duplicates 
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- Remove duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- Verify duplicates removal
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardize data
SELECT company, TRIM(company)
FROM layoffs_staging2;

-- Update table
UPDATE layoffs_staging2
SET company = TRIM(company);


-- Investigate the industry column
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT DISTINCT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


--  UPDATE the industry column from the second staging table "layoffs_staging2"
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Investigate the country column
SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE "United States%"
ORDER BY country;

SELECT DISTINCT country,  TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY country;



-- UPDATE the country column from the second staging table "layoffs_staging2"
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';



-- Investigate the date column
SELECT DISTINCT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- UPDATE the date column from the second staging table "layoffs_staging2"
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- Convert date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Handling nulls and missing values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Set missing values to null on the industry column
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';
-- Confirm
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
;
-- Investigate 'Airbnb' from the company column further
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Self Join the layoffs_staging2 table
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
;
-- UPDATE the industry column from the second staging table "layoffs_staging2" to fill in the null values
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

-- Investigate 'Bally's Interactive' from the company column further
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- Check where total_laid_off and percentage_laid_off columns have null values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Remove all rows with null values on the total_laid_off and percentage_laid_off 
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Drop the row_num column from the layoffs_staging2 table;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;













































