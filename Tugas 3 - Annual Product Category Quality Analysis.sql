-- tugas 3 nomor 1
CREATE TEMP TABLE annual_rev AS SELECT strftime('%Y', o.purchase_timestamp) AS year,
                                       round(sum(oi.order_item * oi.price), 2) AS revenue
                                  FROM orders o
                                       JOIN
                                       order_items oi ON o.order_id = oi.order_id
                                 GROUP BY 1;

SELECT *
  FROM annual_rev;

-- tugas 3 nomor 2

CREATE TEMP TABLE total_cancel AS SELECT strftime('%Y', purchase_timestamp) AS year,
                                         count(order_id) AS total_cancel
                                    FROM orders
                                   WHERE status = 'canceled'
                                   GROUP BY 1;

SELECT *
  FROM total_cancel;
  
-- tugas 3 nomor 3

CREATE TEMP TABLE annual_best_category AS SELECT year,
                                                 category,
                                                 total_revenue,
                                                 ranking
                                            FROM (
                                                     SELECT year,
                                                            category,
                                                            total_revenue,
                                                            rank() OVER (PARTITION BY year ORDER BY total_revenue DESC,
                                                            category) AS ranking
                                                       FROM (
                                                                SELECT strftime('%Y', o.purchase_timestamp) AS year,
                                                                       rev.category AS category,
                                                                       round(sum(rev.revenue), 2) AS total_revenue
                                                                  FROM (
                                                                           SELECT oi.order_id,
                                                                                  p.product_category AS category,
                                                                                  round(oi.order_item * oi.price, 2) AS revenue
                                                                             FROM order_items oi
                                                                                  JOIN
                                                                                  product p ON oi.product_id = p.product_id
                                                                       )
                                                                       rev
                                                                       JOIN
                                                                       orders o ON rev.order_id = o.order_id
                                                                 GROUP BY 1,
                                                                          2
                                                            )
                                                            total_rev
                                                 )
                                           WHERE ranking = 1;

SELECT *
  FROM annual_best_category;
  
-- tugas 3 nomor 4

CREATE TEMP TABLE annual_cancel_cat AS SELECT year,
                                              category,
                                              status,
                                              total_cancel,
                                              ranking
                                         FROM (
                                                  SELECT year,
                                                         category,
                                                         status,
                                                         total_cancel,
                                                         rank() OVER (PARTITION BY year ORDER BY total_cancel DESC,
                                                         category) ranking
                                                    FROM (
                                                             SELECT strftime('%Y', o.purchase_timestamp) AS year,
                                                                    cat.category AS category,
                                                                    o.status AS status,
                                                                    count(o.order_id) AS total_cancel
                                                               FROM (
                                                                        SELECT oi.order_id AS order_id,
                                                                               p.product_category AS category
                                                                          FROM order_items oi
                                                                               JOIN
                                                                               product p ON oi.product_id = p.product_id
                                                                    )
                                                                    cat
                                                                    JOIN
                                                                    orders o ON cat.order_id = o.order_id
                                                              WHERE status = 'canceled'
                                                              GROUP BY 1,
                                                                       2
                                                         )
                                                         cancel
                                              )
                                        WHERE ranking = 1;

SELECT *
  FROM annual_cancel_cat;
  
-- tugas 3 nomor 5

SELECT subq2.year AS year,
       subq2.total_revenue AS total_revenue,
       subq2.best_category AS high_revenue_category,
       subq2.category_revenue as category_revenue,
       subq2.total_cancel as total_cancel,
       ann_cancel.category AS top_cancel_category,
       ann_cancel.total_cancel as category_cancel
  FROM (
           SELECT subq1.year AS year,
                  subq1.total_revenue AS total_revenue,
                  ann_cat.category AS best_category,
                  ann_cat.total_revenue as category_revenue,
                  subq1.total_cancel as total_cancel
             FROM (
                      SELECT ar.year AS year,
                             ar.revenue AS total_revenue,
                             tc.total_cancel AS total_cancel
                        FROM annual_rev ar
                             JOIN
                             total_cancel tc ON ar.year = tc.year
                  )
                  subq1
                  JOIN
                  annual_best_category ann_cat ON subq1.year = ann_cat.year
       )
       subq2
       JOIN
       annual_cancel_cat ann_cancel ON subq2.year = ann_cancel.year;
