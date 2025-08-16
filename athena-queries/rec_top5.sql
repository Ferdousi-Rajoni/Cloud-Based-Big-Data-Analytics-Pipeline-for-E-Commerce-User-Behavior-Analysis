CREATE TABLE rec_top5 AS
WITH user_purchases AS (
    SELECT visitorid, itemid
    FROM cleaned_events
    WHERE event = 'transaction'
),
user_views AS (
    SELECT visitorid, itemid
    FROM cleaned_events
    WHERE event = 'view'
),
product_recommendations AS (
    SELECT 
        p.itemid AS purchased_item,
        v.itemid AS recommended_item,
        COUNT(*) AS times_viewed_together
    FROM user_purchases p
    JOIN user_views v 
        ON p.visitorid = v.visitorid
    WHERE p.itemid <> v.itemid
    GROUP BY p.itemid, v.itemid
)
SELECT purchased_item, recommended_item, times_viewed_together
FROM (
    SELECT 
        purchased_item,
        recommended_item,
        times_viewed_together,
        ROW_NUMBER() OVER (PARTITION BY purchased_item ORDER BY times_viewed_together DESC) AS rank
    FROM product_recommendations
) ranked
WHERE rank <= 5;
