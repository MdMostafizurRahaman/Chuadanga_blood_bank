# Chuadanga Blood Donation App - Full Stack Project

This zip contains the starter code (boilerplate) based on your System Architecture diagram. 
Since a full production app with Flutter, Next.js, and FastAPI requires proper environment setup, I have created the structure and core files for you.

## Architecture Followed:
- **Backend:** FastAPI (Python) + MongoDB Atlas
- **User App:** Flutter (Dart)
- **Admin Panel:** Next.js (React)

## Step 1: Run the Backend (FastAPI)
1. Install Python on your computer.
2. Open terminal in the `backend` folder.
3. Run: `pip install -r requirements.txt`
4. Run: `uvicorn main:app --reload`
5. Open browser: `http://localhost:8000/docs` to see your API!

## Step 2: Run Admin Panel (Next.js)
1. Install Node.js on your computer.
2. Open terminal in the `admin_panel` folder.
3. Run: `npm install`
4. Run: `npm run dev`
5. Open browser: `http://localhost:3000`

## Step 3: Run User App (Flutter)
1. Install Flutter SDK on your computer.
2. Open terminal in `user_app` folder.
3. Run: `flutter pub get`
4. Run: `flutter run` (Ensure an emulator or phone is connected).
