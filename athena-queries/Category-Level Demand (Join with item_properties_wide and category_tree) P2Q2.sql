WITH item_props AS (
    SELECT 
        itemid, 
        categoryid AS categoryid_str
    FROM cleaned_item_properties_wide
    WHERE categoryid IS NOT NULL
), 
category_tree_casted AS (
    SELECT 
        CAST(categoryid AS VARCHAR) AS categoryid_str
    FROM cleaned_category_tree
)
SELECT 
    ip.categoryid_str AS category_id,
    COUNT(*) AS total_purchases
FROM 
    cleaned_events e
JOIN 
    item_props ip ON CAST(e.itemid AS VARCHAR) = ip.itemid
JOIN 
    category_tree_casted ct ON ip.categoryid_str = ct.categoryid_str
WHERE 
    e.event = 'transaction'
    AND e.event_time <= TIMESTAMP '2025-07-28 16:35:00' -- Updated to current time (04:35 PM MDT)
GROUP BY 
    ip.categoryid_str
ORDER BY 
    total_purchases DESC
LIMIT 10;