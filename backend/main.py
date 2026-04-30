# ==================================================
# FASTAPI BACKEND (FLUTTER STREAMING COMPATIBLE)
# Hand Gesture → Text API
# ==================================================

# Install:
# pip install fastapi uvicorn opencv-python mediapipe tensorflow numpy pillow python-multipart

import io
<<<<<<< HEAD
import os
=======
import logging
>>>>>>> ddecf7abe02fdfa69519f4dc7c66110890a173b5
import numpy as np
from PIL import Image

from fastapi import FastAPI, File, UploadFile, Form, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

import mediapipe as mp

from config import landmarker
from utils import process_frame, reset_user, get_features

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ==================================================
<<<<<<< HEAD
# PATH SETUP
# ==================================================
BASE_DIR        = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT    = os.path.dirname(BASE_DIR)

MODEL_PATH      = os.path.join(PROJECT_ROOT, "ml_model", "asl_model_final.h5")
TASK_MODEL_PATH = os.path.join(PROJECT_ROOT, "ml_model", "hand_landmarker.task")


# ==================================================
# LOAD MODEL
# ==================================================
print(f"[INFO] Loading Keras model from: {MODEL_PATH}")
model = load_model(MODEL_PATH)
print("[INFO] Model loaded successfully")


# ==================================================
# LABELS
# ==================================================
GESTURES = ['Alright', 'Good Afternoon', 'Good Morning', 'Hello', 'How are you']


# ==================================================
# SETTINGS
# ==================================================
MAX_FRAMES              = 60
FEATURES                = 120
CONFIDENCE_THRESHOLD    = 0.70
PREDICT_EVERY_N_FRAMES  = 5


# ==================================================
# FASTAPI
# ==================================================
app = FastAPI(title="Gesture API", version="1.0")

# CORS — Flutter se requests allow karne ke liye zaroori hai
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],       # production mein specific IP lagao
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==================================================
# MEDIAPIPE SETUP
# ==================================================
BaseOptions         = python.BaseOptions
HandLandmarker      = vision.HandLandmarker
HandLandmarkerOptions = vision.HandLandmarkerOptions
VisionRunningMode   = vision.RunningMode

options = HandLandmarkerOptions(
    base_options=BaseOptions(model_asset_path=TASK_MODEL_PATH),
    running_mode=VisionRunningMode.IMAGE,
    num_hands=2
)

landmarker = HandLandmarker.create_from_options(options)
print("[INFO] MediaPipe HandLandmarker ready")


# ==================================================
# PER-USER STATE  (in-memory, server restart pe reset)
# ==================================================
user_sequences      = {}   # user_id → list of feature vectors
user_frame_counters = {}   # user_id → int
user_predictions    = {}   # user_id → str  (last stable prediction)


# ==================================================
# FEATURE HELPERS
# ==================================================
def calc_distance(p1, p2):
    return float(np.linalg.norm(np.array(p1) - np.array(p2)))


def calc_angle(a, b, c):
    a, b, c = np.array(a), np.array(b), np.array(c)
    ba = a - b
    bc = c - b
    cosine = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc) + 1e-6)
    cosine = float(np.clip(cosine, -1.0, 1.0))   # NaN guard
    return float(np.arccos(cosine))


# ==================================================
# FEATURE EXTRACTION  (120 features per frame)
# ==================================================
def get_features(result) -> list:
    frame_features = []

    if result.hand_landmarks:
        for hand in result.hand_landmarks[:2]:

            points      = [(lm.x, lm.y) for lm in hand]
            wrist       = points[0]
            norm_points = [(x - wrist[0], y - wrist[1]) for x, y in points]

            # 21 × 2 = 42 raw normalised keypoints
            for p in norm_points:
                frame_features.extend(p)

            # 4 finger-tip distance features
            pairs = [(4, 8), (8, 12), (12, 16), (16, 20)]
            for i, j in pairs:
                frame_features.append(calc_distance(points[i], points[j]))

            # 3 angle features
            triplets = [(0, 5, 8), (0, 9, 12), (0, 13, 16)]
            for a, b, c in triplets:
                frame_features.append(calc_angle(points[a], points[b], points[c]))

            # per-hand = 42 + 4 + 3 = 49 features  →  2 hands = 98 … pad to 120

    # Fixed-size padding / clipping
    if len(frame_features) < FEATURES:
        frame_features.extend([0.0] * (FEATURES - len(frame_features)))
    else:
        frame_features = frame_features[:FEATURES]

    return frame_features


# ==================================================
# INIT / RESET USER SESSION
# ==================================================
def _init_user(user_id: str):
    user_sequences[user_id]      = []
    user_frame_counters[user_id] = 0
    user_predictions[user_id]    = "Detecting..."


# ==================================================
# MAIN STREAMING ENDPOINT
# POST /predict-frame
#   form fields:
#     file    : image (JPEG)
#     user_id : string  (e.g. device UUID)
=======
# FASTAPI APP
# ==================================================
app = FastAPI(title="Hand Gesture API", version="1.0.0")

