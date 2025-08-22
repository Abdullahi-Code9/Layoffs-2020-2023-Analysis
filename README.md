# SQL Data Cleaning Project - Layoffs 2022 Dataset

##  Project Overview
This project focuses on cleaning and preparing the **2022 Layoffs dataset** from Kaggle.  
The main goal was to apply **SQL-based data cleaning techniques** to ensure data quality and consistency.

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

## Dataset
- Source: [Kaggle - Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)  
- Raw dataset: `layoffs.csv`  
- Clean dataset stored in: `layoffs_staging2`  

## How to Reproduce
1. Clone this repo  
   ```bash
   git clone https://github.com/<your-username>/sql-data-cleaning-layoffs-2022.git
