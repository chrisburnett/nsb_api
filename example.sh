# get auth token for 'handy andy'
curl https://andy:andy@enigmatic-fjord-63713.herokuapp.com/api/v1/auth

# get assignment list
curl -H "Authorization: Bearer <TOKEN_STRING>" https://enigmatic-fjord-63713.herokuapp.com/api/v1/assignments 

# create a job/assignment in the admin panel and note its ID. Make sure the assignment is assigned to user 'andy'

# accept one of the assignments
curl -X PUT -d status=accepted -H "Authorization: Bearer <TOKEN_STRING>" https://enigmatic-fjord-63713.herokuapp.com/api/v1/assignments/<ASSIGNMENT_ID>

# fulfil it
curl -X PUT -d status=fulfilled -H "Authorization: Bearer <TOKEN_STRING>" https://enigmatic-fjord-63713.herokuapp.com/api/v1/assignments/<ASSIGNMENT_ID>

# note job is now in "review" state in admin panel
