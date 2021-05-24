-- Table: user_actions
-- ds (STRING) | user_id (BIGINT) |post_id (BIGINT) |action (STRING) | extra (STRING)
-- '2018-07-01'| 1209283021 | 329482048384792 | 'view' |
-- '2018-07-01'| 1209283021 | 329482048384792 | 'like' |
-- '2018-07-01'| 1938409273 | 349573908750923 | 'reaction' | 'LOVE'
-- '2018-07-01'| 1209283021 | 329482048384792 | 'comment' | 'Such nice Raybans'
-- '2018-07-01'| 1238472931 | 329482048384792 | 'report' | 'SPAM'
-- '2018-07-01'| 1298349287 | 328472938472087 | 'report' | 'NUDITY'
-- '2018-07-01'| 1238712388 | 329482048384792 | 'reshare' | 'I wanted to share with you all'

-- Table: reviewer_removals （真 SPAM ）
-- ds (STRING) | reviewer_id (BIGINT) | post_id (BIGINT) |
-- '2018-07-01'| 3894729384729078 | 329482048384792 |
-- '2018-07-01'| 8477594743909585 | 388573002873499 |
-- ===============================================================================================


-- 1) how many posts were reported yesterday for each report Reason?
select extra, count(distinct post_id)
from user_actions
where ds = curdate()-1 and action = "report"
group by extra


-- 2) What percent of daily content that users view on Facebook is actually Spam?
-- SELECT u.date,
-- COUNT(DISTINCT r.post_id)/COUNT(DISTINCT u.post_id) as spam_percentage
-- FROM user_actions u
-- LEFT JOIN reviewer_removals r
-- ON u.post_id = r.post_id
WHERE u.action = 'view'
GROUP BY u.date;

select t1.date, 
       sum(case when t2.post_id is not null then 1 else 0 end)/count(*) as spam_ratio
from
    (select * from user_actions where content_type = 'view') t1 
left join 
    (select distinct post_id from reviewer_removals) t2 
on t1.post_id = t2.post_id
Group by t1.date


-- 3) How to find the user who abuses this spam system?
-- SELECT A.user_id,
-- SUM(IF(A.action=”report”, 1, 0)) as report_cnt,
-- SUM(IF(B.post_id IS NULL, 0, 1)) as spam_cnt
-- FROM user_actions AS A
-- LEFT JOIN reviewer_removals AS B
-- ON A.post_id=B.post_id

-- High spam report but percentage of spams actually removed by reviewer is low
Select user_id, count(distinct t1.post_id) as spam_reported, 
       sum(case when t2.post_id is not null then 1 else 0 end)/count(*) as real_spam_ratio
from
    (select * from User_actions where action = 'report') t1 
left join 
    (select distinct post_id from reviewer_removals) t2
On t1.post_id = t2.post_id
Group by user_id
Order by spam_reported desc, real_spam_ratio



-- 4. What percent of yesterday's content views were on content reported for spam?
select sum(case when r.post_id is not null then 1 else 0 end) /count(*) as reported_rate
from
(
    select post_id from user_action
    where date = curdate()-1 and content_type = 'view'
) t1
left join 
(
    select post_id from user_action 
    where content_type = 'report type' 
) t2
On t1.post_id = t2.post_id