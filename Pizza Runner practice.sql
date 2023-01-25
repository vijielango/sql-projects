CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;


CREATE TABLE pizza_runner.runners (
  runner_id INTEGER,
  registration_date DATE
);

INSERT INTO pizza_runner.runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

drop table pizza_runner.customer_orders

CREATE TABLE pizza_runner.customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

select * from pizza_runner.customer_orders
truncate table pizza_runner.customer_orders

INSERT INTO pizza_runner.customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
 

select * from pizza_runner.customer_orders;

CREATE TABLE pizza_runner.runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

truncate table pizza_runner.runner_orders;

INSERT INTO pizza_runner.runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20 km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20 km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4 km', '20 minutes', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4 km', '40 minutes', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10 km', '15 minutes', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25 km', '25 minutes', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minutes', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10 km', '10 minutes', 'null');

select * from pizza_runner.runner_orders;

update pizza_runner.runner_orders
set cancellation = NULL
where cancellation in ('',NULL,'null');



CREATE TABLE pizza_runner.pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);

INSERT INTO pizza_runner.pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

 select * from pizza_runner.pizza_names;
 
CREATE TABLE pizza_runner.pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);

INSERT INTO pizza_runner.pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

 select * from pizza_runner.pizza_recipes;

CREATE TABLE pizza_runner.pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);


INSERT INTO pizza_runner.pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
 
 select * from pizza_runner.pizza_toppings;

-- A. Pizza Metrics

-- 1.How many pizzas were ordered?

select count(order_id) as num_of_pizza_ordered 
from pizza_runner.customer_orders;

-- 2.How many unique customer orders were made?

select count(distinct customer_id) as num_of_customers 
from pizza_runner.customer_orders;

-- 3.How many successful orders were delivered by each runner?


select  * from pizza_runner.runner_orders;

select count(order_id) as success_order 
from pizza_runner.runner_orders
where cancellation is null;

-- 4.How many of each type of pizza was delivered?


select pizza_id ,
	   count(pizza_id) as num_of_pizztype
from pizza_runner.customer_orders
group by pizza_id;


-- 5.How many Vegetarian and Meatlovers were ordered by each customer?

select
	customer_id,
	sum(case when pizza_name = 'Meatlovers' then 1 else 0 end) as meatlovers,
	sum(case when pizza_name <> 'Meatlovers' then 1 else 0 end) as vegetarian
from
	pizza_runner.customer_orders as c
join pizza_runner.pizza_names as pnm on
	c.pizza_id = pnm.pizza_id
group by
	customer_id,
	c.pizza_id
order by
	customer_id;


-- 6.What was the maximum number of pizzas delivered in a single order?
select
	c.order_id,
	count(c.order_id) as order_count
from
	pizza_runner.customer_orders as c
join pizza_runner.runner_orders as r on
	c.order_id = r.order_id
where
	cancellation is null /* to */
group by
	c.order_id
order by
	order_count desc
limit 1;

-- 7.For each customer, how many delivered pizzas had at least 1 change 
-- and how many had no changes?

select distinct exclusions ,extras from pizza_runner.customer_orders;



update pizza_runner.customer_orders
set extras = NULL
where extras in ('','null',NULL);

update pizza_runner.customer_orders 
set exclusions = NULL
where exclusions in('','null',NULL);

select customer_id 
     ,sum(case 
     when (exclusions is not null or 
extras is not null) then 1 else 0
end) as changed_orders,
	sum(case 
     when (exclusions is  null and 
extras is  null) then 1 else 0
end) as not_changed_orders
from pizza_runner.customer_orders as c 
join pizza_runner.runner_orders as r
on c.order_id = r.order_id
where r.cancellation is NULL
group by customer_id ;



-- 8.How many pizzas were delivered that had both exclusions and extras?

select customer_id,
       count(c.pizza_id)
from pizza_runner.customer_orders as c 
join pizza_runner.runner_orders as r
on c.order_id = r.order_id
where exclusions is not null and 
	  extras is not null and
      r.cancellation is null
group by customer_id; 

-- 9.What was the total volume of pizzas ordered for each hour of the day?

select cast(order_time as date) as order_date,
	   extract(hour from order_time) as order_hour,
	   count(*) as num_of_orders
