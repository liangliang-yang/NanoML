-- https://www.1point3acres.com/bbs/thread-465914-1-1.html

-- Table 1 (T1): Commerce_user_actions, having columns as Date, sessionid (user click on MP tab
-- inco or People search for commerce products), userid, event (surface_enter, click,
-- surface_exit)
-- Date sessionid userid event
-- 2018-01-01 session 1 user 1 surface_enter
-- 2018-01-01 session 1 user 1 click
-- 2018-01-01 session 2 user 1 surface_enter
-- 2018-01-01 session 3 user 2 surface_enter


-- Table 2 (T2): time_spent_sec with sessionid and timespent
-- (Sessions: Date | Session_id | User_id | Action (enter/click/send/exit)
-- Time: Date | Session_id | Time_spent (s) )
-- ===============================================================================================

-- Q1: Calculate the average number of sessions/user per day for the last 30 days
SELECT COUNT(session_id) / COUNT(DISTINCT user_id)) as average
FROM table T1
WHERE DATEDIFF(curdate(), date) <= 30
-- Where datediff(day, date, current_date()) <= 30


-- Q2: Time distribution of each user. What may the distribution look like?
-- SELECT time_spent,
-- COUNT(user_id) as cnt
-- FROM table 1 as A
-- JOIN table 2 as B
-- ON A.session_id=B.session_id
-- GROUP BY 1
-- ORDER BY 1

select total_time, count(distinct userid) as num_users 
from
(
    select round(sum(t.time_spent),2) as total_time, userid from
    Session 
    left join time
    on session.sessionid = time.sessionid
    and session.date = time.date
    group by userid
) temp
group by total_time
order by total_time


-- Q3. # of users who at least spent more than 10s on each session
-- SELECT COUNT(DISTINCT user_id)
-- FROM session
-- JOIN time
-- ON session.sessionid = time.sessionid
-- GROUP BY time.session_id
-- HAVING MIN(time_spent) > 10
-- https://www.1point3acres.com/bbs/thread-465914-1-1.html
select count(distinct userid, mintime) as numbers 
from 
(
    select  s.userid, min(t.time_spent)as mintime
    FROM
    session s
    LEFT JOIN
    time t
    ON s.sessionid=t.sessionid AND s.date=t.date
    group by s.userid
) temp 
where temp.mintime>=10;


-- Q4: Average time spent on session 1 per user within the last 30 days
-- SELECT IFNULL(AVG(time_spent), 0)
-- FROM session
-- LEFT JOIN time
-- ON session.sessinid = time.sessionid
-- WHERE session.sessionid = '1'
-- AND DATEDIFF(curdate(), date) <=30
-- GROUP BY user_id

SELECT IFNULL(SUM(time_spent)/COUNT(distinct userid),0) as avgtimesession1
from session s
left join
time t
on s.date=t.date and s.sessionid=t.sessionid
where datediff(curdate(), s.date)<=30
and  s.sessionid='1'


-- Q6: daily active user for the past 30 days (event with open session/end session/scroll down/first click/send message)
-- (i). first define DAU
-- - session > 5s
-- - scroll down 或 者 first click 才 算 ， 因 为 只 打 开 ⼀ 个 session然 后 time out 或 者 就 quit 的 话 不
-- 应 该 算 ， 然 后 send message表 示 ⾄ 少 有 ⼀ 个 click ， 所 以 send message 的 session 肯 定
-- 都 有 first click ， 所 以 最 后 还 是 选 择 scroll down 和 first click 的
-- (ii). sql
SELECT A.date,
COUNT(DISTINCT A.user_id) as DAU
FROM table1 AS A
JOIN table 2 AS B
ON A.session_id=B.session_id
WHERE B.session_time>=5
AND A.event IN ('scroll down', 'first click')
GROUP BY 1


-- Q: for the past 30 days, number of user who use facebook everyday?
Select count(distinct date) as cnt, user_id
from session
Where datediff(day, date, current_date()) <= 30
group by user_id
Having cnt = 30