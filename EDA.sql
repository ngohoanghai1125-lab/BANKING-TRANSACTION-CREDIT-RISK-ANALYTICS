--Overview of volume and capital flow
select Count(*) as total_transactions
from "FactTransaction";

select COUNT(distinct "AccountID") as active_accounts
from "FactTransaction";

select SUM("TransactionAmount") as total_transaction_value
from "FactTransaction";

--Cash Flow: Deposits (Credit) vs. Withdrawals (Debit)
select SUM(case when "TransactionType"='Credit' then 1 else 0 end) as total_credit_volume, 
sum(case when "TransactionType"='Debit' then 1 else 0 end) as total_debit_volume,
SUM(case when "TransactionType"='Credit' then 1 else 0 end) - sum(case when "TransactionType"='Debit' then 1 else 0 end) as net_cash_flow
from "FactTransaction";

--Failed/questionable transaction rate --> Fraud Attempts
select CONCAT(ROUND(sum(case when "Status" = 'Failed' then 1 else 0 end)*100.0/(select count(*) from "FactTransaction"),2), '%') as failed_transaction_percentage
from "FactTransaction"; 

--Negative Balance
select "AccountType", COUNT("AccountID") as total_negative_balance, SUM("Balance") as total_negative_volume, ROUND(AVG("Balance"),2) as avg_negative_balance
from "DimAccount" 
where "Balance"<0
group by "AccountType" 
order by total_negative_volume desc;

--Deposit and Withdrawal Cash Flow (in USD Value)
select 
sum(case when "TransactionType" = 'Credit' then "TransactionAmount" else 0 end) as  total_credit_amount, 
sum(case when "TransactionType" = 'Debit' then "TransactionAmount" else 0 end) as  total_debit_amount, 
sum(case when "TransactionType" = 'Credit' then "TransactionAmount" else -"TransactionAmount" end) as net_cash_flow
from "FactTransaction";
 
-- Tỷ lệ giao dịch thất bại theo Kênh (Channel)
select "TransactionChannel", 
CONCAT(ROUND(SUM(case when "Status"='Failed' then 1 else 0 end)*100.0/(select count(*) from "FactTransaction"),2), '%') as failed_rate
from "FactTransaction"
group by "TransactionChannel";


