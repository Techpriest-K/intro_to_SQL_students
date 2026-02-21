ALTER TABLE server_logs ADD COLUMN Session_Dur REAL;

UPDATE server_logs
SET Session_Dur = (julianday(Session_End) - julianday(Session_Start)) * 24 * 60;

CREATE VIEW v_users_activity AS
SELECT
    u.User_ID,
    u.First_Name,
    u.Last_Name,
    COUNT(sl.Log_ID) AS Num_Sessions,
    COALESCE(SUM(sl.Session_Dur), 0) AS Total_Session_Time
FROM
    users u
LEFT JOIN
    server_logs sl ON u.User_ID = sl.User_ID
GROUP BY
    u.User_ID, u.First_Name, u.Last_Name
ORDER BY
    Total_Session_Time DESC;
