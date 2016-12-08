SELECT
 LAKE_NAME
, YEAR(START_DATE) AS Year
, CASE 
    WHEN MONTH(START_DATE) IN (12, 1, 2) THEN 'Winter'
    WHEN MONTH(START_DATE) BETWEEN 3 AND 5 THEN 'Spring'
    WHEN MONTH(START_DATE) BETWEEN 6 AND 9 THEN 'Summer'
    ELSE 'Fall'
  END AS Season

-- For ordering
, CASE 
    WHEN MONTH(START_DATE) IN (12, 1, 2) THEN 4
    WHEN MONTH(START_DATE) BETWEEN 3 AND 5 THEN 1
    WHEN MONTH(START_DATE) BETWEEN 6 AND 9 THEN 2
    ELSE 3
  END AS SeasonNum
  
, AVG(RECREATIONAL_SUITABILITY_RESULT) AS RECREATIONAL_SUITABILITY_RESULT
, AVG(PHYSICAL_CONDITION_RESULT) AS PHYSICAL_CONDITION_RESULT
, AVG(SECCHI_DEPTH_RESULT) AS SECCHI_DEPTH_RESULT
, AVG(TOTAL_PHOSPHORUS_RESULT) AS TOTAL_PHOSPHORUS_RESULT
FROM [datadive-142319:mces_lakes.1999_2014_monitoring_data] 
WHERE 

-- Worst lakes: Top 10 lakes with lowest Secchi depths
 LAKE_NAME IN ('Benton Lake','Hazeltine Lake','Cobblecrest Lake','Downs Lake','Penn Lake'
,'Winkler Lake','Meadow Lake','Cornelia Lake','Cedar Island Lake','Gaystock Lake')
  
-- Best lakes: Top 10 lakes with highest Secchi depths
--  LAKE_NAME IN ('West Boot Lake','Brickyard Clayhole Lake','Big Carnelian Lake','Jane Lake'
-- ,'Halfbreed Lake' /*What the hell kind of name is this?!*/,'Little Long Lake','Mays Lake'
-- ,'Christmas Lake','Little Carnelian Lake','Square Lake')
  
  
  AND SEASONAL_LAKE_GRADE_RESULT IS NULL -- Ensures seasonal records are avoided
  
GROUP BY LAKE_NAME, Year, Season, SeasonNum
ORDER BY LAKE_NAME, Year, SeasonNum
