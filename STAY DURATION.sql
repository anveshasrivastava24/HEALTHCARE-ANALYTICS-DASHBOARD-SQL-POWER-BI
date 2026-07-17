SELECT
    Medical_Condition,
    AVG(DATEDIFF(DAY, Date_of_Admission, Discharge_Date)) AS Avg_Length_of_Stay,
    SUM(Billing_Amount) AS Revenue
FROM dbo.anv
GROUP BY Medical_Condition
ORDER BY Avg_Length_of_Stay DESC;

WITH stay_analysis AS (
    SELECT
        Hospital,
        Medical_Condition,
        DATEDIFF(DAY, Date_of_Admission, Discharge_Date) AS Length_of_Stay,
        Billing_Amount,
        Admission_Type
    FROM dbo.anv
    WHERE DATEDIFF(DAY, Date_of_Admission, Discharge_Date) > 0
)

SELECT
    Hospital,
    Medical_Condition,
    COUNT(*) AS Total_Admissions,
    ROUND(AVG(CAST(Length_of_Stay AS FLOAT)),2) AS Avg_Length_of_Stay,
    ROUND(STDEV(CAST(Length_of_Stay AS FLOAT)),2) AS LOS_Std_Dev,
    MAX(Length_of_Stay) AS Max_LOS,
    ROUND(SUM(Billing_Amount),2) AS Total_Revenue,
    ROUND(AVG(Billing_Amount),2) AS Avg_Revenue_per_Stay,
    SUM(CASE WHEN Admission_Type='Emergency' THEN 1 ELSE 0 END) AS Emergency_Cases,
    SUM(CASE WHEN Admission_Type='Urgent' THEN 1 ELSE 0 END) AS Urgent_Cases,
    SUM(CASE WHEN Admission_Type='Elective' THEN 1 ELSE 0 END) AS Elective_Cases
FROM stay_analysis
GROUP BY Hospital, Medical_Condition
HAVING COUNT(*) >= 10
ORDER BY Total_Revenue DESC;