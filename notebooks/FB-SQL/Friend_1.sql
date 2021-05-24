-- Table 【 Friending 】
-- time = timestamp of the action
-- date = human-readable timestamp, i.e, 2018-01-01
-- action = {'send', 'accept'}

-- actor_id = uid of the person pressing the button to take the action
-- target_id = uid of another person who is involved in the action
-- - Define how long you have to wait before a friend request i s considered
-- rejected (e.g. 1 week) → find the average number
-- - Here a user may send multiple request to a same user at different time
-- ===============================================================================================

-- 1) 某 ⽇ ， 有 多 少 ⼈ 发 好 友 申 请 ， 有 多 少 ⼈ 接 受 好 友 申 请
SELECT
SUM(IF(action='send', 1, 0)) as send,
SUM(IF(action='accpet', 1, 0)) as accept
FROM friending
WHERE ds=’2020-01-04’

-- 2) 每 天 有 多 少 ⼈ 成 功 交 友 （双 向 的） ， 要 group by date

SELECT A.ds,
COUNT(DISTINCT A.action_id) as cnt
FROM
(
SELECT ds, action_id, target_id
FROM friending
WHERE action='send'
) A
JOIN
(
SELECT ds, action_id, target_id
FROM friending
WHERE action='accept'
) B
ON A.target_id=B.action_id AND A.ds=B.ds
GROUP BY 1

-- 3) What was the friend request acceptance rate for requests sent out on 2018-01-01?
-- - 如 果 multiple request 不 需 要 改 动

SELECT
SUM(IF(action="accept",1, 0)) / SUM (IF(action="send",1, 0)) as rate
FROM Friending
WHERE d_date="2018-01-01"

-- - 如 果 multiple request 需 要 被 当 成 ⼀ 次
SELECT SUM(IF(action="accept",1, 0)) / SUM (IF(action="send",1, 0)) as rate
FROM
(
SELECT actor_id, target_id, action
ROW_NUMBER() OVER(PARTITION BY actor_id, target_id, action ORDER BY actor_id) as
index
FROM Friending
WHERE d_date="2018-01-01"
) tb
WHERE tb.index=1

-- 4) Find friend acceptance rate trending
SELECT d_date,
SUM(IF(action="accept",1, 0)) / SUM (IF(action="send",1, 0)) as rate
FROM Friending
GROUP BY 1
ORDER BY 1

-- 5) 如 果 action 中 有 unfriend ， 要 求 计 算 每 个 ⼈ 的 好 友. 如 何 判 断 两 个 ⼈ 是 不 是 好 朋 友
SELECT A.action_id,
COUNT(DISTINCT B.action_id) as friend_cnt
FROM
(
SELECT action_id, target_id
FROM friending
WHERE action='sent'
AND (action_id, target_id) NOT IN
(
SELECT action_id, target_id
FROM friending
WHERE action='unfriend'
)
) A
JOIN
(
SELECT action_id, target_id
FROM friending
WHERE action='accept'
AND (action_id, target_id) NOT IN
(
SELECT action_id, target_id
FROM friending
WHERE action='unfriend'
)
) B ON A.action_id=B.target_id AND A.target_id=B.action_id