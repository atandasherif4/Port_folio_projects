/*																CAPSTONE PROJECT
Given the datasets to be listed below, am meant to analyze the data, identify key metrics that will provide some interesting insights  annd tell a story.

Datasets and attributes/column
county_info = personal_id, id, unemp, wage, distance, region, avg_county_tuition.
student_academic_info = personal_id, id, academic_score, student_tuition, education.
student_family_details = personal id, id, fcollege, mcollege,  home, urban, income.
student_personal_details = persoanl_id, gender, DOB, ethnicity, academic_info_id, county_id, family_details_id.

On analyzing the datasets, i discovered that  academic_info_id, county_id, family_details_id from student_personal_details have repeated row(i.e appearing more than once).
This in turn affected m result after running my queries which involved joining some tables togetherand using academic_info_id in student_personal_details table with  id in student_academic_info table and vice-versa.

So i decided to add the ID in student_personal_details to all other tables, and i renamed ID with personal_id.
This was done to avoid getting unwanted and wrong output but a true one. */

--Insight 1 : Calculating and comparing the percentage of students whose father were and were not college  graduates.
With cte1 AS (
  SELECT student_personal_details.personal_id, student_personal_details.family_details_id, student_family_details.fcollege, student_family_details.mcollege
  FROM student_personal_details
  JOIN student_family_details
  ON student_personal_details.personal_id = student_family_details.personal_id)
    , cte2 AS ( 
      SELECT *, 
      CASE WHEN fcollege = 'yes' THEN 1
      ELSE 0
      END AS check_fath_colg,
      CASE WHEN  fcollege = 'no' THEN 1
      ELSE 0
      END AS check_fath_ncolg
      FROM cte1)
      
      
SELECT ROUND(SUM(check_fath_colg) *100.0/4739, 1) AS percent_fath_colg, ROUND(SUM(check_fath_ncolg)* 100.0/4739, 1)  AS percent_fath_ncolg
FROM cte1
JOIN cte2
ON cte1.personal_id = cte2.personal_id;

--Insight 2 : Calculating and comparing the percentage of students whose mother were and were not college  graduates
With cte1 AS (
  SELECT student_personal_details.personal_id, student_personal_details.family_details_id, student_family_details.fcollege, student_family_details.mcollege
  FROM student_personal_details
  JOIN student_family_details
  ON student_personal_details.personal_id = student_family_details.personal_id)
    , cte2 AS ( 
      SELECT *, 
      CASE WHEN mcollege = 'yes' THEN 1
      ELSE 0
      END AS check_moth_colg,
      CASE WHEN  mcollege = 'no' THEN 1
      ELSE 0
      END AS check_moth_ncolg
      FROM cte1)
      
      
SELECT ROUND(SUM(check_moth_colg) *100.0/4739, 1) AS percent_moth_colg, ROUND(SUM(check_moth_ncolg)* 100.0/4739, 1)  AS percent_moth_ncolg
FROM cte1
JOIN cte2
ON cte1.personal_id = cte2.personal_id;

--Insight 3 : The count of students(12th grade and above) whose parents don't own their home, are low income earners and not college graduates.
WITH cte3 AS (
  SELECT student_academic_info.personal_id, student_academic_info.education, student_family_details.fcollege, student_family_details.mcollege, student_family_details.home, student_family_details.income
  from student_academic_info
  JOIN student_family_details
  on student_academic_info.personal_id = student_family_details.personal_id
 )
  
, cte4 AS (
    SELECT county_info.region AS county_region, COUNT(fcollege) AS no_fath_ncolg, COUNT(mcollege) AS no_moth_ncolg, COUNT(home) AS fmy_nhome, COUNT(income) AS fmy_nincome
    from county_info
    JOIN cte3
    ON county_info.personal_id = cte3.personal_id
    WHERE education = 12
    AND fcollege = 'no'
    AND mcollege = 'no'
    AND home = 'no'
    AND income = 'low'
    group BY 1)
    
SELECT *
from cte4;

--Insight 4 : The average rate of unempoyment in 2020 based region of county.
SELECT  region,
		unemp,
        ROUND(AVG(unemp) OVER (PARTITION BY region),2) AS avg_unemp_rate_region
FROM county_info;

--Insight 5 : Comparison of academic score of students based on education(above 12th grade) and ethnicity.
SELECT education, 
	   ethnicity, 		
       ROUND(SUM(academic_score) OVER (PARTITION BY education,ethnicity), 2) AS sum_acad_score_ethnicity
FROM student_academic_info
JOIN student_personal_details
ON student_academic_info.personal_id = student_personal_details.personal_id
WHERE education > 13;
