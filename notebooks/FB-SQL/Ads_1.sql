-- table_A: advertiser info - [advertiser_id, ad_id, spend]: 企业、商家为了打这个广告花的钱
-- table_B: ad info- [ad_id, user_id, price]: 用户点击这个广告， 然后进去花钱  


-- Advertiser spend and ROI metrics
-- ===============================================================================================

-- 1) The fraction of advertiser has at least 1 conversion?
SELECT
SUM(IF(B.ad_id is NULL,0,1))/count(A.ad_id) as rate
FROM adv_info AS A
LEFT JOIN ad_info AS B
ON A.ad_id=B.ad_id


-- 2) What metrics would you show to advertisers (其 实 就 是 在 问 ROI), ⽤ SQL 实 现
SELECT advertisers_id,
sum(IF(B.price is NULL,0, B.price)) / sum(A.spend) as ROI
FROM adv_info AS A
LEFT JOIN ad_info AS B
ON A.ad_id=B.ad_id
GROUP BY advertisers_id

-- 3) 求 过 去 三 ⼗ 天 advertiser 花 了 多 少 钱 在 ad 上 (per advertiser) ， distribution是 什 么 ， why ？ 
-- 然 后 by adid 求 ROI

-- COST:
SELECT tmp.total,
       COUNT(DISTINCT tmp.advertiser_id) as freq
FROM
(
    SELECT advertiser_id,
    SUM(spent) as total
    FROM table1
    WHERE date BETWEEN curdate() AND curdate()-30
    GROUP BY advertiser_id
) tmp
group by tmp.total 

-- ROI:
SELECT A.ad_id,
SUM(IFNULL(B.purchase, 0)) / (SUM(A.spend)) AS ROI
FROM table1 AS A
LEFT JOIN table2 AS B
ON A.ad_id=B.ad_id
GROUP BY 1

-- Follow up question: In which case ROI is not the best metric?
-- when advertiser cares less about revenue but more about CTR (eg. marketing campaign), ROI is not the best metric