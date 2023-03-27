import datetime
from dataclasses import dataclass
from dataclasses import asdict as dc_asdict
from typing import Optional


def asdict(obj):
    d = dc_asdict(obj)
    dt_field = 'create_at'
    if dt_field in d.keys():
        d[dt_field] = str(d[dt_field])
    return d


@dataclass
class User:
    id: int
    firebase_id: str
    full_name: str
    email: str
    created_at: datetime.datetime


@dataclass
class Place:
    id: int
    firebase_user_id: str
    main_type: str
    sub_type: str
    n_likes: int
    n_dislikes: int
    comment: str
    lat: float
    long: float
    created_at: datetime.datetime

