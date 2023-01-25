
CREATE SCHEMA dannys_diner;
--SET search_path = dannys_diner;
use schema dannys_diner;

drop table dannys_diner.sales;

CREATE TABLE dannys_diner.sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO dannys_diner.sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
 select * from dannys_diner.sales;

 

CREATE TABLE dannys_diner.menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO dannys_diner.menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
 
 select * from dannys_diner.menu;
  

CREATE TABLE dannys_diner.members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO dannys_diner.members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
 
 select * from dannys_diner.members;
 
 -- 1. What is the total amount each customer spent at the restaurant?

select customer_id,sum(price) as 'total amount' -- sum(s.product_id) as 'total amount'
from dannys_diner.sales as s 
inner join dannys_diner.menu as  m 
on s.product_id = m.product_id
group by customer_id

-- 2. How many days has each customer visited the restaurant?

select customer_id,count(distinct order_date) as num_of_days
from dannys_diner.sales 
group by customer_id;


-- 3. What was the first item from the menu purchased by each customer?

select customer_id,product_name 
from dannys_diner.sales as s 
inner join dannys_diner.menu as  m 
on s.product_id = m.product_id
group by customer_id
having min(order_date);


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select customer_id,s.product_id,count(*)from dannys_diner.sales as s 
join (
select product_id,count(*) as num_of_times from dannys_diner.sales
group by product_id
order by num_of_times desc
limit 1) as subquery 
on s.product_id = subquery.product_id
group by customer_id,product_id;



-- 5. Which item was the most popular for each customer?


select product_id from dannys_diner.sales
group by product_id  count(distinct customer_id) = 
(select count(distinct customer_id) from dannys_diner.sales)
; 


-- 6. Which item was purchased first by the customer after they became a member?

select s.customer_id,min(order_date)
-- select s.customer_id,product_id,me.join_date,s.order_date,datediff(s.order_date,me.join_date) as diff
from dannys_diner.sales as s
join dannys_diner.members as me 
on s.customer_id = me.customer_id
where me.join_date <= s.order_date
group by customer_id 
-- order by diff asc;

-- 7. Which item was purchased just before the customer became a member?


select s.customer_id,max(order_date)
-- select s.customer_id,product_id,me.join_date,s.order_date,datediff(s.order_date,me.join_date) as diff
from dannys_diner.sales as s
join dannys_diner.members as me 
on s.customer_id = me.customer_id
where me.join_date >= s.order_date
group by customer_id 


-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id,count(s.product_id) as total_items , sum(m.price) as amount_spent  
from dannys_diner.sales as s 
join dannys_diner.menu as m 
on s.product_id = m.product_id 
join dannys_diner.members as me 
on s.customer_id = me.customer_id 
where  me.join_date >= s.order_date
group by s.customer_id ;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
-- how many points would each customer have?
 -- 1$ =10 points
-- sushi = 2*10 =20 points

select customer_id,
sum(case when product_name = 'sushi' then (price)*20 
	 when product_name <> 'sushi' then (price)*10
	 else '0'end ) as points
from dannys_diner.sales as s 
join dannys_diner.menu as m 
on s.product_id = m.product_id 
group by customer_id;



-- 10. In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?


select s.customer_id,
sum(
	case 
		when order_date >= join_date then (price)*20 
		else '0' end 
   ) as total_points
from dannys_diner.sales as s 
join dannys_diner.menu as m 
	on s.product_id = m.product_id 
join dannys_diner.members as me 
	on s.customer_id = me.customer_id
group by s.customer_id;























