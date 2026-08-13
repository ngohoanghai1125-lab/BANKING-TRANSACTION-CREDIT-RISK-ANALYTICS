CREATE OR REPLACE VIEW v_fact_transactions_analytics AS
SELECT 
    t."TransactionID",
    t."TransactionDate",
    t."TransactionAmount",
    t."TransactionType",
    t."TransactionChannel",
    t."Status" AS "TransactionStatus",
    a."AccountID",
    a."AccountType",
    a."Balance" AS "AccountBalance",
    a."Status" AS "AccountStatus",
    c."CustomerID",
    c."FullName" AS "CustomerName",
    c."Gender",
    c."Region",
    c."Status" AS "CustomerStatus"
FROM "FactTransaction" t
LEFT JOIN "DimAccount" a ON t."AccountID" = a."AccountID"
LEFT JOIN "DimCustomer" c ON a."CustomerID" = c."CustomerID";


CREATE OR REPLACE VIEW v_customer_credit_risk AS
SELECT 
    c."CustomerID",
    c."FullName",
    c."Region",
    c."Status" AS "CustomerStatus",
    COUNT(a."AccountID") AS "TotalAccounts",
    SUM(CASE WHEN a."AccountType" = 'Credit' THEN a."Balance" ELSE 0 END) AS "TotalCreditBalance",
    CASE 
        WHEN SUM(CASE WHEN a."AccountType" = 'Credit' THEN a."Balance" ELSE 0 END) < 0 THEN 'High Risk (Negative Balance)'
        ELSE 'Normal Risk'
    END AS "RiskSegment"
FROM "DimCustomer" c
JOIN "DimAccount" a ON c."CustomerID" = a."CustomerID"
GROUP BY c."CustomerID", c."FullName", c."Region", c."Status";