from pizza_runner.customer_orders
group by order_date,order_hour
order by order_date asc,order_hour asc;

-- 10.What was the volume of orders for each day of the week?

select cast(order_time as date) as orderday,
	 date_format(order_time , '%w')  as wk,
	   count(*) as num_of_order
from pizza_runner.customer_orders
group by wk
order by orderday,wk;


-- B. Runner and Customer Experience

-- 1.how many runners signed up for each 1 week period?
--  (i.e. week starts 2021-01-01)
select
	date_format(registration_date , '%w') as wk,
	week(registration_date)as week1,
	dayname(registration_date),
	count(runner_id)
from
	pizza_runner.runners
where
	registration_date >= '2021-01-01'
group by
	wk,
	week1; 

-- 2.What was the average time in minutes it took for each runner
--   to arrive at the Pizza Runner HQ to pickup the order?

select
	ro.runner_id,
	avg(TIMESTAMPDIFF(minute , co.order_time , ro.pickup_time)) as avgtime_to_pickup
from
	pizza_runner.runner_orders ro
join pizza_runner.customer_orders co on
	ro.order_id = co.order_id
group by
	ro.runner_id

	select  * from pizza_runner.runner_orders

-- 3.Is there any relationship between the number of pizzas 
-- and how long the order takes to prepare?
select
	order_time,
	ro.pickup_time,
	TIMEDIFF(co.order_time , ro.pickup_time) as time_takento_prepare,
	count(co.order_id) as num_of_orders
from
	pizza_runner.customer_orders co
join pizza_runner.runner_orders ro on
	co.order_id = ro.order_id
group by
	order_time,
	ro.pickup_time
order by
	num_of_orders desc;

-- -----------------------------------------------------------------------------
select
	co.order_id,
	count(co.order_id) as num_of_orders,
	-- avg(timediff(ro.pickup_time,co.order_time)) as time_takento_prepare
	-- SEC_TO_TIME(AVG(TIME_TO_SEC(ro.pickup_time,co.order_time)))as time_takento_prepare
 avg(timestampdiff(minute , co.order_time, ro.pickup_time)) as time_takento_prepare
from
	pizza_runner.customer_orders co
join pizza_runner.runner_orders ro on
	co.order_id = ro.order_id
group by
	co.order_id;


-- 4.What was the average distance travelled for each customer?
select
	co.customer_id,
	round(avg(distance), 2) as avg_distance
from
	pizza_runner.runner_orders ro
join pizza_runner.customer_orders co on
	ro.order_id = co.order_id
group by
	co.customer_id ;


-- 5.What was the difference between the longest 
--   and shortest delivery times for all orders?
select
	min(duration) - max(duration) as time_diff
from
	pizza_runner.runner_orders ;

-- 6.What was the average speed for each runner for each delivery 
--   and do you notice any trend for these values?

select
	runner_id,
	round(avg(distance / duration), 3) as avg_speed
from
	pizza_runner.runner_orders
group by
	runner_id 
order by
	avg_speed desc;

select  * from pizza_runner.runner_orders


-- 7.What is the successful delivery percentage for each runner?

-- success % = (no of delivery without cancel / no of orders) * 100
select
	runner_id,
	(success_delivery / total_order)* 100 as succ_deliv_perc
from
	(
	select
		runner_id,
		sum(case when cancellation is null then 1 else 0 end) as success_delivery,
		count(order_id) as total_order
	from
		pizza_runner.runner_orders
	group by
		runner_id ) as subquery;
	   
select * from pizza_runner.customer_orders co

-- C. Ingredient Optimisation
-- 1.What are the standard ingredients for each pizza?

select pizza_name,
	   toppings
from pizza_runner.pizza_names pn 
join pizza_runner.pizza_recipes pr 
on pn.pizza_id =pr.pizza_id; 


-- 2. What was the most commonly added extra?

select extras,
       count(extras)
from pizza_runner.customer_orders co 
where extras is not null
group by extras 
order by count(extras) desc 
limit 1

-- 3.What was the most common exclusion?

select exclusions from pizza_runner.customer_orders

select exclusions,
       count(exclusions)
from pizza_runner.customer_orders co 
where exclusions is not null
group by exclusions 
order by count(exclusions) desc 
limit 1


