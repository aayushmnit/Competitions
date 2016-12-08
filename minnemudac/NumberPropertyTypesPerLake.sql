-- Disable "Use Legacy SQL" under Google BigQuery to support CTEs

WITH lake AS (
SELECT
 LAKE_NAME AS LakeName
, DNR_ID_SITE_NUMBER
FROM `datadive-142319.mces_lakes.1999_2014_monitoring_data`
GROUP BY LAKE_NAME, DNR_ID_SITE_NUMBER
)

, residential AS (
SELECT
 USE1_DESC AS PropertyType
, centroid_long
, centroid_lat
FROM `datadive-142319.metrogis_parcels.2015_tax_parcel_data`
WHERE LTRIM(LOWER(USE1_DESC)) LIKE '1__%'
  OR LOWER(USE1_DESC) LIKE '%residential%'
    OR LOWER(USE1_DESC) LIKE '%res%'
    OR LOWER(USE1_DESC) LIKE '%house%'
    OR LOWER(USE1_DESC) LIKE '%condo%'
    OR LOWER(USE1_DESC) LIKE '%apartment%'
      OR LOWER(USE1_DESC) LIKE '%apt%'
    OR LOWER(USE1_DESC) LIKE '%plex%'
    OR LOWER(USE1_DESC) LIKE '%bungalo%'
    OR LOWER(USE1_DESC) LIKE '%housing%'
      OR LOWER(USE1_DESC) LIKE '%home%'
    OR LOWER(USE1_DESC) LIKE '%family%'
GROUP BY USE1_DESC, centroid_long, centroid_lat
)

, agriculture AS (
SELECT
 USE1_DESC AS PropertyType
, centroid_long
, centroid_lat
FROM `datadive-142319.metrogis_parcels.2015_tax_parcel_data`
WHERE LOWER(USE1_DESC) LIKE '2__%'
   OR LOWER(USE1_DESC) LIKE '%ag%'
   OR LOWER(USE1_DESC) LIKE '%farm%'
   OR LOWER(USE1_DESC) LIKE '%rural%'
)

, commercial AS (
SELECT
 USE1_DESC AS PropertyType
, centroid_long
, centroid_lat
FROM `datadive-142319.metrogis_parcels.2015_tax_parcel_data`
WHERE LOWER(USE1_DESC) LIKE '3__%'
   OR LOWER(USE1_DESC) LIKE '%commercial%'
   OR LOWER(USE1_DESC) LIKE '%machinery%'
   OR LOWER(USE1_DESC) LIKE '%recreational%'
   OR LOWER(USE1_DESC) LIKE '%golf%'
   OR LOWER(USE1_DESC) LIKE '%coop%'
)

, industrial AS (
SELECT
 USE1_DESC AS PropertyType
, centroid_long
, centroid_lat
FROM `datadive-142319.metrogis_parcels.2015_tax_parcel_data`
WHERE LOWER(USE1_DESC) LIKE '%ind%'
   OR LOWER(USE1_DESC) = '305 industrial'
)

, public AS (
SELECT
 USE1_DESC AS PropertyType
, centroid_long
, centroid_lat
FROM `datadive-142319.metrogis_parcels.2015_tax_parcel_data`
WHERE LOWER(USE1_DESC) LIKE '9__%'
   OR LOWER(USE1_DESC) LIKE '%public%'
   OR LOWER(USE1_DESC) LIKE '%muni%'
   OR LOWER(USE1_DESC) LIKE '%rail%'
   OR LOWER(USE1_DESC) LIKE '%church%'
   OR LOWER(USE1_DESC) LIKE '%school%'
   OR LOWER(USE1_DESC) LIKE '%forest%'
   OR LOWER(USE1_DESC) LIKE '%state%'
   OR LOWER(USE1_DESC) LIKE '%county%'
   OR LOWER(USE1_DESC) LIKE '%util%'
   OR LOWER(USE1_DESC) LIKE '%college%'
   OR LOWER(USE1_DESC) LIKE '%cem%'
   OR LOWER(USE1_DESC) LIKE '%common%'
   OR LOWER(USE1_DESC) LIKE '%road%'
   OR LOWER(USE1_DESC) LIKE '%fed%'
   OR LOWER(USE1_DESC) LIKE '%tax%'
   OR LOWER(USE1_DESC) LIKE '%dnr%'
   OR LOWER(USE1_DESC) LIKE '%charit%'
   OR LOWER(USE1_DESC) LIKE '%serv%'
   OR LOWER(USE1_DESC) LIKE '%hosp%'
   OR LOWER(USE1_DESC) LIKE '%park%'
)

SELECT
 ROW_NUMBER() OVER (ORDER BY lake.LakeName) AS ID
, lake.LakeName
, COUNT(residential.PropertyType) AS ResidentialCount_2015
, COUNT(agriculture.PropertyType) AS AgriculturalCount_2015
, COUNT(commercial.PropertyType) AS CommercialCount_2015
, COUNT(industrial.PropertyType) AS IndustrialCount_2015
, COUNT(public.PropertyType) AS PublicCount_2015
FROM lake
  JOIN `datadive-142319.sds_xref.parcel_to_water` AS intersection ON lake.DNR_ID_SITE_NUMBER = intersection.MCES_Map_Code1
 
  LEFT JOIN residential ON intersection.parcel_centroid_long = residential.centroid_long
                       AND intersection.parcel_centroid_lat = residential.centroid_lat

  LEFT JOIN agriculture ON intersection.parcel_centroid_long = agriculture.centroid_long
                       AND intersection.parcel_centroid_lat = agriculture.centroid_lat

  LEFT JOIN commercial ON intersection.parcel_centroid_long = commercial.centroid_long
                       AND intersection.parcel_centroid_lat = commercial.centroid_lat

  LEFT JOIN industrial ON intersection.parcel_centroid_long = industrial.centroid_long
                       AND intersection.parcel_centroid_lat = industrial.centroid_lat

  LEFT JOIN public ON intersection.parcel_centroid_long = public.centroid_long
                       AND intersection.parcel_centroid_lat = public.centroid_lat
                 
GROUP BY lake.LakeName
ORDER BY lake.LakeName ASC
