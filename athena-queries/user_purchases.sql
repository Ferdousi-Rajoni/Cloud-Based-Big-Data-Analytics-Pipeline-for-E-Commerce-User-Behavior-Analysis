CREATE TABLE user_purchases AS
SELECT DISTINCT 
    visitorid,
    itemid
FROM cleaned_events
WHERE event = 'transaction';
