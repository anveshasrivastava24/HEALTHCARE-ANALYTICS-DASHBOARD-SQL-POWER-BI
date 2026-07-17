SELECT
    Insurance_Provider,
    COUNT(*) AS Patients,
    SUM(Billing_Amount) AS Total_Revenue,
    AVG(Billing_Amount) AS Avg_Bill,
    DENSE_RANK() OVER(ORDER BY SUM(Billing_Amount) DESC) AS Provider_Rank
FROM dbo.anv
GROUP BY Insurance_Provider;

-- Revenue Optimisation 

SELECT
    Insurance_Provider,
    COUNT(DISTINCT Name) AS Total_Patients,
    COUNT(*) AS Total_Admissions,
    ROUND(SUM(Billing_Amount), 2) AS Total_Revenue,
    ROUND(AVG(Billing_Amount), 2) AS Avg_Billing_per_Admission,
    ROUND(MAX(Billing_Amount), 2) AS Max_Single_Billing,
    ROUND(MIN(Billing_Amount), 2) AS Min_Single_Billing,
    ROUND(STDEV(Billing_Amount), 2) AS Billing_Volatility,
    ROUND(SUM(Billing_Amount) / COUNT(DISTINCT Name), 2) AS Revenue_per_Patient,
    ROUND(
        100.0 * SUM(Billing_Amount) /
        (SELECT SUM(Billing_Amount) FROM dbo.anv),
        2
    ) AS Percent_of_Total_Revenue,
    RANK() OVER (ORDER BY SUM(Billing_Amount) DESC) AS Revenue_Rank
FROM dbo.anv
GROUP BY Insurance_Provider
HAVING COUNT(*) > 100
ORDER BY Total_Revenue DESC;