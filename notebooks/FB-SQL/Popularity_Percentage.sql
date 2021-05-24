-- https://www.1point3acres.com/bbs/forum.php?mod=viewthread&tid=759473&ctid=232564

-- Find the popularity percentage for each user on FB. 
-- the popularity percentage is defined as the total number of friends the user  has divide by the total number of users on the platform
--total number of friends the user has/total number of users on the platform
--total number of users on the platform: union user 1 and user 2
--total number of friends the user has: union user1 and user2, user2 and user1

-- 好像是 table facebook_friends 有 user1 -> user2
-- 没看懂
-- ===============================================================================================


Select user1, count(*)/max(tuu.all_users) *100  
from 
(
    Select count(*) as all_users 
    from 
    (
        Select distinct user1 from facebook_friends
        Union
        Select distinct user2 from facebook_friends
    ) total_unique_users
)tuu
Join 
(
    Select user1,user2 from facebook_friends
    Union
    Select user2 as user1, user1 as user2 from facebook_friends
) b
On 1=1
Group by user1
Order by user1 asc