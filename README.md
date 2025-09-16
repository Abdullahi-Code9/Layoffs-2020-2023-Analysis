# SQL Data Cleaning & Exploratory Data Analysis (EDA) - Layoffs 2020 - 2023

##  Project Overview
This project focuses on **cleaning and analyzing the 2022 Layoffs dataset** using SQL.  
The dataset contains global layoff records from companies across multiple industries.  
The project is divided into two phases:
1. **Data Cleaning** – Making the dataset accurate, consistent, and analysis-ready.  
2. **Exploratory Data Analysis (EDA)** – Uncovering trends and insights from the cleaned data.

##  Phase 1: Data Cleaning
##  Steps in Data Cleaning
1. **Remove Duplicates**  
   - Used `ROW_NUMBER()` to detect and delete duplicates.  

2. **Standardize Data**  
   - Trimmed whitespace in company names.  
   - Standardized `industry` (e.g., all variations of "Crypto" → "Crypto").  
   - Fixed inconsistent country names (e.g., "United States." → "United States").  
   - Converted `date` column from text to proper `DATE` format.  

3. **Handle Null / Missing Values**  
   - Replaced blank industries with `NULL`.  
   - Used self-joins to fill in missing industry values based on the same company.  
   - Removed rows where both `total_laid_off` and `percentage_laid_off` were missing.  

4. **Final Cleaning**  
   - Dropped helper column `row_num`.  
   - Stored the clean data in a staging table `layoffs_staging2`.

##  Phase 2: Exploratory Data Analysis (EDA)
##  Steps in EDA
1. **Date Range of Dataset**
```sql
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;
```
**✅ Shows earliest and latest layoffs in the dataset.**

2. **Companies with 100% Layoffs**
```sql
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
```
**✅ Identifies companies that shut down completely.**

3. **Top Companies by Total Layoffs**
```sql
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC;
```
**✅ Amazon, Google, and Meta reported the highest layoffs.**

4. **Layoffs by Industry**

```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
```
**✅ TWhile layoffs occurred across many sectors, tech-related industries — including Hardware, Crypto, Security, and Infrastructure — experienced the highest combined job losses.**

5. **Layoffs by Country**
```sql
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
```
**✅ The United States had the majority of layoffs.**

6. **Layoffs Over Time (Monthly + Rolling Total)**
```sql
WITH Rolling_Total AS 
(
  SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off 
  FROM layoffs_staging2
  GROUP BY `month` 
)
SELECT `month`, total_off,
SUM(total_off) OVER(ORDER BY `month`) AS Rolling_Total     
FROM Rolling_Total;
```
**✅ Shows cumulative layoffs month by month.**

7. **Top 5 Companies per Year (Ranked)**
```sql
WITH Company_Year (company, years, total_laid_off) AS
(
  SELECT company, YEAR(`date`), SUM(total_laid_off)
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
  SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
  FROM Company_Year
  WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
```
**✅ Lists the top 5 companies with the most layoffs each year.**

8. **Key Insights**

- Layoffs spanned from 2020 to 2023.

- Meta, Amazon, and Google were among the companies with the largest layoffs.

- The United States accounted for most layoffs.

- The Tech industry faced the biggest cuts.

- Layoffs increased significantly in late 2022.

## Dataset
- Source: [Kaggle - Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)  
- Raw dataset: `layoffs.csv`  
- Clean dataset stored in: `layoffs_staging2`  

## How to Reproduce
1. Clone this repo  
   ```bash
   git clone https://github.com/Abdullahi-Code9/sql-data-cleaning-layoffs-2022.git









