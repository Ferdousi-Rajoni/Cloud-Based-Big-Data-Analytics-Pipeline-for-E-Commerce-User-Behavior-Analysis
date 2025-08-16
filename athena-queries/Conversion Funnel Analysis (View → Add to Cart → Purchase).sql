-- View counts per item
WITH views AS (
  SELECT itemid, COUNT(*) AS view_count
  FROM cleaned_events
  WHERE event = 'view'
  GROUP BY itemid
),
add_to_cart AS (
  SELECT itemid, COUNT(*) AS cart_count
  FROM cleaned_events
  WHERE event = 'addtocart'
  GROUP BY itemid
),
purchases AS (
  SELECT itemid, COUNT(*) AS purchase_count
  FROM cleaned_events
  WHERE event = 'transaction'
  GROUP BY itemid
)

SELECT 
  v.itemid,
  v.view_count,
  COALESCE(a.cart_count, 0) AS cart_count,
  COALESCE(p.purchase_count, 0) AS purchase_count,
  ROUND(COALESCE(a.cart_count, 0) * 100.0 / v.view_count, 2) AS view_to_cart_rate,
  ROUND(COALESCE(p.purchase_count, 0) * 100.0 / COALESCE(a.cart_count, 1), 2) AS cart_to_purchase_rate
FROM views v
LEFT JOIN add_to_cart a ON v.itemid = a.itemid
LEFT JOIN purchases p ON v.itemid = p.itemid
ORDER BY view_count DESC
LIMIT 50;
