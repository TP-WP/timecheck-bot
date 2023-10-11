use connection_time;

CALL insert_login (222, 'guild2', 333, 'USERNAME2', 'USERNICK2', "2023-10-04 10:10:10");
CALL insert_time (222,333, "2023-10-04 18:10:10");

CALL insert_login (222, 'guild2', 222, 'USERNAME1', 'USERNICK1', "2023-10-04 10:10:10");
CALL insert_time (222,222, "2023-10-04 18:10:10");

CALL insert_login (222, 'guild2', 444, 'USERNAME3', 'USERNICK3', "2023-10-04 10:10:10");
CALL insert_time (222,444, "2023-10-04 18:10:10");

CALL insert_login (111, 'guild1', 444, 'USERNAME3', 'USERNICK3', "2023-10-04 10:10:10");
CALL insert_time (111, 444, "2023-10-04 18:10:10");


CALL insert_login (111, 'guild1', 222, 'USERNAME1', 'USERNICK1', "2023-10-10 10:10:10");
CALL insert_time (111, 222, "2023-10-10 18:10:10");

CALL insert_login (222, 'guild2', 333, 'USERNAME2', 'USERNICK2', "2023-10-10 10:10:10");
CALL insert_time (222, 333, "2023-10-10 18:10:10");

CALL insert_login (222, 'guild2', 444, 'USERNAME3', 'USERNICK3', "2023-10-10 10:10:10");
CALL insert_time (222,444, "2023-10-10 18:10:10");



