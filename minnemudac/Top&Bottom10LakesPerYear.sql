/* Adjust line 8 to ASC for the top 10 lakes per year with the worst quality */
SELECT *
FROM (
SELECT
 LAKE_NAME
, YEAR(START_DATE) as Year
, AVG(SECCHI_DEPTH_RESULT) AS SECCHI_DEPTH_RESULT
, RANK(SECCHI_DEPTH_RESULT) OVER (PARTITION BY Year ORDER BY SECCHI_DEPTH_RESULT DESC) AS Rank
FROM [datadive-142319:mces_lakes.1999_2014_monitoring_data] 
WHERE 
 SEASONAL_LAKE_GRADE_RESULT IS NULL -- Ensures seasonal records are avoided
   AND SECCHI_DEPTH_RESULT IS NOT NULL
   AND YEAR(START_DATE) >= 1995
GROUP BY LAKE_NAME, Year
HAVING COUNT(*) > 5
)
WHERE Rank <= 10
ORDER BY Year DESC, Rank ASC -- Using Secchi depth since physical condition/recreational condition isn't available for all lakes
