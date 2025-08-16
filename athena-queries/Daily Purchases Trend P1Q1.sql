CREATE TABLE daily_purchases AS
SELECT
    DATE(event_time) AS event_date,
    COUNT(*) AS daily_purchases
FROM cleaned_events
WHERE event = 'transaction'
GROUP BY DATE(event_time)
ORDER BY event_date;