# ==================================================
# API ENDPOINTS
>>>>>>> ddecf7abe02fdfa69519f4dc7c66110890a173b5
# ==================================================
@app.post("/predict-frame")
async def predict_frame(
    file:    UploadFile = File(...),
    user_id: str        = Form(...)
):
<<<<<<< HEAD
    # ── Init user state on first request ─────────────────────────────────
    if user_id not in user_sequences:
        print(f"[INFO] New user session: {user_id}")
        _init_user(user_id)

    sequence      = user_sequences[user_id]
    frame_counter = user_frame_counters[user_id]

    # ── Decode image ──────────────────────────────────────────────────────
    try:
        contents = await file.read()
        image    = Image.open(io.BytesIO(contents)).convert("RGB")
        frame    = np.array(image)
    except Exception as e:
        print(f"[ERROR] Image decode failed for {user_id}: {e}")
        return JSONResponse(
            status_code=400,
            content={"error": f"Invalid image: {e}",
                     "prediction": user_predictions.get(user_id, "Detecting...")}
        )

    # ── MediaPipe hand landmark detection ────────────────────────────────
    try:
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
        result   = landmarker.detect(mp_image)
    except Exception as e:
        print(f"[ERROR] MediaPipe failed: {e}")
        return JSONResponse(
            status_code=500,
            content={"error": f"Landmark detection failed: {e}",
                     "prediction": user_predictions.get(user_id, "Detecting...")}
        )

    # ── Feature extraction ────────────────────────────────────────────────
    features = get_features(result)
    hand_detected = bool(result.hand_landmarks)

    sequence.append(features)
    if len(sequence) > MAX_FRAMES:
        sequence = sequence[-MAX_FRAMES:]

    frame_counter += 1

    # ── Model prediction (every N frames, once buffer is full) ────────────
    prediction_made = False
    if len(sequence) == MAX_FRAMES and frame_counter % PREDICT_EVERY_N_FRAMES == 0:
        try:
            input_data = np.expand_dims(np.array(sequence, dtype=np.float32), axis=0)
            pred       = model.predict(input_data, verbose=0)[0]
            class_id   = int(np.argmax(pred))
            conf       = float(pred[class_id])

            if conf >= CONFIDENCE_THRESHOLD:
                gesture_name                  = GESTURES[class_id]
                user_predictions[user_id]     = gesture_name
                prediction_made               = True
                print(f"[PRED] user={user_id} → {gesture_name} ({conf:.2%})")
            else:
                user_predictions[user_id] = "Detecting..."
        except Exception as e:
            print(f"[ERROR] Model prediction failed: {e}")

    # ── Save updated state ────────────────────────────────────────────────
    user_sequences[user_id]      = sequence
    user_frame_counters[user_id] = frame_counter

    # ── Response ──────────────────────────────────────────────────────────
    return JSONResponse({
        "prediction":   user_predictions[user_id],
        "hand_visible": hand_detected,
        "frame_count":  frame_counter,
        "buffer_ready": len(sequence) == MAX_FRAMES,
    })


# ==================================================
# SESSION RESET  (call when user stops streaming)
# POST /reset-session
#   form field: user_id
# ==================================================
@app.post("/reset-session")
async def reset_session(user_id: str = Form(...)):
    if user_id in user_sequences:
        _init_user(user_id)
        print(f"[INFO] Session reset: {user_id}")
        return JSONResponse({"status": "reset", "user_id": user_id})
    return JSONResponse({"status": "not_found", "user_id": user_id})


# ==================================================
# HEALTH CHECK
# ==================================================
@app.get("/")
def home():
    return {
        "status":  "ok",
        "message": "Gesture API Running 🚀",
        "gestures": GESTURES,
    }
=======
    """Predict gesture from uploaded frame image."""
    try:
        # Validate input
        if not file.content_type.startswith("image/"):
            raise HTTPException(status_code=400, detail="Invalid file type. Use PNG or JPG.")

        # Read and process image
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert("RGB")
        frame = np.array(image)

        # MediaPipe detection
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
        result = landmarker.detect(mp_image)
        features = get_features(result)

        # Process and get prediction
        prediction = process_frame(user_id, features)

        logger.info(f"user={user_id}, prediction={prediction}")

        return JSONResponse({"prediction": prediction})

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in predict_frame: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.post("/reset-user")
async def reset_user_endpoint(user_id: str = Form(...)):
    """Reset user sequence and prediction state."""
    reset_user(user_id)
    return JSONResponse({"message": f"User {user_id} reset"})

@app.get("/")
def home():
    """Health check endpoint."""
    return {"message": "Gesture API Running 🚀"}
>>>>>>> ddecf7abe02fdfa69519f4dc7c66110890a173b5

# ==================================================
<<<<<<< HEAD
# RUN
# uvicorn main:app --host 0.0.0.0 --port 5000 --reload
# ==================================================
=======
# RUN SERVER
# ==================================================
# uvicorn main:app --reload --host 0.0.0.0 --port 8000
>>>>>>> ddecf7abe02fdfa69519f4dc7c66110890a173b5
