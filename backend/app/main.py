from fastapi import FastAPI, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware

from .database import get_db
from .routers import auth

app = FastAPI(
    title="EventFlex API",
    description="Backend API for EventFlex",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(auth.router) 


@app.get("/")
def root():
    return {
        "message": "EventFlex API is running"
    }


@app.get("/api/health")
def health():
    return {
        "status": "ok",
        "service": "EventFlex Backend"
    }


@app.get("/api/db-test")
def db_test(db: Session = Depends(get_db)):
    result = db.execute(text("SELECT 1")).scalar()

    return {
        "database": "connected",
        "result": result
    }