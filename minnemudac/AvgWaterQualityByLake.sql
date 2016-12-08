SELECT
 LAKE_NAME

, AVG(RECREATIONAL_SUITABILITY_RESULT) AS RECREATIONAL_SUITABILITY_RESULT
, AVG(PHYSICAL_CONDITION_RESULT) AS PHYSICAL_CONDITION_RESULT
, AVG(SECCHI_DEPTH_RESULT) AS SECCHI_DEPTH_RESULT
, AVG(TOTAL_PHOSPHORUS_RESULT) AS TOTAL_PHOSPHORUS_RESULT
, COUNT(*) AS NumberRecords

FROM [datadive-142319:mces_lakes.1999_2014_monitoring_data] 
WHERE 
 SEASONAL_LAKE_GRADE_RESULT IS NULL -- Ensures seasonal records are avoided
GROUP BY LAKE_NAME
HAVING COUNT(*) > 50  -- Removes ~1/3 of the data, but also removes unreliable lakes

ORDER BY SECCHI_DEPTH_RESULT ASC  -- Using Secchi depth since physical condition/recreational condition isn't available for all lakes
