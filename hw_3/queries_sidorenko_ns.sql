/* Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества */

select job_industry_category, count(customer_id) as cnt_customer
from customer c 
group by job_industry_category
order by count(customer_id) desc;



/* Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. */

select date_trunc('month', to_date(transaction_date, 'DD.MM.YYYY'))::date as partition_month, c.job_industry_category, sum(list_price) as sum_transactions
from "transaction" t
join customer c 
on t.customer_id = c.customer_id 
group by date_trunc('month', to_date(transaction_date, 'DD.MM.YYYY'))::date, c.job_industry_category
order by date_trunc('month', to_date(transaction_date, 'DD.MM.YYYY'))::date, c.job_industry_category;



/* Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. */

select brand, count(transaction_id) as cnt_orders
from "transaction" t
join customer c 
on t.customer_id = c.customer_id and c.job_industry_category = 'IT'
where 1=1
and t.online_order = 'True'
and t.order_status = 'Approved'
group by brand
order by brand;


/* Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. 
 * Выполните двумя способами: используя только group by и используя только оконные функции. */

select 
	customer_id, 
	sum(list_price) as sum_list_price, 
	max(list_price) as max_list_price,
	min(list_price) as min_list_price,
	count(t.transaction_id) as cnt_transactions
from "transaction" t
group by customer_id
order by sum(t.list_price) desc, count(t.transaction_id) desc;

select 
	customer_id, 
	sum(list_price) over (partition by customer_id) as sum_list_price, 
	max(list_price) over (partition by customer_id) as max_list_price,
	min(list_price) over (partition by customer_id) as min_list_price,
	count(t.transaction_id) over (partition by customer_id) as cnt_transactions
from "transaction" t
order by sum_list_price desc, cnt_transactions desc;



/* Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). 
 * Напишите отдельные запросы для минимальной и максимальной суммы. */

select c.first_name, c.last_name, sum(t.list_price)
from "transaction" t 
join customer c 
on t.customer_id = c.customer_id
where 1=1
and t.list_price is not null
group by c.first_name, c.last_name
order by sum(t.list_price) desc
limit 1;

select c.first_name, c.last_name, sum(t.list_price)
from "transaction" t 
join customer c 
on t.customer_id = c.customer_id
where 1=1
and t.list_price is not null
group by c.first_name, c.last_name
order by sum(t.list_price)
limit 1;



/* Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. */

select distinct tmp_table.transaction_id
from 
	(select distinct transaction_id,
		row_number() over (partition by customer_id order by date_trunc('month', to_date(transaction_date, 'DD.MM.YYYY'))::date) as rw_list
	from "transaction" t) as tmp_table
where rw_list = 1;



/* Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) */

with 
intervals_dt as
(select distinct c.first_name, c.last_name, c.job_title,
	LEAD(to_date(transaction_date, 'DD.MM.YYYY')) OVER (PARTITION BY t.customer_id ORDER BY to_date(transaction_date, 'DD.MM.YYYY')) - to_date(transaction_date, 'DD.MM.YYYY') AS interval_dt
from "transaction" t 
left join customer c 
on t.customer_id = c.customer_id),
max_interval as
(select max(interval_dt) as interval_dt
from intervals_dt)
select distinct c.first_name, c.last_name, c.job_title
from intervals_dt c
join max_interval m
on c.interval_dt = m.interval_dt;