import bcrypt
from database import admins_collection

# Create default admin if not exists
admin = admins_collection.find_one({"username": "admin"})
if not admin:
    admins_collection.insert_one({
        "username": "admin",
        "password": bcrypt.hashpw("admin123".encode(), bcrypt.gensalt()),
        "name": "Super Admin"
    })
    print("Default admin created: username=admin, password=admin123")
else:
    print("Admin already exists")
