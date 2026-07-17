SELECT
    YEAR(Date_of_Admission) AS Admission_Year,
    MONTH(Date_of_Admission) AS Admission_Month,
    COUNT(*) AS Admissions,
    SUM(Billing_Amount) AS Revenue,
    AVG(Billing_Amount) AS Avg_Bill
FROM dbo.anv
GROUP BY
    YEAR(Date_of_Admission),
    MONTH(Date_of_Admission)
ORDER BY
    Admission_Year,
    Admission_Month;
