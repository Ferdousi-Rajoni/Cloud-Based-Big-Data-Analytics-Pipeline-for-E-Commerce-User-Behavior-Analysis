CREATE TABLE top_customers20 AS
SELECT
    visitorid,
    COUNT(*) AS num_transactions
FROM cleaned_events
WHERE event = 'transaction'
GROUP BY visitorid
HAVING COUNT(*) > 1
ORDER BY num_transactions DESC
LIMIT 20;
