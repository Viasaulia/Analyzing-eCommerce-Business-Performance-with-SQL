--Tugas 2 nomor 1
select year,
round(avg(mau),2) as average_mau
from
(SELECT 
strftime('%Y', o.purchase_timestamp) AS year,
strftime('%m', o.purchase_timestamp) as month,
count(distinct c.customer_id_unique) as mau
from orders o
join customer c
on o.customer_id = c.customer_id
group by 1,2) subq
group by 1
;

--Tugas 2 nomor 2
select first_order,
count(distinct first_cust) as cust
from
(select 
c.customer_id_unique as first_cust,
min(strftime('%Y', o.purchase_timestamp)) as first_order
from orders o
join customer c
on o.customer_id = c.customer_id
group  by 1) subq
group by 1;

--tugas 2 nomorr 3
select year, count(repeat_cust) as repeat_order
from
(select
strftime('%Y', o.purchase_timestamp) as year,
c.customer_id_unique as cust,
count(2) as repeat_cust
from orders o
join customer c
on o.customer_id = c.customer_id
group by 1,2
having count(2) > 1) subq
group by 1;

--tugas 2 nomor 4
select year, avg(total_order) as order_frequence
from
(select
strftime('%Y', o.purchase_timestamp) as year,
c.customer_id_unique as cust,
count(2) as total_order
from orders o
join customer c
on o.customer_id = c.customer_id
group by 1,2) subq
group by 1;