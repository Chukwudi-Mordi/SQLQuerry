-- how many transaction where greater than $5.00

select count(*)
from payment
where amount > 5;

/* shows full table of those who made payment more than $5*/
select *
from payment
where amount > 5;


-- how many actors have thier first_name start with letter P

select *
from actor
where first_name like 'P%';

-- how many unique dustricts do our customers come from?

select count(distinct district)
from address;

select distinct (district)
from address;

-- how many films have a rating of R and replacement cost between $5 and $15?

select rating, replacement_cost
from film
where rating = 'R' and replacement_cost between 5 and 15;

-- how many films have the world Truman somewhere in the title

select title
from film
where title like '%Truman%';

-- emails of customers that live in Califonia
select district, email, first_name
from customer t1
inner join address as t2
on t1.address_id = t2.address_id
where district = 'California'






select first_name, last_name, email from customer;

select distinct (rating) from film;

select count (customer_id) 
from customer;

select count(distinct actor_id)
from actor;

select * from customer;

select count(title)
from film;


select count(*)
from film
where rating = 'NC-17';

select count(*)
from film
where rental_rate > 4 
and 
replacement_cost >= 19.99
and
rating = 'R';


select *
from customer
order by first_name asc;

select * 
from payment
where amount != 0.00
order by payment_date desc
limit 5;

-- we want to reward our first 10 paying customers, show customers ids
select customer_id 
from payment
order by payment_date;

-- a customer is on break and wants wacth a short movie
-- provide for him top 5 short movies available

select title,length
from film
order by length asc
limit 5 ;

-- how many can the customers watch that are 50min or less in run time to watch

select count(title)
from film
where length <= 50;

-- another wat to solve above
select count(*)
from film
where length <= 50;

-- using IN LIKE  BETWEEN 

select amount
from payment
where amount between 8 and 9;

select payment_date
from payment
where payment_date between '2007-04-01' and '2007-10-01';

select amount
from payment
where amount in (0.99,1.98,1.99)
order by amount;



select count(*)
from payment
where amount in (0.99,1.98,1.99);

select *
from customer
where first_name in ('John','Jake','Julie');

select *
from customer 
where first_name like 'J%' and last_name like 'S%';

select count(*)
from customer 
where first_name like 'J%';

select *
from customer 
where first_name like '%er%';

select *
from customer 
where first_name like '_er%';

select *
from customer 
where first_name like 'A%' and last_name not like 'B%'
order by last_name;

select min(replacement_cost), max(replacement_cost), count (film_id),
avg (replacement_cost), round(avg(replacement_cost),4)
from film;

select sum(replacement_cost)
from film;

-- total amount paid by each customer

select customer_id, sum(amount)
from payment
group by customer_id
order by sum(amount) desc;

-- total transaction by each customer

select customer_id, count(amount)
from payment
group by customer_id
order by count(amount);

-- grouping 2 columns shows diff customers and diff staff on trans
select customer_id, staff_id, sum(amount)
from payment
group by customer_id, staff_id
order by sum(amount) desc;

-- staff with the most transaction

select staff_id, count(amount)
from payment
group by staff_id
order by count(amount) desc;

-- what is the AVG replacement cost of each MPAA rating

select rating, round(avg(replacement_cost),2) as avg_rep_cost
from film
group by rating
order by avg(replacement_cost) desc;

-- we want to run a reward for our top 5 customers, what the customerID of the top 5 customers
-- by total spend

select customer_id, sum(amount)
from payment
group by customer_id
order by sum(amount) desc
limit 5;

select store_id, count(customer_id)
from customer
group by store_id
having count(customer_id) >300;

-- customers who made transactions more than 40 that eligible for platinum status

select customer_id, count(amount)
from payment
group by customer_id
having count(amount) >=40;

-- customers who have made transactions more than $100 with staff_id2

select staff_id, customer_id, sum(amount)
from payment
where staff_id = 2
group by customer_id, staff_id
having sum(amount) > 100;

alter table payment rename column amount to rent_price;

alter table payment rename column rent_price to amount;
select *
from payment;

-- Time Zones

/*show timezone;

select now();*/


select extract (year from payment_date) as year 
from payment;

select extract (month from payment_date) as pay_month
from payment;

/*select extract (quater from payment_date) as quater 
from payment;*/

select age (payment_date)  
from payment;

-- converting date to text as out put

select to_char (payment_date,'MONTH YYYY')
from payment;

select length (first_name) 
from customer;

select first_name || ' ' || last_name as full_name
from customer;

select lower(left(first_name,1)) || lower(last_name) || '@gmail.com' 
as custom_email
from customer;

-- subquery
-- return the title and film id whose rental rate are higher than the avg rental price

select film_id,title
from film
where film_id in
(select t2.film_id
from rental t1
inner join inventory t2
on t1.inventory_id = t2.inventory_id
where return_date between '2005-05-29' and '2005-05-30 ')
order by title;


-- hoow the list of students who scored better than the AVG grade?


select student,grade
from test_scores
where grade >
(select avg(grade)
from test_scores) 



select customer_id,
case 
 when (customer_id <= 100) then 'Premium'
 when (customer_id between 100 and 200) then 'Plus'

else 'Normal'
end as customer_class
from customer;

select customer_id,
case customer_id
 when 2 then 'winner'
 when 5 then 'second place'
 
else 'Normal'
end as raffle_result
from customer;

select 
sum (case rental_rate
      when 0.99 then 1
	  else 0
end) as bargains,

sum (case rental_rate
      when 2.99 then 1
	  else 0
end) as regular

from film;


select 
sum (case rating
      when 'R' then 1
	  else 0
end) as R,

sum (case rating
      when 'PG' then 1
	  else 0
end) as PG,

sum (case rating
      when 'PG-13' then 1
	  else 0
end) as PG13

from film,

-- using coalesce
select item, (price - coalesce(discount,0))
from product_table;

-- to delete a rwo
 
delete from table_name
where colomn_name = 'data'
