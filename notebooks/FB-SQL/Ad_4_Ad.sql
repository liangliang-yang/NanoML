-- unit 就 是 ⼀ 个 他 未 来 会 买 到 的 ⼴ 告 的 template ， ⼀ 个 user 可 以 看 同 ⼀ 个 unit 很 多 次 ， 也
-- 可 以 看 到 不 同 的 unit ， 如 果 user create an ad 了 的 话 就 不 会 再 看 到 了。 两 个 表:

-- table 1: ad4ad: date, user_id, event(impression, click, create_ad), unit_id, cost, spend, ad_id
-- - ad_id: event 是 create_ad 对 应 的 ⾏ 才 有 数 值
-- - event 有 三 个 值 ， 其 中 impression 就 是 FB 为 user 创 造 的 ⼴ 告 space ， click 代 表 user 点 进 去 了 ， create_ad 代 表 user 点 进 去 之 后 正 式 create 了 ad
-- - cost 就 是 FB 为 这 个 user 的 这 个 item 创 造 ⼴ 告 space 所 花 费 的 cost
-- - spend 就 是 在 user create_ad 之 后 pay 给 FB 的 ， 只 有 create_ad 那 ⼀ ⾏ 的 spend 不 是 null

-- table 2: users: user_id, country, age
-- ===============================================================================================

-- 1) last 30 days, by country, total spend (问 的 是 facebook 的 spend 就 是 表 ⾥ 的 cost

SELECT A.country, SUM((IFNULL(B.cost,0)) AS num_users
FROM users AS A
LEFT JOIN ad4ad AS B -- 用 left join 没有的 country也在结果里 
ON A.user_id = B.user_id
WHERE DATEDIFF(A.date, CURDATE()) <= 30
GROUP BY A.country

-- 2) how many impressions before users create an ad, given an unit? （商家看到多少广告位）

SELECT AVG(tmp.num_impression) AS avg_imp
FROM
(
SELECT a.user_id, a.unit_id,
       SUM(IF(a.event = 'impression', 1, 0) num_impression
FROM ad4ad AS a
JOIN ad4ad AS b
ON a.user_id = b.user_id AND a.unit_id=B.unit_id
WHERE a.date < b.date  -- CARTESIAN JOIN or CROSS JOIN
AND a.event = 'impression'
AND b.event = 'create_ad'
GROUP BY a.user_id, a.unit_id
) tmp


-- Product:
-- 1) metrics to measure the health
-- 2) Which one is the most important to show to CEO? Prodit
-- 3) If one metric goes down, what is the reason?
-- 4) 从 Facebook ⻆ 度 来 说 推 出 这 个 feature 有 什 么 好 坏？

-- ===============================================================================================
-- ===============================================================================================

-- Ad4ad， 就是ad for ad，简单来说就是fb要在潜在的广告用户的news feed里放一个pre-viewed
-- ad， 潜在的广告用户看到了之后，可以点击，点击进去就是一个具体的投放广告的页面，然后就
-- 会给用户create ad的选项。所以这个pre-viewed ad就是table 里面的unit id，每个用户可以看到多
-- 个unit， 每个unit可以看见多次，但是理论上用户通过一个unit，create 了ad就不会看见这个unit
-- 了。fb给用户展示这个previewed ad 是要花钱的，也就是table里面的cost，spend是用户真的创
-- 建了广告花的钱。
-- SQL：
-- Ad4ad
-- Date event user_id unit_id ad_id cost spend
-- 2018-08-01 impression 123 1111 null 0.12 null
-- 2018-08-01 impression 123 1111 null 0.15 null
-- 2018-08-01 impression 123 1111 null 0.12 null
-- 2018-08-01 impression 456 2222 null 0.14 null
-- 2018-08-01 click 456 2222 null null null
-- 2018-08-01 create_ad 456 2222 9988 null 10
-- ...

-- User
-- User_id country age
-- 123 German 38
-- 456 China 20
-- 789 US 28
-- ===============================================================================================

-- 1. last 30 days, by country, total spend (问的是facebook的spend就是表里的cost）of the product

Select sum(cost), country
From ad4ad l 
join user r
On l.user_id = r.user_id
Where datediff(day, current_date(), date) <= 30
Group by country

-- 2. how many impressions before users create an ad given a unit?
-- 就是在问，当用户被展示了一个unit后，需要多少个impression用户才会去创建广告，换句话说，
-- 对这些创建了广告的用户来说，他们在创建广告之前有多少impression。所以，这里你要去和
-- interviewer clarify(这里不一定的，因为我觉得需要问清楚，所以我问了一下哈)，output是三个
-- column, user id, unit id, count of impressions before they create at 还是 avg(count of
-- impression), 然后应该是让你output出来一个数，然后问你avg哪里不好。Whether we can launch
-- this feature?

Select percentile(cnt, 0.5) as median_impressions -- 需要 median 吗？ 感觉 AVG 就可以了
from
(
    Select user_id, unit_id, 
           sum(case when l.event = 'impression' then 1 else 0 end) as num_impressions
    From Ad4ad l 
    join 
    (
        SELECT DISTINCT user_id, unit_id 
        FROM ad4ad 
        WHERE event = 'created_ad'
    ) r
    On l.user_id and r.user_id and l.unit_id = r.unit_id
    Group by user_id, unit_id
) tmp


-- 3. 有个ads_rolling table，是每个ads的lifetime_spend 和lifetime_revenue。问怎么把每 天新
-- 的信息加进去update这个table. 要注意的是每天可能有新的ads id加⼊入， 不不能直接left join
-- Coalesce
-- 没看懂 ？？

-- Select * 
-- from
-- Ads_rolling table
-- Union
-- Select current_date() as date, coalesce(l.ad_id, r.ad_id) as ad_id, coalesce(l.lifetime_spend,
-- r.today_spend) as lifetime_spend, coalesce(l.lifetime_revenue, r.today_revenue) as
-- lifetime_revenue
-- (select From ads_roling table where date = current_date() - 1) l
-- Full outer join
-- (select ad_id, sum(cost) as today_spend, sum(spend) as today_revenue from ad4ad where
-- date = current_date()
-- Group by ad_id) r
-- On l.ad_id = r.ad_id