import urllib.request, json

donors = [
    {'name':'Rahim','phone':'01711111111','blood_group':'B+','upazila':'Alamdanga','address':'Alamdanga, Chuadanga'},
    {'name':'Karim','phone':'01722222222','blood_group':'A+','upazila':'Chuadanga Sadar','address':'Sadar, Chuadanga'},
    {'name':'Fatima','phone':'01733333333','blood_group':'O-','upazila':'Damurhuda','address':'Damurhuda'},
    {'name':'Hasan','phone':'01744444444','blood_group':'AB+','upazila':'Jibannagar','address':'Jibannagar'},
]
for d in donors:
    data = json.dumps(d).encode()
    req = urllib.request.Request('http://localhost:8000/admin/register-donor', data=data, headers={'Content-Type':'application/json'})
    try:
        res = urllib.request.urlopen(req)
        print(f"OK: {d['name']} - {res.read().decode()}")
    except urllib.error.HTTPError as e:
        print(f"Error for {d['name']}: {e.read().decode()}")
