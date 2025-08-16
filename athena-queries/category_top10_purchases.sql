CREATE TABLE category_top10_purchases AS
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
FROM cleaned_events e
JOIN item_props ip 
    ON CAST(e.itemid AS VARCHAR) = ip.itemid
JOIN category_tree_casted ct 
    ON ip.categoryid_str = ct.categoryid_str
WHERE e.event = 'transaction'
GROUP BY ip.categoryid_str
ORDER BY total_purchases DESC
LIMIT 10;
