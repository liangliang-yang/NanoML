-- Fb sends SMS texts when users 2f to logoin at which time they must confirm they received the sms text. Confirmation texts are only valid on the date they were sent. Unfortunately, there was an ETL problem where friend requests  and invalid confirmation records were inserted into the fb_sms_sends table. fortunately , the fb_confirmers table contains valid confirmation records.
-- Calculate pct of confirmed SMS texts for august 4, 2020
--filter out type=confirmation and type=friend request
--filter for ds=’08-04’2020’
--left join fb confirmers with fb-sms sends on phone number
--count(phone numbers from fb_confirms)/count(phone_numers from fb_sms_sends)
-- ===============================================================================================


Select count(b.phone_number)/count(a.phone_number)*100 as pct 
from fb_sms_sends a
Left join fb_confirmers b
On a.phone_number=b.phone_number and b.date=a.ds
Where type not in ('confirmation', 'friend_request')
And ds=’08-04-2020’