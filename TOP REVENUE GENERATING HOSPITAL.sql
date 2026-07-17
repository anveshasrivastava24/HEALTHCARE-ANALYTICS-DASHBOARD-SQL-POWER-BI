WITH HospitalRevenue AS
(
    SELECT
        Hospital,
        COUNT(*) AS Total_Patients,
        SUM(Billing_Amount) AS Total_Revenue,
        AVG(Billing_Amount) AS Avg_Bill
    FROM dbo.anv
    GROUP BY Hospital
)
SELECT *,
       RANK() OVER(ORDER BY Total_Revenue DESC) AS Revenue_Rank
FROM HospitalRevenue;