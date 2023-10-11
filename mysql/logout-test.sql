use connection_time;

CALL insert_time (111, 222, "2023-10-10 10:10:10");
CALL insert_time (222, 333, "2023-10-10 10:10:10");
CALL insert_time (111, 444, "2023-10-05 10:10:10");
CALL insert_time (222,222, "2023-10-05 10:10:10");
CALL insert_time (222,333, "2023-10-05 10:10:10");
CALL insert_time (222,444, "2023-10-10 10:10:10");


SELECT * FROM daily_logs;