WITH all_recommendations AS (
    -- All unique views after a purchase as recommendations
    SELECT 
        p.visitorid,
        p.itemid AS purchased_item,
        v.itemid AS recommended_item,
        MIN(v.timestamp) AS recommendation_timestamp
    FROM cleaned_events p
    JOIN cleaned_events v 
        ON p.visitorid = v.visitorid
        AND p.timestamp < v.timestamp
    WHERE p.event = 'transaction'
        AND v.event = 'view'
        AND p.itemid <> v.itemid
    GROUP BY p.visitorid, p.itemid, v.itemid
),
total_recommendations AS (
    -- Total unique recommendations per purchased_item and recommended_item
    SELECT 
        purchased_item,
        recommended_item,
        COUNT(DISTINCT visitorid) AS unique_total_recommendations
    FROM all_recommendations
    GROUP BY purchased_item, recommended_item
),
all_purchases AS (
    -- All purchases after recommendations
    SELECT 
        r.visitorid,
        r.purchased_item,
        r.recommended_item,
        p.itemid AS purchased_recommended_item,
        p.timestamp AS purchase_timestamp
    FROM all_recommendations r
    JOIN cleaned_events p 
        ON r.visitorid = p.visitorid
        AND p.itemid = r.recommended_item
        AND p.timestamp > r.recommendation_timestamp
    WHERE p.event = 'transaction'
),
purchase_counts AS (
    -- Count unique purchases per recommendation pair
    SELECT 
        purchased_item,
        recommended_item,
        COUNT(DISTINCT visitorid) AS unique_purchased_recommendations
    FROM all_purchases
    GROUP BY purchased_item, recommended_item
)
SELECT 
    tr.purchased_item,
    tr.recommended_item,
    tr.unique_total_recommendations,
    COALESCE(pc.unique_purchased_recommendations, 0) AS unique_purchased_recommendations,
    ROUND(
        COALESCE(pc.unique_purchased_recommendations, 0) * 100.0 /
        NULLIF(tr.unique_total_recommendations, 0), 2
    ) AS conversion_rate_percent
FROM total_recommendations tr
LEFT JOIN purchase_counts pc
    ON tr.purchased_item = pc.purchased_item
    AND tr.recommended_item = pc.recommended_item
WHERE tr.unique_total_recommendations > 0
ORDER BY conversion_rate_percent DESC
LIMIT 50;