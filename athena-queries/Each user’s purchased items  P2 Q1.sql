WITH user_purchases AS (
    SELECT 
        visitorid,
        itemid
    FROM cleaned_events
    WHERE event = 'transaction'
)
SELECT * FROM user_purchases
LIMIT 10;
