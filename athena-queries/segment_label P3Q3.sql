SELECT segment_label, COUNT(*) AS user_count
FROM user_segments
GROUP BY segment_label;
