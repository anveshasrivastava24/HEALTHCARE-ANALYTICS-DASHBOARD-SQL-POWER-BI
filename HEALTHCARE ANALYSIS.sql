WITH risk_factors AS (
    SELECT
        Name,
        Age,
        Gender,
        Medical_Condition,
        Admission_Type,
        Billing_Amount,
        DATEDIFF(DAY, Date_of_Admission, Discharge_Date) AS Length_of_Stay,
        Test_Results,

        CASE
            WHEN Age > 75 THEN 3
            WHEN Age > 65 THEN 2
            WHEN Age >= 40 THEN 1
            ELSE 0
        END +

        CASE
            WHEN Medical_Condition IN ('Cancer', 'Hypertension', 'Diabetes') THEN 3
            WHEN Medical_Condition IN ('Obesity', 'Asthma') THEN 2
            WHEN Medical_Condition = 'Arthritis' THEN 1
            ELSE 0
        END +

        CASE
            WHEN Test_Results = 'Abnormal' THEN 3
            WHEN Test_Results = 'Inconclusive' THEN 2
            ELSE 0
        END +

        CASE
            WHEN Admission_Type = 'Emergency' THEN 2
            WHEN Admission_Type = 'Urgent' THEN 1
            ELSE 0
        END AS Risk_Score

    FROM dbo.anv
)

SELECT
    Name,
    Age,
    Gender,
    Medical_Condition,
    Admission_Type,
    Test_Results,
    Length_of_Stay,
    Billing_Amount,
    Risk_Score,

    CASE
        WHEN Risk_Score >= 10 THEN 'HIGH RISK'
        WHEN Risk_Score >= 6 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS Risk_Category,

    COUNT(*) OVER (
        PARTITION BY
        CASE
            WHEN Risk_Score >= 10 THEN 'HIGH'
            WHEN Risk_Score >= 6 THEN 'MEDIUM'
            ELSE 'LOW'
        END
    ) AS Patient_Count_In_Category

FROM risk_factors
ORDER BY Risk_Score DESC;