from pymongo import MongoClient

MONGO_URI = "mongodb+srv://bsse1320_db_user:ebzFDHCuPQeHvagY@cluster0.vgc9qm1.mongodb.net/"
client = MongoClient(MONGO_URI)
db = client['blood_bank_db']

admins_collection = db['admins']
donors_collection = db['donors']
requests_collection = db['requests']
