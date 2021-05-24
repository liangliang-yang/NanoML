-- you have one table named content_action which has 5 fields:

-- Date,
-- User_id (content_creator_id)
-- Content_id (this is the primary key),
-- Content_type (with 4 types: status_update, photo, video, comment),
-- Target_id (it’s the original content_id associated with the comment, if the content type is not
-- comment, this will be null)
-- ===============================================================================================

-- Question:
-- 1.find the distribution of stories（photo+video） based on comment count?
-- Q: count for 0 comments

Select num_comments, count(distinct content_id) as freq 
from
(
    Select l.content_id, count(distinct r.content_id) as num_comments
    from
    (
        Select *
        From Content_action
        Where content_type in ('photo', 'video')
    ) l
    left join
    (
        Select *
        From Content_action
        Where content_type = 'comment'
    ) r
    On l.content_id = r.target_id
    Group by l.content_id
) tmp
Group by num_comments
Order by num_comments

-- 2.Now what if content_type becomes {comment, post, video, photo, article}，what is the 
-- comment distribution for each content type ?

Select content_type, num_comments, count(distinct content_id) as freq 
from
(
    Select l.content_id, l.content_type, count(distinct r.content_id) as num_comments
    from
    (
        Select *
        From Content_action
        Where content_type != 'comment'
    ) l 
    left join
    (
        Select *
        From Content_action
        Where content_type = 'comment'
    ) r
    on l.content_id = r.target_id
    Group by l.content_id, l.content_type
) cnts
Group by content_type, num_comments
Order by content_type, num_comments