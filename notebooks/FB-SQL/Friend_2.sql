-- friending:
-- ds = date
-- action = {'send_request', 'accept_request', 'unfriend'} （注意这个unfriend选项，回答第二
-- 问时别忘了）
-- actor_uid = uid of person pressing the button to take the action
-- target_uid = uid of the other person involved


/* Q1: How is the overall friending acceptance rate changing over time? */
Select date, ifnull(sum(case when action = 'accept_request' then 1 else 0 end) /
                    sum(case when action = 'send_request' then 1 else 0 end), 0) as acceptance_rate
From friending
Group by date

-- v2. Define how long you have to wait before a friend request is considered rejected (e.g. 1 week).
SELECT round(100*count(DISTINCT total.requestor_id) / 
             count(acc.requestor_is), 2) AS acceptance_rate
FROM 
(
    SELECT distinct actor_uid, target_uid 
    FROM friending where action = 'send_request'
) req 
LEFT JOIN
(
    SELECT distinct actor_uid, target_uid 
    FROM friending where action = 'accept_request'
) acc
ON (req.actor_uid = acc.target_uid AND req. send_to_id = acc.target_uid)
WHERE DATEDIFF(acc.time, req.time) <= 7
AND DATEDIFF(SYSDATE, req.time) < 30


/* Q2: Who has the most number of friends?*/
Select id, (num_friend - isnull(num_defriend,0)) as cnt
(
    Select count(*) as num_friends, id
    from
    (
        Select actor_uid as id
        From friendling
        Where action = 'accept_request'
        Union all
        Select target_uid as id
        From friendling
        Where action = 'accept_request'
    ) as tb1
    Group by id
) as friend_num
Left join
(
    Select count(*) as num_defriends, ids
    (
        Select actor_uid as id
        From friendling
        Where action = 'unfriend'
        Union all
        Select target_uid as id
        From friendling
        Where action = 'unfriend'
    ) as tb2
    Group by id
) as defriend_num
On friend_num.id = defriend_num.id
Order by cnt desc
Limit 1;
