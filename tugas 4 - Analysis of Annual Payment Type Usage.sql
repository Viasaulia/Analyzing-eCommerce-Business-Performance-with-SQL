--tugas 4 nomor1

SELECT payment_type,
       count(order_id) AS total_payment_usage
  FROM order_payment
 GROUP BY 1
 ORDER BY 2 DESC;
 
-- tugas 4 nomor 2

SELECT op.payment_type,
       sum(CASE WHEN (strftime('%Y', o.purchase_timestamp) ) = '2016' THEN 1 ELSE 0 END) AS year_2016,
       sum(CASE WHEN (strftime('%Y', o.purchase_timestamp) ) = '2017' THEN 1 ELSE 0 END) AS year_2017,
       sum(CASE WHEN (strftime('%Y', o.purchase_timestamp) ) = '2018' THEN 1 ELSE 0 END) AS year_2018
  FROM order_payment op
       JOIN
       orders o ON op.order_id = o.order_id
 GROUP BY 1
 ORDER BY 4 DESC;
