use connection_time;

CALL insert_login (111, 'guild', 222, 'USER', CURRENT_TIMESTAMP);
CALL insert_login (222, 'guild', 333, 'USER', CURRENT_TIMESTAMP);

SELECT * FROM logins;