from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime

from ..database import get_db
from ..models import Payment, Application

router = APIRouter(
    prefix="/api/payments",
    tags=["Payments"]
)


@router.post("")
def create_payment(
    payment_data: dict,
    db: Session = Depends(get_db)
):
    event_id = payment_data.get("event_id")
    professional_id = payment_data.get("professional_id")
    application_id = payment_data.get("application_id")
    amount = payment_data.get("amount")

    if not event_id or not professional_id or not application_id or not amount:
        raise HTTPException(
            status_code=400,
            detail="event_id, professional_id, application_id and amount are required"
        )

    application = db.query(Application).filter(
        Application.id == application_id
    ).first()

    if not application:
        raise HTTPException(
            status_code=404,
            detail="Application not found"
        )

    if application.status != "approved":
        raise HTTPException(
            status_code=400,
            detail="Payment can only be created for an approved application"
        )

    existing = db.query(Payment).filter(
        Payment.application_id == application_id
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Payment record already exists for this application"
        )

    payment = Payment(
        event_id=event_id,
        professional_id=professional_id,
        application_id=application_id,
        amount=amount,
        status="pending"
    )

    db.add(payment)
    db.commit()
    db.refresh(payment)

    return {
        "message": "Payment record created successfully",
        "payment": {
            "id": payment.id,
            "event_id": payment.event_id,
            "professional_id": payment.professional_id,
            "application_id": payment.application_id,
            "amount": payment.amount,
            "status": payment.status,
            "payment_date": payment.payment_date,
            "transaction_reference": payment.transaction_reference
        }
    }