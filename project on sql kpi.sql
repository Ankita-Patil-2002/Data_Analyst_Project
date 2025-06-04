
use  olist;

# KPI:1 :WEEKDAY VS WEEKEND (ORDER_PURCHASE_TIMESTAMP) PAYMENT STATISTICS

SELECT 
    CASE 
        WHEN DAYOFWEEK(order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    count(orders.order_id) AS total_orders,
   round((count(orders.order_id)/(SELECT count(*) FROM orders))*100,2) AS total_order_percentage
    FROM orders join payments on orders.order_id= payments.order_id
GROUP BY day_type
ORDER BY day_type;

use olist;


# KPI:2 :Number of Orders with review score 5 and payment type as credit card.

select ROUND(COUNT(orders.order_id),-3) as Numberoforders 
from orders inner join
payments on orders.order_id= payments.order_id
inner join reviews on payments.order_id = reviews.order_id
where reviews.review_score = 5
and payments.payment_type = 'credit_card';


# KPI:3 :3)	Average number of days taken for order_delivered_customer_date for pet_shop
SELECT p.product_category_name,
    FLOOR(AVG(DATEDIFF(o.order_delivered_customer_date,
            o.order_purchase_timestamp))) AS avg_shipping_day
FROM
    orders o
        JOIN
    orders_item it ON o.order_id = it.order_id
        JOIN
    products1 p ON it.product_id = p.product_id
WHERE
    product_category_name = 'pet_shop'
    group by p.product_category_name;

select * from products1;

# kpi:4 :Average price and payment values from customers of sao paulo city
WITH S1 AS (
    SELECT 
        UPPER(C.CUSTOMER_CITY) AS CITY,
        CONCAT(FLOOR(AVG(P.PAYMENT_VALUE)), ' ', '$') AS AVG_PAYMENT,
        AVG(P.PAYMENT_VALUE) AS PAYMENT FROM ORDERS O 
    INNER JOIN PAYMENTS P ON O.ORDER_ID = P.ORDER_ID
    INNER JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
    WHERE UPPER(C.CUSTOMER_CITY) = 'SAO PAULO'
    GROUP BY C.CUSTOMER_CITY ), 
S2 AS (SELECT 
        UPPER(C.CUSTOMER_CITY) AS CITY,
        CONCAT(FLOOR(AVG(I.PRICE)), ' ', '$') AS AVG_PRICE,
        AVG(I.PRICE) AS PRICE FROM ORDERS O 
    INNER JOIN ORDERS_ITEM I ON O.ORDER_ID = I.ORDER_ID
    INNER JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
    WHERE UPPER(C.CUSTOMER_CITY) = 'SAO PAULO'
    GROUP BY C.CUSTOMER_CITY) 
SELECT S1.CITY, S2.AVG_PRICE, S1.AVG_PAYMENT FROM S1 INNER JOIN S2 ON S1.CITY = S2.CITY;


    
#kpi:5 :Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT 
    rW.review_score,
    ROUND(AVG(DATEDIFF(ord.order_delivered_customer_date,
                    ord.order_purchase_timestamp)),0) AS avg_shipping_Days
FROM
    olist_orders_dataset AS ord
        JOIN
    REVIEWS rw ON rw.order_id = ord.order_id
GROUP BY rw.review_score
ORDER BY rw.review_score;


select * from olist_orders_dataset;







    



