from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Event, EventRole

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
@router.post("/{event_id}/roles")
def create_event_role(
    event_id: int,
    role: dict,
    db: Session = Depends(get_db)
):
    event = db.query(Event).filter(Event.id == event_id).first()

    if not event:
        raise HTTPException(status_code=404, detail="Event not found")

    new_role = EventRole(
        event_id=event_id,
        role_name=role.get("role_name"),
        description=role.get("description"),
        people_required=role.get("people_required"),
        payment=role.get("payment"),
        skills=role.get("skills")
    )

    if not new_role.role_name:
        raise HTTPException(status_code=400, detail="Role name is required")

    db.add(new_role)
    db.commit()
    db.refresh(new_role)

    return {
        "message": "Event role created successfully",
        "role": {
            "id": new_role.id,
            "event_id": new_role.event_id,
            "role_name": new_role.role_name,
            "description": new_role.description,
            "people_required": new_role.people_required,
            "payment": new_role.payment,
            "skills": new_role.skills
        }
    }