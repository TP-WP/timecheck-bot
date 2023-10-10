use connection_time;

CALL insert_login (111, 'guild', 222, 'USERNAME1', 'USERNICK1', CURRENT_TIMESTAMP);
CALL insert_login (111, 'guild', 444, 'USERNAME3', 'USERNICK3', CURRENT_TIMESTAMP);
CALL insert_login (222, 'guild', 333, 'USERNAME2', 'USERNICK2', CURRENT_TIMESTAMP);

SELECT * FROM logins;
SELECT * FROM member_list;