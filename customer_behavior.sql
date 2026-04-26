--Q1. What is the total revenue by gender?
SELECT "Gender",
       SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY "Gender";
--Q2. Which customers used discounts but spent above average?
SELECT "Customer ID", "Purchase Amount (USD)"
FROM customer
WHERE "Discount Applied" = 'Yes'
  AND "Purchase Amount (USD)" >= (
      SELECT AVG("Purchase Amount (USD)") FROM customer
  );
--Q3. Top 5 products with highest average rating
SELECT "Item Purchased",
       ROUND(AVG("Review Rating"), 2) AS avg_rating
FROM customer
GROUP BY "Item Purchased"
ORDER BY avg_rating DESC
LIMIT 5;
--Q4. Compare average spend by shipping type
SELECT "Shipping Type",
       ROUND(AVG("Purchase Amount (USD)"), 2) AS avg_spend
FROM customer
WHERE "Shipping Type" IN ('Standard', 'Express')
GROUP BY "Shipping Type";
--Q5. Do subscribed customers spend more?
SELECT "Subscription Status",
       COUNT(*) AS total_customers,
       ROUND(AVG("Purchase Amount (USD)"), 2) AS avg_spend,
       SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY "Subscription Status"
ORDER BY total_revenue DESC;
--Q6. Products with highest discount usage %
SELECT "Item Purchased",
       ROUND(
           100.0 * SUM(CASE WHEN "Discount Applied" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS discount_percentage
FROM customer
GROUP BY "Item Purchased"
ORDER BY discount_percentage DESC
LIMIT 5;
--Q7. Customer segmentation (New / Returning / Loyal)
WITH customer_segment AS (
    SELECT "Customer ID",
           "Previous Purchases",
           CASE 
               WHEN "Previous Purchases" = 1 THEN 'New'
               WHEN "Previous Purchases" BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS segment
    FROM customer
)

SELECT segment,
       COUNT(*) AS total_customers
FROM customer_segment
GROUP BY segment;
--Q8. Top 3 products in each category
WITH ranked_products AS (
    SELECT "Category",
           "Item Purchased",
           COUNT(*) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY "Category"
               ORDER BY COUNT(*) DESC
           ) AS rank
    FROM customer
    GROUP BY "Category", "Item Purchased"
)

SELECT *
FROM ranked_products
WHERE rank <= 3;
--Q9. Are repeat buyers more likely to subscribe?
SELECT "Subscription Status",
       COUNT(*) AS repeat_customers
FROM customer
WHERE "Previous Purchases" > 5
GROUP BY "Subscription Status";
🔷 🔥 Q10. Revenue by age group

(You don’t have age groups yet → create it)

SELECT 
    CASE 
        WHEN "Age" < 25 THEN 'Young'
        WHEN "Age" BETWEEN 25 AND 50 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;