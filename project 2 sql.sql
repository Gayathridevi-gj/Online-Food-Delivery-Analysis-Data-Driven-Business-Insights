select * from food_orders;
SELECT 
    Customer_ID,
    City,                          
    COUNT(Order_ID) AS total_orders,
    SUM(Final_Amount) AS total_spent
FROM food_orders
WHERE Order_Status = 'Delivered'   
  AND Final_Amount IS NOT NULL   
GROUP BY Customer_ID, City
ORDER BY total_spent DESC
LIMIT 10;
SELECT 
    Age_Group,
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Order_Value), 2) AS average_order_value,
    ROUND(AVG(Final_Amount), 2) AS average_final_paid,
    ROUND(SUM(Final_Amount), 2) AS total_revenue
FROM food_orders
WHERE Order_Status = 'Delivered' 
GROUP BY Age_Group
ORDER BY average_order_value DESC;
SELECT 
    Order_Day,
    COUNT(Order_ID) AS total_orders,
    ROUND(COUNT(Order_ID) * 100.0 / SUM(COUNT(Order_ID)) OVER(), 2) AS order_percentage,
    ROUND(AVG(Order_Value), 2) AS average_cart_value,
    ROUND(AVG(Discount_Applied), 2) AS average_discount,
    ROUND(AVG(Final_Amount), 2) AS average_final_spend,
    ROUND(AVG(Delivery_Time_Min), 1) AS average_delivery_time_mins,
    ROUND(AVG(Profit_Margin) * 100, 2) AS average_profit_margin_pct
FROM food_orders
WHERE Order_Status = 'Delivered'  
GROUP BY Order_Day
ORDER BY total_orders DESC;
SELECT 
    DATE_FORMAT(STR_TO_DATE(Order_Date, '%m/%d/%Y'), '%Y-%m') AS order_month,
    COUNT(Order_ID) AS total_orders,
    ROUND(SUM(Final_Amount), 2) AS total_revenue,
    ROUND(AVG(Final_Amount), 2) AS average_order_value,
    ROUND(AVG(Profit_Margin) * 100, 2) AS average_profit_margin_pct
FROM food_orders
WHERE Order_Status = 'Delivered'   
GROUP BY DATE_FORMAT(STR_TO_DATE(Order_Date, '%m/%d/%Y'), '%Y-%m')
ORDER BY order_month ASC; 
SELECT 
    CASE 
        WHEN Discount_Applied = 0 THEN 'No Discount (Full Price)'
        WHEN Discount_Applied > 0 AND Discount_Applied <= 50 THEN 'Low Discount (<= 50)'
        WHEN Discount_Applied > 50 AND Discount_Applied <= 200 THEN 'Medium Discount (51-200)'
        ELSE 'High Discount (> 200)'
    END AS discount_tier,
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Order_Value), 2) AS avg_initial_cart_value,
    ROUND(AVG(Discount_Applied), 2) AS avg_discount_given,
    ROUND(AVG(Final_Amount), 2) AS avg_final_customer_paid,
    ROUND(AVG(Profit_Margin) * 100, 2) AS average_profit_margin_pct,
    ROUND(SUM(Order_Value * Profit_Margin), 2) AS estimated_total_profit
    FROM food_orders
WHERE Order_Status = 'Delivered'    
  AND Discount_Applied IS NOT NULL
GROUP BY 
    CASE 
        WHEN Discount_Applied = 0 THEN 'No Discount (Full Price)'
        WHEN Discount_Applied > 0 AND Discount_Applied <= 50 THEN 'Low Discount (<= 50)'
        WHEN Discount_Applied > 50 AND Discount_Applied <= 200 THEN 'Medium Discount (51-200)'
        ELSE 'High Discount (> 200)'
    END
ORDER BY avg_discount_given ASC;
SELECT 
    City,
    Cuisine_Type,
    COUNT(Order_ID) AS total_orders,
    ROUND(SUM(Final_Amount), 2) AS total_revenue,
    ROUND(AVG(Final_Amount), 2) AS average_order_value
FROM food_orders
WHERE Order_Status = 'Delivered'
  AND City IS NOT NULL
  AND Cuisine_Type IS NOT NULL
GROUP BY City, Cuisine_Type
ORDER BY total_revenue DESC
LIMIT 10;
SELECT 
    City,
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Delivery_Time_Min), 1) AS avg_delivery_time_mins,
    ROUND(AVG(Distance_km), 2) AS avg_distance_km
