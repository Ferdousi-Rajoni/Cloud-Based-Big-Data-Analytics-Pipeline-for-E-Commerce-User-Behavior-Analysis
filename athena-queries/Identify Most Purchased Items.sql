SELECT itemid, COUNT(*) AS purchase_count
FROM cleaned_events
WHERE event = 'transaction'
GROUP BY itemid
ORDER BY purchase_count DESC
LIMIT 20;
