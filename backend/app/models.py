from sqlalchemy import Column, Integer, String, TIMESTAMP, text
from .database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    email = Column(String(150), unique=True, nullable=False, index=True)
    phone = Column(String(20))
    password = Column(String(255), nullable=False)
    role = Column(String(20), nullable=False)
    created_at = Column(
        TIMESTAMP,
        server_default=text("CURRENT_TIMESTAMP")
    )


class Event(Base):
    __tablename__ = "events"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    type = Column(String(100), nullable=False)
    description = Column(String(1000), nullable=False)
    date = Column(String(20), nullable=False)
    time = Column(String(20), nullable=False)
    location = Column(String(300), nullable=False)
    organizer_id = Column(Integer, nullable=False)
    created_at = Column(
        TIMESTAMP,
        server_default=text("CURRENT_TIMESTAMP")
    )


class EventRole(Base):
    __tablename__ = "event_roles"

    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(Integer, nullable=False)
    role_name = Column(String(100), nullable=False)
    description = Column(String(1000), nullable=False)
    people_required = Column(Integer, nullable=False)
    payment = Column(Integer, nullable=False)
    skills = Column(String(500))
    created_at = Column(
        TIMESTAMP,
        server_default=text("CURRENT_TIMESTAMP")
    )


class Application(Base):
    __tablename__ = "applications"

    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(Integer, nullable=False)
    role_id = Column(Integer, nullable=False)
    professional_id = Column(Integer, nullable=False)
    status = Column(String(20), nullable=False, default="pending")
    applied_at = Column(
        TIMESTAMP,
        server_default=text("CURRENT_TIMESTAMP")
    )


class Attendance(Base):
    __tablename__ = "attendance"

    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(Integer, nullable=False)
    professional_id = Column(Integer, nullable=False)
    check_in = Column(TIMESTAMP, nullable=True)
    check_out = Column(TIMESTAMP, nullable=True)
    status = Column(String(20), nullable=False, default="absent")


class Payment(Base):
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(Integer, nullable=False)
    professional_id = Column(Integer, nullable=False)
    application_id = Column(Integer, nullable=False)
    amount = Column(Integer, nullable=False)
    status = Column(String(20), nullable=False, default="pending")
    payment_date = Column(
        TIMESTAMP,
        nullable=True
    )
    transaction_reference = Column(String(100), nullable=True)


class Review(Base):
    __tablename__ = "reviews"

    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(Integer, nullable=False)
    reviewer_id = Column(Integer, nullable=False)
    reviewee_id = Column(Integer, nullable=False)
    rating = Column(Integer, nullable=False)
    comment = Column(String(1000), nullable=True)
    created_at = Column(
        TIMESTAMP,
        server_default=text("CURRENT_TIMESTAMP")
    )