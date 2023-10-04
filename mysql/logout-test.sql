use connection_time;

CALL insert_time (111, 'guild', 222, 'USER', CURRENT_TIMESTAMP);
CALL insert_time (222, 'guild', 333, 'USER', CURRENT_TIMESTAMP);

SELECT * FROM member_list;