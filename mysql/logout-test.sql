use connection_time;

CALL insert_time (111, 'guild', 222, 'USER', CURRENT_TIMESTAMP);
CALL insert_time (222, 'guild2', 333, 'USER2', CURRENT_TIMESTAMP);

SELECT * FROM member_list;