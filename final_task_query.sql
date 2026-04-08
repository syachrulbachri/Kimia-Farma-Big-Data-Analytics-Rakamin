CREATE OR REPLACE TABLE `kimia_farma.tabel_analisa` AS
WITH base_data AS (
  SELECT 
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    CASE 
      WHEN t.price <= 50000 THEN 0.10
      WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
      WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
      WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS persentase_gross_laba,
    t.rating AS rating_transaksi
  FROM `kimia_farma. kf_final_transaction` AS t
  LEFT JOIN `kimia_farma.kf_kantor_cabang` AS c ON t.branch_id = c.branch_id
  LEFT JOIN `kimia_farma.kf_product` AS p ON t.product_id = p.product_id
)
SELECT 
  *,
  (actual_price * (1 - discount_percentage)) AS nett_sales,
  ((actual_price * (1 - discount_percentage)) * persentase_gross_laba) AS nett_profit
FROM base_data;