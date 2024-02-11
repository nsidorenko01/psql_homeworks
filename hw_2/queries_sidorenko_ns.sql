/*  Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов. */

select distinct brand
from "transaction" 
where standard_cost > 1500;



/*  Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно. */

select *
from "transaction" 
where 1=1
and to_date(transaction_date, 'DD.MM.YYYY') between '2017-04-01' and '2017-04-09'
and order_status = 'Approved';



/* Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'. */

select distinct job_title 
from "customer"
where 1=1
and job_industry_category IN ('IT', 'Financial Services')
and job_title like 'Senior%';



/* Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services */

select distinct brand
from "transaction" t 
join
	(select distinct customer_id
	from customer
	where job_industry_category = 'Financial Services') c
on t.customer_id = c.customer_id;



/* Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'. */

select distinct customer_id
from "transaction"
where 1=1
and online_order = 'True'
and brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
limit 10;



/* Вывести всех клиентов, у которых нет транзакций. */

select distinct c.customer_id
from customer c 
left join "transaction" t 
on c.customer_id = t.customer_id
where t.customer_id is null;



/* Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью. */

select distinct t.customer_id 
from "transaction" t 
join customer c 
on t.customer_id = c.customer_id and c.job_industry_category = 'IT'
where t.standard_cost in (select max(standard_cost) from "transaction");



/* Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'. */

select distinct t.customer_id 
from "transaction" t 
join customer c 
on t.customer_id = c.customer_id and c.job_industry_category in ('IT', 'Health')
where 1=1
and t.order_status = 'Approved'
and to_date(transaction_date, 'DD.MM.YYYY') between '2017-07-07' and '2017-07-17';