select * from order_details;


select * from orders;


select * from pizzas;

select * from pizza_types;


-- Basic:
-- (01) Retrieve the total number of orders placed.
select  count(order_id) as total
from orders;


--(02) Calculate the total revenue generated from pizza sales.
select sum(p.price*o.quantity) as total_revenue
from pizzas p
join order_details o
on p.pizza_id=o.pizza_id;



--(03) Identify the highest-priced pizza.
select pt.name,p.price from pizzas p
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
order by p.price desc
limit 1;


--(04) Identify the most common pizza size ordered.
select p.size,count(od.order_details_id) as total
from pizzas p
join order_details od
on p.pizza_id=od.pizza_id
group by p.size
order by total desc;


--(05) List the top 5 most ordered pizza types along with their quantities.


select pt.name,sum(od.quantity) as total
from pizza_types pt
join pizzas p
on p.pizza_type_id=pt.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.name
order by total desc
limit 5;

--End of the Basic Question 



-- Intermediate:
--(06) Join the necessary tables to find the total quantity of each pizza category ordered.

select distinct category from pizza_types;

select pt.category,sum(od.quantity) as total
from pizza_types pt
join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.category;



--(07) Determine the distribution of orders by hour of the day.

select * from orders;

SELECT EXTRACT(HOUR FROM time) AS hour,count(order_id) as counts
FROM orders
group by hour
order by hour desc;



--(08) Join relevant tables to find the category-wise distribution of pizzas.


select category, count(name) as total
from pizza_types
group by category;




--(09) Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(total)  from
(select o.date,sum(od.quantity) as total
from orders o join order_details od
on o.order_id=od.order_id
group by o.date) as total_avg;



--(10) Determine the top 3 most ordered pizza types based on revenue.

select pt.name,sum(p.price*od.quantity) as total_price
from pizza_types pt
join pizzas p
on p.pizza_type_id=pt.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.name
order by total_price desc
limit 3;


-- Advanced:
--(11) Calculate the percentage contribution of each pizza type to total revenue.

select pt.category,(sum(p.price*od.quantity)/(select sum(p.price*o.quantity) as total_revenue
from pizzas p
join order_details o
on p.pizza_id=o.pizza_id)*100) as total_persentage
from pizza_types pt
join pizzas p
on p.pizza_type_id=pt.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.category 
order by total_persentage desc;




--(12) Analyze the cumulative revenue generated over time.
select date,sum(revenue) over(order by date) as cumulative
from
(select o.date,sum(p.price*od.quantity) as revenue
from orders o
join order_details od
on o.order_id=od.order_id
join pizzas p
on od.pizza_id=p.pizza_id
group by o.date) as sub


--(13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, category, revenue,ranks from 
(select name,category,revenue,
		rank() over(partition by category order by revenue desc) as ranks from
(select pt.category, pt.name,sum(p.price*od.quantity) as revenue
from pizza_types pt
join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.name,pt.category) as sub) as a 
where ranks<4;















