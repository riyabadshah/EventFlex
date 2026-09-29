from fastapi import FastAPI

app = FastAPI(
    title="EventFlex API",
    description="Backend API for EventFlex",
    version="1.0.0"
)


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