/* 4.Generate an order item for each record in the customers_orders table 
 * in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - 
              Extra Mushroom, Peppers
*/

-- SET sql_mode='PIPES_AS_CONCAT'

  select co.*,pn.pizza_name 
  			  || case when exc.topping_id is not null then ' - Exclude ' ||exc.topping_Name else '' end
  			  || case when ext.topping_id is not null then ' - Extra ' ||ext.topping_Name else '' end as pizza_name
  -- concat_ws (",",pn.pizza_name,pt.topping_name) as order_items
  		
  from pizza_runner.customer_orders co 
  join pizza_runner.pizza_names pn   on co.pizza_id = pn.pizza_id 
  left join pizza_runner.pizza_toppings exc   on co.exclusions = exc.topping_id 
  left join pizza_runner.pizza_toppings ext   on co.extras = ext.topping_id 
  
  
/* 5.Generate an alphabetically ordered comma separated ingredient list for 
     each pizza order from the customer_orders table and 
     add a 2x in front of any relevant ingredients
     For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"*/
 

 select  exclusions,
 SUBSTRING_INDEX(exclusions,', ',1)as ex_one,
SUBSTRING_INDEX(exclusions,',',-1)as ex_two
from pizza_runner.customer_orders co; 





  select co.order_id,
  		 co.customer_id,
  		 co.order_time,
  		 co.pizza_id,
    	 SUBSTRING_INDEX(co.exclusions,',',1)as ex_one,
		 substring_index(SUBSTRING_INDEX(co.exclusions,',',-1),',',2)as ex_two,
		 SUBSTRING_INDEX(co.extras,',',1)as extra_one,
		 SUBSTRING_INDEX(co.extras,',',-1)as extra_two,
  		 pn.pizza_name 
  		 || case when SUBSTRING_INDEX(co.exclusions,',',1) <> SUBSTRING_INDEX(co.exclusions,',',-1)
  		    is not null then ' - Exclude '||exc.topping_Name else '' end
  		    
  		--  || case when SUBSTRING_INDEX(co.exclusions,',',-1) is not null then ' , '||exc.topping_Name else '' end
  		 
  		 || case when SUBSTRING_INDEX(co.extras,',',1) <>SUBSTRING_INDEX(co.extras,',',-1)  
  		    is not null then ' - Extra '||ext.topping_Name else '' end
  		 
  		 -- || case when SUBSTRING_INDEX(co.extras,',',-1) is not null then ' , '||ext.topping_Name else '' end
  		 
  		--  || case when exc.topping_id is not null then ' - Exclude ' ||exc.topping_Name else '' end
  		 -- || case when ext.topping_id is not null then ' - Extra ' ||ext.topping_Name else '' end as pizza_na
  from pizza_runner.customer_orders co 
  join pizza_runner.pizza_names pn   on co.pizza_id = pn.pizza_id 
  left join pizza_runner.pizza_toppings exc   on co.exclusions = exc.topping_id 
  left join pizza_runner.pizza_toppings ext   on co.extras = ext.topping_id 
  
  
  /*What is the total quantity of each ingredient used in 
  all delivered pizzas sorted by most frequent first?*/
  
	 select co.order_id,
  		 co.customer_id,
  		 co.order_time,
  		 co.pizza_id,
  		 substring_index(exc.topping_name,',',1) as exc_topng_name,
  		 substring_index(ext.topping_name,',',-1) as ext_topng_name
  		 from  pizza_runner.customer_orders co 
  join pizza_runner.pizza_names pn   on co.pizza_id = pn.pizza_id 
  left join pizza_runner.pizza_toppings exc   on co.exclusions = exc.topping_id 
  left join pizza_runner.pizza_toppings ext   on co.extras = ext.topping_id 
		 
  -- D. Pricing and Ratings 
		 
/*f a Meat Lovers pizza costs $12 and 
 * 	  Vegetarian costs $10 and 
 *    there were no charges for changes -
 *    how much money has Pizza Runner made so far 
 *    if there are no delivery fees?*/	
  
  select
	pizza_id,
	count(pizza_id),
	sum(case when pizza_id = 1 then 1 else 0 end) * 12 as total_cost_meatlover,
	sum(case when pizza_id = 2 then 1 else 0 end) * 10 as total_cost_veggie
