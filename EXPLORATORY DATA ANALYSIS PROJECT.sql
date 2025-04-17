-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoff_staging2;


SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoff_staging2;

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off =1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging2;


SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT substring(`date`,1,7) as `Month`, SUM(total_laid_off)
FROM layoff_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY substring(`date`,1,7)
ORDER BY 1 ASC;

WITH rolling_total AS
(SELECT substring(`date`,1,7) as `Month`, SUM(total_laid_off) AS total_off
FROM layoff_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY substring(`date`,1,7)
ORDER BY 1 ASC
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM rolling_total;

SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
ORDER BY ranking ASC
)
SELECT *
FROM company_year_rank
WHERE ranking <=5;
