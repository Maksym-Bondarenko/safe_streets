import requests

data = {
    "user_id": 1,
    "lat": 100,
    "long": 100,
    "comment": "This is brothel",
    "rating": 1
}
response = requests.post('http://safestreets-fd4cyuubiq-ey.a.run.app:8080/add/bad_place', json=data)
print(response.json())

#
# data = {
#     "full_name": 'Valera',
#     "email": 'valera666@gmail.com',
#     "comment": "This is brothel",
#     "city_id": 1
# }
# response = requests.post('http://localhost:8080/add/user', json=data)
# print(response.json())
