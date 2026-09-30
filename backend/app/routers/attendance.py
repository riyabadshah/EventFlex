from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime

from ..database import get_db
from ..models import Attendance, Event

router = APIRouter(
    prefix="/api/attendance",
    tags=["Attendance"]
)


@router.post("/check-in")
def check_in(
    attendance_data: dict,
    db: Session = Depends(get_db)
):
    event_id = attendance_data.get("event_id")
    professional_id = attendance_data.get("professional_id")

    if not event_id or not professional_id:
        raise HTTPException(
            status_code=400,
            detail="event_id and professional_id are required"
        )

    event = db.query(Event).filter(
        Event.id == event_id
    ).first()

    if not event:
        raise HTTPException(
            status_code=404,
            detail="Event not found"
        )

    existing = db.query(Attendance).filter(
        Attendance.event_id == event_id,
        Attendance.professional_id == professional_id
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Attendance already exists for this professional"
        )

    attendance = Attendance(
        event_id=event_id,
        professional_id=professional_id,
        check_in=datetime.now(),
        status="present"
    )

    db.add(attendance)
    db.commit()
    db.refresh(attendance)

    return {
        "message": "Check-in successful",
        "attendance": {
            "id": attendance.id,
            "event_id": attendance.event_id,
            "professional_id": attendance.professional_id,
            "check_in": attendance.check_in,
            "check_out": attendance.check_out,
            "status": attendance.status
        }
    }
@router.post("/check-out")
def check_out(
    attendance_data: dict,
    db: Session = Depends(get_db)
):
    event_id = attendance_data.get("event_id")
    professional_id = attendance_data.get("professional_id")

    if not event_id or not professional_id:
        raise HTTPException(
            status_code=400,
            detail="event_id and professional_id are required"
        )

    attendance = db.query(Attendance).filter(
        Attendance.event_id == event_id,
        Attendance.professional_id == professional_id
    ).first()

    if not attendance:
        raise HTTPException(
            status_code=404,
            detail="Attendance record not found"
        )

    if not attendance.check_in:
        raise HTTPException(
            status_code=400,
            detail="Professional has not checked in"
        )

    if attendance.check_out:
        raise HTTPException(
            status_code=400,
            detail="Already checked out"
        )

    attendance.check_out = datetime.now()
    attendance.status = "completed"

    db.commit()
    db.refresh(attendance)

    return {
        "message": "Check-out successful",
        "attendance": {
            "id": attendance.id,
            "event_id": attendance.event_id,
            "professional_id": attendance.professional_id,
            "check_in": attendance.check_in,
            "check_out": attendance.check_out,
            "status": attendance.status
        }
    }