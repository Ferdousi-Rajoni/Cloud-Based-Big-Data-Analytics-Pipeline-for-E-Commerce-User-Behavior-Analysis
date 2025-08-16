WITH user_purchases AS (
    SELECT 
        visitorid,
        itemid
    FROM cleaned_events
    WHERE event = 'transaction'
),
user_views AS (
    SELECT 
        visitorid,
        itemid
    FROM cleaned_events
    WHERE event = 'view'
),
product_recommendations AS (
    SELECT 
        p.itemid AS purchased_item,
        v.itemid AS recommended_item,
        COUNT(*) AS times_viewed_together
    FROM user_purchases p
    JOIN user_views v ON p.visitorid = v.visitorid
    WHERE p.itemid <> v.itemid
    GROUP BY p.itemid, v.itemid
),
ranked_recommendations AS (
    SELECT 
        purchased_item,
        recommended_item,
        times_viewed_together,
        ROW_NUMBER() OVER (PARTITION BY purchased_item ORDER BY times_viewed_together DESC) AS rank
    FROM product_recommendations
)
SELECT 
    rr.purchased_item,
    pw.categoryid AS purchased_category,
    rr.recommended_item,
    rw.categoryid AS recommended_category,
    rr.times_viewed_together,
    rr.rank
FROM ranked_recommendations rr
LEFT JOIN cleaned_item_properties_wide pw
    ON CAST(rr.purchased_item AS VARCHAR) = pw.itemid
LEFT JOIN cleaned_item_properties_wide rw
    ON CAST(rr.recommended_item AS VARCHAR) = rw.itemid
WHERE rr.rank <= 5
ORDER BY rr.purchased_item, rr.rank;
