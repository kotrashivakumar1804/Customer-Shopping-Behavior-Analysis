select * from customer;

--1Q) How much total money did male customers spend compared to female customers?
select gender, SUM(purchase_amount) as revenue
from customer
group by gender;

--2Q) Which customers used a discount but still spent more than the average purchase amount?
select customer_id,item_purchased,purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from customer)

--3Q) Which five products have the highest average review ratings?
select item_purchased,ROUND(AVG(review_rating::numeric),2) as "average product rating"
from customer
group by item_purchased
order by AVG(review_rating) desc
limit 5;

--4Q) How does the average purchase amount differ between customers who chose standard shipping versus express shipping?
select shipping_type,
ROUND(AVG(purchase_amount::numeric),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

--5Q) What is the total number of customers, average spend, and total revenue for each subscription status?
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_Amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc;

--6Q) Which five products have the highest discount application rate?
select item_purchased,
ROUND(100 * sum(case when discount_applied = 'Yes' then 1 else 0 END)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

--7Q) Classify customers into 'New' (1 previous purchase), 'Returning' (2-10 previous purchases), and 'Loyal' (more than 10 previous purchases). How many customers fall into each category?
with customer_type as (
select customer_id, previous_purchases,
CASE
	WHEN previous_purchases=1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 and 10 THEN 'Returning'
	ELSE 'Loyal'
	END as customer_segment
from customer
)
SELECT customer_segment,count(*) as"number of customers"
from customer_type
group by customer_segment

--8Q) What are the top three most purchased items in each category?
with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders
,row_number()over(partition by category order by count(customer_id) desc)as item_rank
from customer
group by category, item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank <= 3;

--9Q) Among customers with more than five previous purchases, how many are repeat buyers based on their subscription status?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--10Q) What is the total revenue generated from each age group?
select age_group ,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc




