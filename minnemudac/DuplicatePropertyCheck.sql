WITH test AS (
SELECT 
 CASE WHEN ROW_NUMBER() OVER (PARTITION BY centroid_long, centroid_lat) = 1 THEN 1 ELSE NULL END AS Original
, CASE WHEN ROW_NUMBER() OVER (PARTITION BY centroid_long, centroid_lat) = 2 THEN 1 ELSE NULL END AS Duplicate
, CASE WHEN ROW_NUMBER() OVER (PARTITION BY centroid_long, centroid_lat) > 2 THEN 1 ELSE NULL END AS MoreThanTwo
FROM `datadive-142319.metrogis_parcels.2015_tax_parcel_data` 
)

SELECT 
SUM(Original) AS Original
, SUM(Duplicate) AS Duplicate
, SUM(MoreThanTwo) AS MoreThanTwo
FROM test
