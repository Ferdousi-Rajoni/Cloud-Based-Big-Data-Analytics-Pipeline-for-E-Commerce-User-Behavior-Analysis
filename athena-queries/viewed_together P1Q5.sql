CREATE TABLE viewed_together AS
WITH user_purchases AS (
  SELECT visitorid, itemid
  FROM cleaned_events
  WHERE event = 'transaction'
),
user_views AS (
  SELECT visitorid, itemid
  FROM cleaned_events
  WHERE event = 'view'
)
SELECT
  p.itemid AS purchased_item,
  v.itemid AS viewed_item,
  COUNT(*) AS times_viewed_together
FROM user_purchases p
JOIN user_views v
  ON p.visitorid = v.visitorid
WHERE p.itemid <> v.itemid
GROUP BY 1,2
ORDER BY times_viewed_together DESC;