from
	pizza_runner.customer_orders co
join pizza_runner.runner_orders ro on
	co.order_id = ro.order_id
where
	ro.cancellation is null
group by
	pizza_id;
  
-- 2.What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra	 
		
select *,
	   pizza_rate + extra_charge as total_cost
	   from
( 
  select *,
	case 
	when pizza_id = 1 then  12  else 
	10 end as pizza_rate,
	case	
	when extras is not null 
	and length(extras) = 1 then 1 
	when extras is not null 
	and length(extras) > 1 then 2
	else 0 end 
	as extra_charge
from
	pizza_runner.customer_orders co
) as subquery
	
 /* 3.The Pizza Runner team now wants to add 
     an additional ratings system that allows customers to 
     rate their runner, how would you design an additional table
     for this new dataset - generate a schema for this new table
     and insert your own data for ratings for 
     each successful customer order between 1 to 5.
     
    4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
	 customer_id
	order_id
	runner_id
	rating
	order_time
	pickup_time
	Time between order and pickup
	Delivery duration
	Average speed
	Total number of pizzas*/


CREATE SCHEMA order_ratings
SET search_path = pizza_ratings;


create table order_ratings.ratings
(
order_id int,
order_rating int
);

insert into order_ratings.ratings
(order_id,order_rating) 
values
(1,3),
(2,4),
(3,5),
(4,2),
(5,5),
(6,4),
(7,3),
(8,1),
(9,5),
(10,4);
  
select * from order_ratings.ratings

select
	pizza_runner.co.customer_id,
	order_ratings.ora.order_id,
	pizza_runner.ro.runner_id,
	order_ratings.ora.order_rating,
	pizza_runner.co.order_time,''
	pizza_runner.ro.pickup_time,
	timestampdiff(minute,
	pizza_runner.co.order_time,
	pizza_runner.ro.pickup_time) as time_diff,
	pizza_runner.ro.duration,
	avg(pizza_runner.ro.distance / pizza_runner.ro.duration) as avarage_speed,
	count(pizza_runner.co.order_id) as total_num_pizz
from
	order_ratings.ratings ora
right join pizza_runner.customer_orders co on
	order_ratings.ora.order_id = pizza_runner.co.order_id
right join pizza_runner.runner_orders ro on
	order_ratings.ora.order_id = pizza_runner.ro.order_id
where
	pizza_runner.ro.cancellation is null
	group by order_ratings.ora.order_id;


/* 5. If a Meat Lovers pizza was $12 and Vegetarian $10 
 * fixed prices with no cost for extras and each runner 
 * is paid $0.30 per kilometre traveled - how much money 
 * does Pizza Runner have left over after these deliveries?*/


select * from pizza_runner.runner_orders ro 


select runner_id,
	   total_amnt - amnt_paid_by_runner as money_left_over
	   from 
(
select runner_id,
	   total_cost_meatlover +  total_cost_veggie as total_amnt,
	   distance * 0.30 as amnt_paid_by_runner	   
from 
(
  select
	runner_id,
	distance,
	sum(case when pizza_id = 1 then 1 else 0 end) * 12 as total_cost_meatlover,
	sum(case when pizza_id = 2 then 1 else 0 end) * 10 as total_cost_veggie
from
	pizza_runner.customer_orders co
join pizza_runner.runner_orders ro on
	co.order_id = ro.order_id
where
	ro.cancellation is null
group by
	runner_id)as subquery
)as subquery

/*E. Bonus Questions
 * 
	If Danny wants to expand his range of pizzas - 
	how would this impact the existing data design?
	Write an INSERT statement to demonstrate what 
	would happen if a new Supreme pizza with all the
 	toppings was added to the Pizza Runner menu?*/


select * from pizza_runner.pizza_names pn 

insert into pizza_runner.pizza_names
(pizza_id,pizza_name)
values 
(3,'Supreme');


select * from pizza_runner.pizza_recipes pr 

insert into pizza_runner.pizza_recipes 
(pizza_id,toppings)
values 
(3,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');

delete from pizza_runner.pizza_recipes 
where pizza_id =3;



  