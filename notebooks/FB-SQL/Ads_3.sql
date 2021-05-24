-- Ads click table
-- ad_id, user_id, status: {'click', 'view', 'hide'} .
-- ===============================================================================================

-- 1):用什么metrics去衡量Ads peformance？ 写SQL 找出performnce 最好的AD
-- CTR

SELECT ad_id, SUM(CASE WHEN status='click' THEN 1 ELSE 0 END)/SUM(CASE WHEN status='view' THEN 1 ELSE 0 END) as CTR
FROM ads
Group by ad_id
Order by CTR desc
Limit 1;

-- 2)：如果人click其中一个ad，写SQL推荐下一个show给这个user的ad

Select ad_id from
(SELECT ad_id, SUM(CASE WHEN status = 'click')/SUM(CASE WHEN status = 'view') as CTR
FROM ads
Group by ad_id
Order by CTR desc) where ad_id not in (select ad_id from ads where user_id = 'user_1' and
status = 'click')
Limit 1;

-- 3) 显示user CTR的distribution
Select ctr, count(distinct user_id) as freq from
(Select user_id, round(ifnull(sum(case when status = 'click')/sum(case when status = 'view'),0,2)
as ctr
From ads
Group by user_id) as tb
Group by ctr
Order by ctr


-- 4) 还有什么别的metrics that we should derive and monitor from this table.
-- %hide percentage by ad and by user