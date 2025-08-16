CREATE TABLE user_segments AS
SELECT
    visitorid,
    total_events,
    total_views,
    total_add_to_cart,
    total_transactions,
    unique_items_purchased,
    unique_items_interacted,
    unique_categories_viewed,
    unique_categories_purchased,
    active_days,
    view_to_purchase_ratio,
    CASE
        WHEN total_transactions >= 5 AND view_to_purchase_ratio >= 0.5 THEN 'High Value Buyer'
        WHEN total_views >= 10 AND total_transactions = 0 THEN 'Window Shopper'
        WHEN unique_categories_purchased = 1 AND total_transactions >= 2 THEN 'Category Specialist'
        WHEN active_days >= 30 AND total_transactions >= 1 THEN 'Loyal Customer'
        ELSE 'Occasional Buyer'
    END AS segment_label
FROM user_profile_summary;
