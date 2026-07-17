SELECT
    COUNT(*) AS Total_Patients,
    SUM(Billing_Amount) AS Total_Revenue,
    AVG(Billing_Amount) AS Avg_Billing,
    AVG(Room_Number) AS Avg_Room_Number
FROM dbo.anv;

