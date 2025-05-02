-- Dataset name: Classic models

-- calculate sales value, cost sales, net profit

select 
/*t1.orderDate,
t1.orderNumber,
quantityOrdered,
priceEach,
productName,
productLine,
buyPrice,
city,
country,*/
(t2.quantityOrdered * t2.priceEach) as salesValue,
(t2.quantityOrdered * t3.buyPrice) as costSales,
(t2.quantityOrdered * t2.priceEach) as netProfit

from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join products t3
on t2.productCode = t3.productCode
inner join customers t4
on t1.customerNumber = t4.customerNumber
where year(orderDate) = 2004;

-- sales breakdown in 2004 by country

select 
country,
sum(t2.priceEach * t2.quantityOrdered) as total_sales

from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join products t3
on t2.productCode = t3.productCode
inner join customers t4
on t1.customerNumber = t4.customerNumber
where year(orderDate) = 2004
group by country
order by total_sales desc;

-- products purchased together
with prod_sales as
(
select orderNumber, t1.productCode, productLine
from orderdetails t1
inner join products t2
on t1.productCode = t2.productCode
)


select *
from prod_sales t1
left join prod_sales t2
on t1.ordernumber = t2.ordernumber and t1.productline <> t2.productline;

-- customer sales value by credit limit
with sales as
(
select t1.orderNumber, t1.customerNumber, productCode, quantityOrdered, priceEach,
priceEach * quantityOrdered as sales_value,
creditLimit
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber 
inner join customers t3
on t1.customerNumber = t3.customerNumber
)

select ordernumber, customernumber,
case when creditLimit < 75000 then 'a: Less than $75K'

when creditLimit between 75000 and 100000  then 'b: $75K - $100k'

when creditLimit between 100000 and 150000  then 'c: $100K - $150k'

when creditLimit > 150000 then 'd: over $150k'

else 'other' end as credit_limit_grp,

sum(sales_value) as sales_value
from sales 
group by ordernumber, customernumber, creditLimit;

-- sales value change from previous order

with main as
(
select t1.orderNumber, orderDate, customerNumber, productCode, quantityOrdered * priceEach as sales_value
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber),

main_cte as
(

select orderNumber, orderDate, customerNumber, sum(sales_value) as sales_value
from main
group by orderNumber, orderDate, customerNumber)

select t1.*, 
customerName,
row_number() over (partition by customerName order by orderdate) as purchase_number
from main_cte t1
inner join customers t2
on t1.customernumber = t2.customerNumber;

-- office sales by customer country
with main as
(
select 
t1.orderNumber,
t2.productCode,
t2.quantityOrdered,
t2.priceEach,
quantityOrdered * priceEach as sales_value,
t3.city as customer_city,
t3.country as customer_country,
t4.productLine,
t6.city as office_city,
t6.country as office_country


from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join customers t3
on t1.customerNumber = t3.customerNumber
inner join products t4
on t2.productCode = t4.productCode
inner join employees t5
on t3.salesRepEmployeeNumber = t5.employeeNumber
inner join offices t6
on t5.officeCode = t6.officeCode)

select 
ordernumber,
customer_city,
customer_country,
productline,
office_city,
office_country,
sum(sales_value) as sales_value


from main
group by
ordernumber,
customer_city,
customer_country,
productline,
office_city,
office_country;


/* we have discovered that shipping is delayed due to weather, and its possible they will take up to 3 days to
arrive. Can you get the lust of affecteed orders?*/

select 
orderNumber, 
orderDate, 
requiredDate, 
shippedDate,
date_add(shippedDate, interval 3 day) as latest_date,
case when date_add(shippedDate, interval 3 day) > requiredDate then 1 else 0 end as late_flag
from orders
where
(case when date_add(shippedDate, interval 3 day) > requiredDate then 1 else 0 end) = 1 ;