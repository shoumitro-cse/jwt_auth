# How to use JWT Authentication with Django REST Framework
Django REST Framework is an excellent tool for building APIs in Django. It comes with Authentication Classes that help to build secure APIs without spending a lot of time.

Django REST Framework comes with various default Authentication Classes. BasicAuthentication, SessionAuthentication, and TokenAuthentication to name a few.

Token-based authentication is the most preferred method of implementing authentication in modern APIs. In this mechanism, the server generates a token for the authenticated user and the user has to send the token along with all the HTTP requests to identify themselves.

DRF’s default TokenAuthentication class is a very basic version of this approach. It generates one token for each user and stores it into the database. While it is considered fine to use TokenAuthentication for Server-to-Server communication, it does not play well in modern scenarios with Single Page Applications.

The way TokenAuthentication is designed, it deletes the token every time the user logs out and generates a new one on login. This means making multi-device logins work is usually a pain. To get around this, one way is to choose to not delete the token on logout, but that is not recommended because it is an insecure approach to fix this problem.

Enter JWT.


# JWT Primer

JWT, short for JSON Web Token is an open standard for communicating authorization details between server and client. Unlike TokenAuthentication where the token is randomly generated and the authentication details are stored on the server, JWT is self-contained. This means that a JSON Web Token contains all the information needed for the server to authenticate the client, the server does not have to store anything.

JWT consists of 3 parts, Header, Payload, and Signature. They are encoded into base64 string and are separated by a dot (.).

A header is a JSON object containing meta-information about the token and how it is supposed to be signed.

The payload contains the “claims” for the token. It contains information such as the user id and token expiration time. You can also add custom claims to the token. FOR E.g. A custom `is_admin=true` claim denotes that the user is an admin.

Finally, the signature ensures the integrity of the token. It is cryptographically signed by a secret key (Django SECRET_KEY in this case). The signature can only be generated and verified by using a secret key, thus making it secure against external tampering attacks.

src:

https://www.remoteinning.com/blog/how-to-use-jwt-authentication-with-django-rest-framework

https://django-rest-framework-simplejwt.readthedocs.io/en/latest/getting_started.html



Here, some curl command line interface, it is very helpfull for you to learn jwt or json web token

# First, you try to access. you can't enter because you couldn't bear access token.
[shoumitro@android123 jwt_auth]$  curl -X GET "http://localhost:7000/api/user/"  -H "accept: application/json"  -i

Msg:

HTTP/1.1 401 Unauthorized
Date: Sat, 16 Oct 2021 13:35:45 GMT
Server: WSGIServer/0.2 CPython/3.6.12
Content-Type: application/json
WWW-Authenticate: Bearer realm="api"
Vary: Accept
Allow: GET, HEAD, OPTIONS
X-Frame-Options: DENY
Content-Length: 58
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin
{"detail":"Authentication credentials were not provided."}


# This is a way to get access and refresh token
[shoumitro@android123 jwt_auth]$ curl -X POST "http://localhost:7000/api/token/" -d "{\"username\": \"shoumitro\", \"password\": \"Ab12345678\"}" -H "Content-Type: application/json"  -H "accept: application/json; indent=4"  -i

Msg:

HTTP/1.1 200 OK
Date: Sat, 16 Oct 2021 13:41:18 GMT
Server: WSGIServer/0.2 CPython/3.6.12
Content-Type: application/json
Vary: Accept
Allow: POST, OPTIONS
X-Frame-Options: DENY
Content-Length: 451
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin

{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNDQ3ODA3OCwianRpIjoiODg3MzY0ZWQ0OWNiNGU1OGJiZmYwMGQwOThkNDNjMDIiLCJ1c2VyX2lkIjoxfQ.KFyQGdnxapXa3pBT4YI6v9wwaRbjjy936vEGTSXqipA",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjM0MzkxOTc4LCJqdGkiOiI5YmZlYmY2MDE1ZTU0OTA4ODQ2ZTk0ZGFmYTQyMGUxYiIsInVzZXJfaWQiOjF9.p0rLf0ag0NomHa_VwMd02x_nBxyVB2ffyXTlFsnXSkY"
}

