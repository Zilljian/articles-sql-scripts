CREATE SCHEMA IF NOT EXISTS test_index;

CREATE TABLE IF NOT EXISTS test_index.sales
(
    sale_date  date   not null default current_date,
    product_id bigint not null,
    quantity   int    not null default 1
);

CREATE INDEX IF NOT EXISTS sales_date ON test_index.sales (sale_date);

INSERT INTO test_index.sales (sale_date, product_id, quantity)
SELECT ('2020-01-' || (generator / 200000 + 1)::text)::date,
       generator % 100  AS product_id,
       generator % 1000 AS quantity
FROM generate_series(0, 1000000) AS generator;

SELECT sale_date, product_id, quantity
FROM test_index.sales
WHERE sale_date = '2020-01-06'::date - INTERVAL '1' DAY
ORDER BY sale_date, product_id;

EXPLAIN ANALYSE
SELECT sale_date, product_id, quantity
FROM test_index.sales
WHERE sale_date = '2020-01-06'::date - INTERVAL '1' DAY
ORDER BY sale_date, product_id;

DROP INDEX IF EXISTS test_index.sales_date;

CREATE INDEX IF NOT EXISTS sales_dt_pr ON test_index.sales (sale_date, product_id);

EXPLAIN ANALYSE
SELECT sale_date, product_id, quantity
FROM test_index.sales
WHERE sale_date = '2020-01-06'::date - INTERVAL '1' DAY
ORDER BY sale_date, product_id;

EXPLAIN ANALYSE
SELECT sale_date, product_id, quantity
FROM test_index.sales
WHERE sale_date = '2020-01-06'::date - INTERVAL '1' DAY
ORDER BY product_id;

EXPLAIN ANALYSE
SELECT sale_date, product_id, quantity
FROM test_index.sales
WHERE sale_date >= '2020-01-06'::date - INTERVAL '1' DAY
ORDER BY product_id;
