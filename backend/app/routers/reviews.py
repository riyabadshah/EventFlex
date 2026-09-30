from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Review, Event

router = APIRouter(
    prefix="/api/reviews",
    tags=["Reviews"]
)


@router.post("")
def create_review(
    review_data: dict,
    db: Session = Depends(get_db)
):
    event_id = review_data.get("event_id")
    reviewer_id = review_data.get("reviewer_id")
    reviewee_id = review_data.get("reviewee_id")
    rating = review_data.get("rating")
    comment = review_data.get("comment")

    if not event_id or not reviewer_id or not reviewee_id or rating is None:
        raise HTTPException(
            status_code=400,
            detail="event_id, reviewer_id, reviewee_id and rating are required"
        )

    if rating < 1 or rating > 5:
        raise HTTPException(
            status_code=400,
            detail="Rating must be between 1 and 5"
        )

    event = db.query(Event).filter(
        Event.id == event_id
    ).first()

    if not event:
        raise HTTPException(
            status_code=404,
            detail="Event not found"
        )

    existing = db.query(Review).filter(
        Review.event_id == event_id,
        Review.reviewer_id == reviewer_id,
        Review.reviewee_id == reviewee_id
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Review already submitted"
        )

    review = Review(
        event_id=event_id,
        reviewer_id=reviewer_id,
        reviewee_id=reviewee_id,
        rating=rating,
        comment=comment
    )

    db.add(review)
    db.commit()
    db.refresh(review)

    return {
        "message": "Review submitted successfully",
        "review": {
            "id": review.id,
            "event_id": review.event_id,
            "reviewer_id": review.reviewer_id,
            "reviewee_id": review.reviewee_id,
            "rating": review.rating,
            "comment": review.comment,
            "created_at": review.created_at
        }
    }
@router.get("/user/{user_id}")
def get_user_reviews(
    user_id: int,
    db: Session = Depends(get_db)
):
    reviews = db.query(Review).filter(
        Review.reviewee_id == user_id
    ).order_by(
        Review.id.desc()
    ).all()

    return [
        {
            "id": review.id,
            "event_id": review.event_id,
            "reviewer_id": review.reviewer_id,
            "reviewee_id": review.reviewee_id,
            "rating": review.rating,
            "comment": review.comment,
            "created_at": review.created_at
        }
        for review in reviews
    ]
@router.get("/event/{event_id}")
def get_event_reviews(
    event_id: int,
    db: Session = Depends(get_db)
):
    reviews = db.query(Review).filter(
        Review.event_id == event_id
    ).order_by(
        Review.id.desc()
    ).all()

    return [
        {
            "id": review.id,
            "event_id": review.event_id,
            "reviewer_id": review.reviewer_id,
            "reviewee_id": review.reviewee_id,
            "rating": review.rating,
            "comment": review.comment,
            "created_at": review.created_at
        }
        for review in reviews
    ]