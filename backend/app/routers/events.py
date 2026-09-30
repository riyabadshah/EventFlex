from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Event

router = APIRouter(
    prefix="/api/events",
    tags=["Events"]
)


@router.post("")
def create_event(
    event: dict,
    db: Session = Depends(get_db)
):
    new_event = Event(
        name=event.get("name"),
        type=event.get("type"),
        description=event.get("description"),
        date=event.get("date"),
        time=event.get("time"),
        location=event.get("location"),
        organizer_id=event.get("organizer_id")
    )

    if not new_event.name:
        raise HTTPException(status_code=400, detail="Event name is required")

    db.add(new_event)
    db.commit()
    db.refresh(new_event)

    return {
        "message": "Event created successfully",
        "event": {
            "id": new_event.id,
            "name": new_event.name,
            "type": new_event.type,
            "description": new_event.description,
            "date": new_event.date,
            "time": new_event.time,
            "location": new_event.location,
            "organizer_id": new_event.organizer_id
        }
    }


@router.get("")
def get_events(db: Session = Depends(get_db)):
    events = db.query(Event).order_by(Event.id.desc()).all()

    return [
        {
            "id": event.id,
            "name": event.name,
            "type": event.type,
            "description": event.description,
            "date": event.date,
            "time": event.time,
            "location": event.location,
            "organizer_id": event.organizer_id
        }
        for event in events
    ]
