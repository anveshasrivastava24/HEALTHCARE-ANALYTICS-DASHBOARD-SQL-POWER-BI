SELECT
    Medical_Condition,
    CASE
        WHEN Billing_Amount >= 40000 THEN 'High Cost'
        WHEN Billing_Amount >= 20000 THEN 'Medium Cost'
        ELSE 'Low Cost'
    END AS Cost_Category,
    COUNT(*) AS Patients,
    AVG(Billing_Amount) AS Avg_Bill
FROM dbo.anv
GROUP BY
    Medical_Condition,
    CASE
        WHEN Billing_Amount >= 40000 THEN 'High Cost'
        WHEN Billing_Amount >= 20000 THEN 'Medium Cost'
        ELSE 'Low Cost'
    END
HAVING COUNT(*) > 5
ORDER BY Avg_Bill DESC;