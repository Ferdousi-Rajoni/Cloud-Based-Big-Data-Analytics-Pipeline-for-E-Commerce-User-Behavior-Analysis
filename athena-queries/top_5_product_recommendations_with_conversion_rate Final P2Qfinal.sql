WITH purchases AS (
    SELECT DISTINCT visitorid, itemid
    FROM cleaned_events
    WHERE event = 'transaction'
),
views AS (
    SELECT DISTINCT visitorid, itemid
    FROM cleaned_events
    WHERE event = 'view'
),
pairings AS (
    SELECT 
        p.visitorid,
        p.itemid AS purchased_item,
        v.itemid AS recommended_item
    FROM purchases p
    JOIN views v 
        ON p.visitorid = v.visitorid
    WHERE p.itemid <> v.itemid
),
item_stats AS (
    SELECT
        v.itemid AS item_id,
        COUNT(DISTINCT v.visitorid) AS total_viewers,
        COUNT(DISTINCT p.visitorid) AS total_buyers
    FROM views v
    LEFT JOIN purchases p 
        ON v.visitorid = p.visitorid 
       AND v.itemid = p.itemid
    GROUP BY v.itemid
),
ranked_recs AS (
    SELECT 
        pr.purchased_item,
        pr.recommended_item,
        s.total_viewers,
        s.total_buyers,
        ROUND(COALESCE(s.total_buyers, 0) * 100.0 / NULLIF(s.total_viewers, 0), 2) AS conversion_rate_percent,
        ROW_NUMBER() OVER (PARTITION BY pr.purchased_item ORDER BY COALESCE(s.total_buyers, 0) DESC) AS rank
    FROM pairings pr
    JOIN item_stats s
        ON pr.recommended_item = s.item_id
)
SELECT 
    purchased_item,
    recommended_item,
    total_viewers,
    total_buyers,
    conversion_rate_percent,
    rank
FROM ranked_recs
WHERE rank <= 5
ORDER BY purchased_item, rank;
