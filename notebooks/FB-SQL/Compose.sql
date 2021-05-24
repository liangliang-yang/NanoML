-- SQL: FB is launching a 'composer' feature on the phone which helps user to post faster.

-- COMPOSER
-- user_id | date | event("enter", "post", "cancel")

-- User
-- user_id | date | country | dau_flag
-- dau_flag：active user ，0 or 1
-- ===============================================================================================

-- Q1: what success metric you'll define for the feature? Write sql to calculate the success metric.
-- what is the average rate of successful post last week?

SELECT date, 
        SUM(CASE WHEN event = 'post' THEN 1 ELSE 0 END) / 
        SUM(CASE WHEN event = 'enter' THEN 1ELSE 0 END) as avg_success_rate
FROM Composer
WHERE datediff(day, date, current_date()) <= 7
GROUP BY date
;

-- solution 2
SELECT date,
       SUM(IF(event = 'post', 1, 0)) / SUM(IF(event = 'enter', 1, 0)) as rate
FROM composer
WHERE datediff(day, date, current_date) <= 7
GROUP BY date
ORDER BY date
;



-- Q2: what is the average rate of post for daily active users by country on today?

SELECT country, 
       SUM(CASE WHEN event = 'post' THEN 1 else 0 END) /
       COUNT(distinct user_id) as rate
FROM User u
left join Composer c 
ON u.user_id = c.user_id and u.date = c.date
WHERE u.date = current_date()
AND u.dau_flag = 1
GROUP BY country
Order by rate

-- select country,
-- ifnull(num_post/num_user, 0) as avg_post_today
-- from
-- (
-- select country,
-- count(distinct user) as num_user,
-- count(userid) as num_post
-- from user AS A
-- join composer AS B
-- on A.userid = B.userid AND A.date=B.date
-- where A.dau_flag = 1
-- and A.date = curdate()
-- )
-- group by country