FROM food_orders
WHERE Order_Status = 'Delivered'
  AND City IS NOT NULL
  AND Delivery_Time_Min IS NOT NULL
GROUP BY City
ORDER BY avg_delivery_time_mins DESC;
SELECT 
    CASE 
        WHEN Distance_km <= 5 THEN 'Short (0-5 km)'
        WHEN Distance_km > 5 AND Distance_km <= 15 THEN 'Medium (5-15 km)'
        WHEN Distance_km > 15 AND Distance_km <= 25 THEN 'Long (15-25 km)'
        ELSE 'Very Long (>25 km)'
    END AS distance_tier,
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Delivery_Time_Min), 1) AS avg_delivery_time_mins,
    MAX(Delivery_Performance) AS typical_performance_tier
FROM food_orders
WHERE Order_Status = 'Delivered'
  AND Distance_km IS NOT NULL
  AND Delivery_Time_Min IS NOT NULL
GROUP BY 
    CASE 
        WHEN Distance_km <= 5 THEN 'Short (0-5 km)'
        WHEN Distance_km > 5 AND Distance_km <= 15 THEN 'Medium (5-15 km)'
        WHEN Distance_km > 15 AND Distance_km <= 25 THEN 'Long (15-25 km)'
         ELSE 'Very Long (>25 km)'
    END
ORDER BY avg_delivery_time_mins ASC;
SELECT 
    Delivery_Rating,
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Delivery_Time_Min), 1) AS avg_delivery_time_mins,
    ROUND(AVG(Distance_km), 2) AS avg_distance_km
FROM food_orders
WHERE Order_Status = 'Delivered'
 GROUP BY Delivery_Rating
ORDER BY Delivery_Rating DESC; 
SELECT 
    Restaurant_ID,
    MAX(Cuisine_Type) AS cuisine,         
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Restaurant_Rating), 2) AS avg_restaurant_rating,
    ROUND(SUM(Final_Amount), 2) AS total_revenue
FROM food_orders
WHERE Order_Status = 'Delivered'
GROUP BY Restaurant_ID
HAVING COUNT(Order_ID) >= 5              
ORDER BY avg_restaurant_rating DESC, total_revenue DESC
LIMIT 10;
SELECT 
    Restaurant_ID,
    COUNT(Order_ID) AS total_orders_placed,
    SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) AS total_cancellations,
    ROUND(
        SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(Order_ID), 
        2
    ) AS cancellation_rate_pct
FROM food_orders
GROUP BY Restaurant_ID
HAVING COUNT(Order_ID) >= 5 
ORDER BY cancellation_rate_pct DESC;
SELECT 
    Cuisine_Type,
    COUNT(Order_ID) AS total_orders,
    ROUND(SUM(Final_Amount), 2) AS total_revenue,
    ROUND(AVG(Final_Amount), 2) AS average_order_value,
    ROUND(AVG(Restaurant_Rating), 2) AS average_customer_rating
FROM food_orders
WHERE Order_Status = 'Delivered'   
GROUP BY Cuisine_Type
ORDER BY total_revenue DESC; 
SELECT 
    CASE 
        WHEN Peak_Hour = TRUE THEN 'Peak Rush Hours'
        ELSE 'Off-Peak Hours'
    END AS operational_window,
    COUNT(Order_ID) AS total_orders,
    ROUND(AVG(Delivery_Time_Min), 1) AS avg_delivery_time_mins
FROM food_orders
WHERE Order_Status = 'Delivered'
GROUP BY Peak_Hour;
SELECT 
    Payment_Mode,
    COUNT(Order_ID) AS total_orders_placed,
    ROUND(AVG(Final_Amount), 2) AS average_final_spend
FROM food_orders
GROUP BY Payment_Mode
ORDER BY total_orders_placed DESC;
SELECT 
    Cancellation_Reason,
    COUNT(Order_ID) AS total_cancelled_orders,
    ROUND(SUM(Order_Value), 2) AS total_lost_revenue,
    ROUND(AVG(Distance_km), 2) AS avg_distance_km,
    MAX(City) AS hardest_hit_city
FROM food_orders
WHERE Order_Status = 'Cancelled'
  AND Cancellation_Reason <> 'not applicable'
GROUP BY Cancellation_Reason
ORDER BY total_cancelled_orders DESC;