# Here, you can try to access using access token then you can get easy access.
[shoumitro@android123 jwt_auth]$ curl -X  GET "http://localhost:7000/api/user/"  -H "accept: application/json" -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjM0MzkxOTc4LCJqdGkiOiI5YmZlYmY2MDE1ZTU0OTA4ODQ2ZTk0ZGFmYTQyMGUxYiIsInVzZXJfaWQiOjF9.p0rLf0ag0NomHa_VwMd02x_nBxyVB2ffyXTlFsnXSkY"  -i

Msg:

HTTP/1.1 200 OK
Date: Sat, 16 Oct 2021 13:43:17 GMT
Server: WSGIServer/0.2 CPython/3.6.12
Content-Type: application/json
Vary: Accept
Allow: GET, HEAD, OPTIONS
X-Frame-Options: DENY
Content-Length: 31
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin
{"id":1,"username":"shoumitro"}


# After 5 min or wait 10-15 min. you can't access because access token already date expire. generally,
access token expire date 10-15min. here, access token expire customize time 5 min. so you can't access after 5 min.
[shoumitro@android123 jwt_auth]$ curl -X  GET "http://localhost:7000/api/user/"  -H "accept: application/json" -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjM0MzkxOTc4LCJqdGkiOiI5YmZlYmY2MDE1ZTU0OTA4ODQ2ZTk0ZGFmYTQyMGUxYiIsInVzZXJfaWQiOjF9.p0rLf0ag0NomHa_VwMd02x_nBxyVB2ffyXTlFsnXSkY"  -i

Msg:

HTTP/1.1 401 Unauthorized
Date: Sat, 16 Oct 2021 13:49:56 GMT
Server: WSGIServer/0.2 CPython/3.6.12
Content-Type: application/json
WWW-Authenticate: Bearer realm="api"
Vary: Accept
Allow: GET, HEAD, OPTIONS
X-Frame-Options: DENY
Content-Length: 183
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin

{
  "detail":"Given token not valid for any token type","code":"token_not_valid",
  "messages":[
               {
                  "token_class":"AccessToken",
                  "token_type":"access",
                  "message":"Token is invalid or expired"
               }
             ]
}

# Here you can get access token again using refresh token
[shoumitro@android123 jwt_auth]$ curl -X POST "http://localhost:7000/api/token/refresh/" -d "{\"refresh\":  \"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNDQ3ODA3OCwianRpIjoiODg3MzY0ZWQ0OWNiNGU1OGJiZmYwMGQwOThkNDNjMDIiLCJ1c2VyX2lkIjoxfQ.KFyQGdnxapXa3pBT4YI6v9wwaRbjjy936vEGTSXqipA\"}" -H "Content-Type: application/json" -H "accept: application/json"  -i

HTTP/1.1 200 OK
Date: Sat, 16 Oct 2021 13:59:19 GMT
Server: WSGIServer/0.2 CPython/3.6.12
Content-Type: application/json
Vary: Accept
Allow: POST, OPTIONS
X-Frame-Options: DENY
Content-Length: 218
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin
{
  "access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjM0MzkzMDU5LCJqdGkiOiI3MGYyMzRiNDRiN2Q0YTg2OTk2NjlhZDA5ZTAxMzc0ZiIsInVzZXJfaWQiOjF9.mi2QnYEsMnVfqbz8qf470E4KjHnlP6EQNSk6DCJJBiA"
}


# you can again try to access this url then you can get authenticate again.
[shoumitro@android123 jwt_auth]$ curl -X  GET "http://localhost:7000/api/user/"  -H "accept: application/json" -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjM0MzkzMDU5LCJqdGkiOiI3MGYyMzRiNDRiN2Q0YTg2OTk2NjlhZDA5ZTAxMzc0ZiIsInVzZXJfaWQiOjF9.mi2QnYEsMnVfqbz8qf470E4KjHnlP6EQNSk6DCJJBiA"  -i

Msg:

HTTP/1.1 200 OK
Date: Sat, 16 Oct 2021 14:01:39 GMT
Server: WSGIServer/0.2 CPython/3.6.12
Content-Type: application/json
Vary: Accept
Allow: GET, HEAD, OPTIONS
X-Frame-Options: DENY
Content-Length: 31
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin
{
  "id":1,
  "username":"shoumitro"
}
