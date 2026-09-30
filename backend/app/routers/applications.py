from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Application, Event, EventRole

router = APIRouter(
    prefix="/api/applications",
    tags=["Applications"]
)


@router.post("")
def apply_for_event(
    application: dict,
    db: Session = Depends(get_db)
):
    event_id = application.get("event_id")
    role_id = application.get("role_id")
    professional_id = application.get("professional_id")

    if not event_id or not role_id or not professional_id:
        raise HTTPException(
            status_code=400,
            detail="event_id, role_id and professional_id are required"
        )

    event = db.query(Event).filter(Event.id == event_id).first()

    if not event:
        raise HTTPException(
            status_code=404,
            detail="Event not found"
        )

    role = db.query(EventRole).filter(
        EventRole.id == role_id,
        EventRole.event_id == event_id
    ).first()

    if not role:
        raise HTTPException(
            status_code=404,
            detail="Event role not found"
        )

    existing = db.query(Application).filter(
        Application.event_id == event_id,
        Application.role_id == role_id,
        Application.professional_id == professional_id
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Already applied for this role"
        )

    new_application = Application(
        event_id=event_id,
        role_id=role_id,
        professional_id=professional_id,
        status="pending"
    )

    db.add(new_application)
    db.commit()
    db.refresh(new_application)

    return {
        "message": "Application submitted successfully",
        "application": {
            "id": new_application.id,
            "event_id": new_application.event_id,
            "role_id": new_application.role_id,
            "professional_id": new_application.professional_id,
            "status": new_application.status
        }
    }


@router.get("")
def get_applications(
    db: Session = Depends(get_db)
):
    applications = db.query(Application).order_by(
        Application.id.desc()
    ).all()

    return [
        {
            "id": application.id,
            "event_id": application.event_id,
            "role_id": application.role_id,
            "professional_id": application.professional_id,
            "status": application.status
        }
        for application in applications
    ]
@router.put("/{application_id}/status")
def update_application_status(
    application_id: int,
    status_data: dict,
    db: Session = Depends(get_db)
):
    application = db.query(Application).filter(
        Application.id == application_id
    ).first()

    if not application:
        raise HTTPException(
            status_code=404,
            detail="Application not found"
        )

    new_status = status_data.get("status")

    if new_status not in ["approved", "rejected"]:
        raise HTTPException(
            status_code=400,
            detail="Status must be approved or rejected"
        )

    application.status = new_status

    db.commit()
    db.refresh(application)

    return {
        "message": f"Application {new_status} successfully",
        "application": {
            "id": application.id,
            "event_id": application.event_id,
            "role_id": application.role_id,
            "professional_id": application.professional_id,
            "status": application.status
        }
    }
@router.get("/professional/{professional_id}")
def get_professional_applications(
    professional_id: int,
    db: Session = Depends(get_db)
):
    applications = db.query(Application).filter(
        Application.professional_id == professional_id
    ).order_by(
        Application.id.desc()
    ).all()

    return [
        {
            "id": application.id,
            "event_id": application.event_id,
            "role_id": application.role_id,
            "professional_id": application.professional_id,
            "status": application.status,
            "applied_at": application.applied_at
        }
        for application in applications
    ]
    