from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import bcrypt
from database import admins_collection, donors_collection, requests_collection

app = FastAPI(title="Chuadanga Blood Bank API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

UPAZILAS = ["Chuadanga Sadar", "Alamdanga", "Damurhuda", "Jibannagar"]
BLOOD_GROUPS = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

# --- Models ---
class AdminLogin(BaseModel):
    username: str
    password: str

class DonorRegister(BaseModel):
    name: str
    phone: str
    blood_group: str
    upazila: str
    address: str
    photo_url: Optional[str] = ""

class DonorLogin(BaseModel):
    phone: str

class BloodRequest(BaseModel):
    requester_phone: str
    blood_group: str
    upazila: str
    patient_name: str
    hospital: str
    contact_phone: str

class DonorResponse(BaseModel):
    id: str
    name: str
    phone: str
    blood_group: str
    upazila: str
    address: str
    photo_url: Optional[str] = ""
    is_registered: bool
    created_at: str

# --- Helpers ---
def donor_to_response(d):
    return DonorResponse(
        id=str(d["_id"]),
        name=d["name"],
        phone=d["phone"],
        blood_group=d["blood_group"],
        upazila=d["upazila"],
        address=d["address"],
        photo_url=d.get("photo_url", ""),
        is_registered=d.get("is_registered", False),
        created_at=d.get("created_at", "")
    )

# --- Admin Routes ---
@app.post("/admin/login")
def admin_login(data: AdminLogin):
    admin = admins_collection.find_one({"username": data.username})
    if not admin or not bcrypt.checkpw(data.password.encode(), admin["password"]):
        raise HTTPException(401, "Invalid credentials")
    return {"token": "admin_token", "name": admin["name"]}

@app.post("/admin/register-donor")
def register_donor(data: DonorRegister):
    if data.blood_group not in BLOOD_GROUPS:
        raise HTTPException(400, "Invalid blood group")
    if data.upazila not in UPAZILAS:
        raise HTTPException(400, "Invalid upazila")
    existing = donors_collection.find_one({"phone": data.phone})
    if existing:
        raise HTTPException(400, "Donor with this phone already exists")
    donor = {
        "name": data.name,
        "phone": data.phone,
        "blood_group": data.blood_group,
        "upazila": data.upazila,
        "address": data.address,
        "photo_url": data.photo_url,
        "is_registered": True,
        "status": "active",
        "created_at": datetime.utcnow().isoformat()
    }
    donors_collection.insert_one(donor)
    return {"message": "Donor registered successfully", "phone": data.phone}

@app.get("/admin/donors", response_model=List[DonorResponse])
def admin_get_all_donors():
    donors = donors_collection.find().sort("created_at", -1)
    return [donor_to_response(d) for d in donors]

@app.get("/admin/donors/{phone}")
def admin_get_donor(phone: str):
    donor = donors_collection.find_one({"phone": phone})
    if not donor:
        raise HTTPException(404, "Donor not found")
    return donor_to_response(donor)

@app.delete("/admin/donors/{phone}")
def admin_delete_donor(phone: str):
    result = donors_collection.delete_one({"phone": phone})
    if result.deleted_count == 0:
        raise HTTPException(404, "Donor not found")
    return {"message": "Donor deleted"}

# --- Auth Routes (User) ---
@app.post("/auth/login")
def donor_login(data: DonorLogin):
    donor = donors_collection.find_one({"phone": data.phone})
    if not donor:
        raise HTTPException(404, "No account found with this phone number. Please contact admin to register.")
    return {
        "token": f"user_{data.phone}",
        "donor": donor_to_response(donor)
    }

# --- Donor Routes ---
@app.get("/donors", response_model=List[DonorResponse])
def search_donors(blood_group: Optional[str] = None, upazila: Optional[str] = None):
    query = {"is_registered": True, "status": "active"}
    if blood_group and blood_group in BLOOD_GROUPS:
        query["blood_group"] = blood_group
    if upazila and upazila in UPAZILAS:
        query["upazila"] = upazila
    donors = donors_collection.find(query).sort("name", 1)
    return [donor_to_response(d) for d in donors]

@app.get("/donors/{phone}", response_model=DonorResponse)
def get_donor(phone: str):
    donor = donors_collection.find_one({"phone": phone, "is_registered": True})
    if not donor:
        raise HTTPException(404, "Donor not found")
    return donor_to_response(donor)

# --- Blood Request Routes ---
@app.post("/requests")
def create_request(data: BloodRequest):
    req = {
        "requester_phone": data.requester_phone,
        "blood_group": data.blood_group,
        "upazila": data.upazila,
        "patient_name": data.patient_name,
        "hospital": data.hospital,
        "contact_phone": data.contact_phone,
        "status": "pending",
        "created_at": datetime.utcnow().isoformat()
    }
    requests_collection.insert_one(req)
    return {"message": "Request submitted successfully"}

@app.get("/requests/{phone}")
def get_requests(phone: str):
    reqs = requests_collection.find({"requester_phone": phone}).sort("created_at", -1)
    result = []
    for r in reqs:
        result.append({
            "id": str(r["_id"]),
            "blood_group": r["blood_group"],
            "upazila": r["upazila"],
            "patient_name": r["patient_name"],
            "hospital": r["hospital"],
            "status": r["status"],
            "created_at": r["created_at"]
        })
    return result

# --- Info Routes ---
@app.get("/upazilas")
def get_upazilas():
    return {"upazilas": UPAZILAS}

@app.get("/blood-groups")
def get_blood_groups():
    return {"blood_groups": BLOOD_GROUPS}

@app.get("/")
def read_root():
    return {"message": "Welcome to Chuadanga Blood Bank API"}
