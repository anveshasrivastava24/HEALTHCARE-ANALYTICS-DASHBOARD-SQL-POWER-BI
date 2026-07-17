WITH patient_admissions AS (
    SELECT
        Name,
        Medical_Condition,
        Date_of_Admission,
        Discharge_Date,
        Insurance_Provider,
        Admission_Type,
        Billing_Amount,
        DATEDIFF(DAY, Date_of_Admission, Discharge_Date) AS Length_of_Stay,
        ROW_NUMBER() OVER (PARTITION BY Name ORDER BY Date_of_Admission) AS Admission_Sequence
    FROM dbo.anv
),

readmission_patterns AS (
    SELECT
        a1.Name,
        a1.Medical_Condition,
        COUNT(*) AS Total_Admissions_per_Patient,
        SUM(a1.Billing_Amount) AS Total_Billing_per_Patient,
        ROUND(AVG(a1.Length_of_Stay), 2) AS Avg_Length_of_Stay,
        SUM(CASE WHEN a1.Admission_Type = 'Emergency' THEN 1 ELSE 0 END) AS Emergency_Count,
        SUM(CASE WHEN a1.Admission_Type = 'Urgent' THEN 1 ELSE 0 END) AS Urgent_Count,
        DATEDIFF(
            DAY,
            MAX(CASE WHEN a1.Admission_Sequence = 1 THEN a1.Discharge_Date END),
            MAX(CASE WHEN a1.Admission_Sequence = 2 THEN a1.Date_of_Admission END)
        ) AS Days_Between_Admissions
    FROM patient_admissions a1
    WHERE EXISTS (
        SELECT 1
        FROM patient_admissions a2
        WHERE a1.Name = a2.Name
        AND a2.Admission_Sequence > 1
    )
    GROUP BY
        a1.Name,
        a1.Medical_Condition
)

SELECT
    Name,
    Medical_Condition,
    Total_Admissions_per_Patient,
    Total_Billing_per_Patient,
    Avg_Length_of_Stay,
    Emergency_Count,
    Urgent_Count,
    Days_Between_Admissions,
    CASE
        WHEN Total_Admissions_per_Patient >= 3 THEN 'CHRONIC READMITTER'
        WHEN Total_Admissions_per_Patient = 2 AND Days_Between_Admissions < 30 THEN 'HIGH RISK'
        WHEN Total_Admissions_per_Patient = 2 THEN 'MODERATE RISK'
        ELSE 'LOW RISK'
    END AS Readmission_Risk_Category,
    ROUND(
        100.0 * Total_Billing_per_Patient /
        (SELECT SUM(Billing_Amount) FROM dbo.anv),
        4
    ) AS Percent_of_Total_Revenue
FROM readmission_patterns
ORDER BY
    Total_Admissions_per_Patient DESC,
    Total_Billing_per_Patient DESC;