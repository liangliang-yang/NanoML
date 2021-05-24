-- Q1: Stroy comments distribution
-- #Table name: content_actions
-- user_id
-- content_id  (story)
-- content_type ('post', 'photo', 'comment') #story: post or photo
-- target_id
-- - If content_type=’comment’, then target_id is content_id(post) (我 comment 别人的 story/朋友圈)
-- - If content_type=’post’, then target_id is NULL （我在post story/发朋友圈）
-- ===============================================================================================


-- 1) Generate a distribution for the #comments per story.
SELECT tb.comments, COUNT(*) as freq
FROM
(
    SELECT t1.content_id as story,
    CASE WHEN t2.target_id is not NULL THEN t2.cnts ELSE 0 END AS comments
    FROM table AS t1 -- 所以作品，很多没有 comment
    LEFT JOIN
    (
        SELECT target_id, COUNT(user_id) as cnts
        FROM table
        WHERE content_type='comment'
        GROUP BY target_id
    ) t2 -- 有 comment 的作品
    ON t1.content_id = t2.target_id
    WHERE t1.content_type in ('post', 'photo')
) tb
GROUP BY comments

-- 2) Does this account for stories with 0 comments? YES


-- 3) If now content_type becomes (post, video, photo, article), calculate the comment distribution of each content_type
SELECT tb.comments, tb.type, COUNT(*) as freq
FROM
(
    SELECT t1.content_id, t1.content_type as type,
    CASE WHEN t2.target_id is not NULL THEN t2.cnts ELSE 0 END AS comments
    FROM table AS t1
    LEFT JOIN
    (
        SELECT target_id, COUNT(user_id) as cnts
        FROM table
        WHERE content_type='comment'
        GROUP BY target_id
    ) t2
    ON t1.content_id = t2.target_id
    WHERE t1.content_type in ('post', 'video', 'photo', 'article')
) tb
GROUP BY tb.omments, tb.type

-- 4) 如 果 不 看 date range, data 太 ⼤ 怎 么 办?
-- - 我 说 就 看 今 天 的 ， 他 问 那 今 天 的 有 什 么 问 题。 就 是 没 法 capture cumulative num of
-- comments, 只 有 今 天 的。
-- - only use the data for the region/platform we are interested in
-- - random sampling


-- 5) 你 现 在 有 # of comments for a certain post, 你 怎 么 知 道 这 个 number 是 reasonable 的。
-- 取 些 sample 看 variance, confidence interval