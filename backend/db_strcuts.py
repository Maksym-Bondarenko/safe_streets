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
    full_name: str
    email: str
    created_at: datetime.datetime
    city_id: Optional[int] = None


@dataclass
class City:
    id: int
    name: str
    country_name: str


@dataclass
class Place:
    id: int
    user_id: int
    title: str
    type: str
    danger_ranking: str
    comment: str
    lat: float
    long: float
    created_at: datetime.datetime
