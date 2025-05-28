--Displays all the data

SELECT *
FROM Projects..Customer_Data

--Displays the data where age is over 25

SELECT age, income, education
FROM Projects..Customer_Data
WHERE age >= 25

--Displays data where age is less 25

SELECT age, income, education
FROM Projects..Customer_Data
WHERE age <= 25

--Displays Male data and the age is over 25

SELECT age, gender, income, region, purchase_frequency, purchase_amount, product_category
FROM Projects..Customer_Data
WHERE gender = 'Male' AND age >= 25

--Displays Female data and the age is less 25

SELECT age, gender, income, region, purchase_frequency, purchase_amount, product_category
FROM Projects..Customer_Data
WHERE gender = 'Female' AND age <= 25

--Display the Average income and Average purchase amount

SELECT income, age, region, AVG(income) Average_Income, AVG(purchase_amount) Average_Purchase_Amount
FROM Projects..Customer_Data
WHERE income >= 20000
GROUP BY income, age, region

--Display the lowest income and purchase amount

SELECT product_category, education, MIN(income) Lowest_Income, MIN(purchase_amount) Lowest_Purchase
FROM Projects..Customer_Data
WHERE education IS NOT NULL
GROUP BY product_category, education

--Display the highest income and purchase amount

SELECT product_category, education, MAX(income) Highest_Income, MAX(purchase_amount) Highest_Purchase
FROM Projects..Customer_Data
WHERE education IS NOT NULL
GROUP BY product_category, education

--Display the total gender and education with satisfaction score greater than 2 

SELECT id, age, income, satisfaction_score, gender, COUNT(gender) OVER (PARTITION BY gender) Total_Gender, education, COUNT(education) OVER (PARTITION BY education) Total_Education
FROM Projects..Customer_Data
WHERE satisfaction_score >= 2
ORDER BY satisfaction_score DESC, education

--Display the total region and how frequent a purchase is made

SELECT id, age, income, promotion_usage, region, COUNT(region) OVER (PARTITION BY region) Total_Region, purchase_frequency, COUNT(purchase_frequency) OVER (PARTITION BY purchase_frequency) Total_purchase_freq
FROM Projects..Customer_Data
WHERE promotion_usage IN (0,1)
ORDER BY region DESC, purchase_frequency

--Display the total product category of customers

WITH Customer (Product_Category, Total_Income, Total_Puechase, Percentage_Income) AS (
SELECT product_category, SUM(income) Total_Income, SUM(purchase_amount) Total_Purchase, MAX(income)/MAX(purchase_amount) Percentage_Income
FROM Projects..Customer_Data
Group by product_category
)
SELECT *
FROM Customer
Order by Percentage_Income DESC

--Display the educational level of customers

SELECT education, SUM(income) Total_Income, SUM(purchase_amount) Total_Purchase
FROM Projects..Customer_Data
Group by education
Order by 1

--Display the region of the customers

SELECT region, SUM(income) Total_Income, SUM(purchase_amount) Total_Purchase, MAX(income)/MAX(purchase_amount) Percentage_Income
FROM Projects..Customer_Data
Group by region
Order by 1

--Display the total loyalty status of customers

SELECT loyalty_status, SUM(income) Total_Income, SUM(purchase_amount) Total_Purchase, MAX(income)/MAX(purchase_amount) Percentage_Loyalty
FROM Projects..Customer_Data
Group by loyalty_status
Order by 1

--Displays how frequent customers patronize the business

SELECT purchase_frequency, SUM(income) Total_Income, SUM(purchase_amount) Total_Purchase
FROM Projects..Customer_Data
Group by purchase_frequency
Order by 1

--Display data where satisfaction is greater than 3 and age is over 27 years and shows the Percentage Income

SELECT age, gender, education, loyalty_status, income, satisfaction_score, COUNT(loyalty_status) OVER (PARTITION BY loyalty_status) Count_Loyalty, (income/purchase_amount) Percentage_Income, ROW_NUMBER () OVER (PARTITION BY income ORDER BY satisfaction_score)
FROM Projects..Customer_Data
WHERE satisfaction_score >= 3 AND age >=27 AND promotion_usage = 1
--GROUP BY loyalty_status
ORDER BY Percentage_Income DESC, Count_Loyalty
