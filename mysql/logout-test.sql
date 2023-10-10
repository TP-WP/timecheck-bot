use connection_time;

CALL insert_time (111, 222, CURRENT_TIMESTAMP);
CALL insert_time (222, 333, CURRENT_TIMESTAMP);
CALL insert_time (111, 444, CURRENT_TIMESTAMP);

SELECT * FROM daily_logs;