import sqlalchemy
import pg8000
from google.cloud.sql.connector import Connector
import sqlalchemy
import config
from db_strcuts import User, Place, City


class DBConnector(object):
    def __init__(self):
        # initialize Connector object
        self.connector = Connector()

        self.pool = sqlalchemy.create_engine(
            "postgresql+pg8000://",
            creator=self.get_conn,
        )
        self.pool.dialect.description_encoding = None

    def get_conn(self) -> pg8000.dbapi.Connection:
        conn: pg8000.dbapi.Connection = self.connector.connect(
            config.instance_connection_name,
            "pg8000",
            user=config.db_user,
            password=config.db_pass,
            db=config.db_name,
            ip_type=config.ip_type,
        )
        return conn

    def get_all_users(self):
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text("SELECT id, full_name, email, city_id, created_at from users")).fetchall()

    def get_all_places(self, danger_ranking, type, user_id):
        q = "SELECT id, user_id, title, type, danger_ranking, comment, lat, long, created_at from places"
        if (type is not None) and (danger_ranking is not None):
            q += f" where type = '{type}' and danger_ranking='{danger_ranking}' "
        if (type is None) and (danger_ranking is not None):
            q += f" where danger_ranking='{danger_ranking}' "
        if (type is not None) and (danger_ranking is None):
            q += f" where type = '{type}' "

        if (type is None) and (danger_ranking is None) and (user_id is not None):
            q += f" where user_id={user_id} "
        elif user_id is not None:
            q += f" and user_id={user_id} "

        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(q)).fetchall()

    def add_user(self, user: User):
        if user.city_id is None:
            user.city_id = 'NULL'
        query = f"""
        Insert into Users (full_name, email, city_id) values 
                             ('{user.full_name}', '{user.email}', {user.city_id})   
        """
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(query))

    def add_location(self, place: Place):
        query = f"""
        Insert into places (user_id, title, type, danger_ranking, comment, lat, long) values 
                             ({place.user_id}, '{place.title}', '{place.type}', '{place.danger_ranking}',
                             '{place.comment}', '{place.lat}', '{place.long}')   
        """
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(query))

    def delete_user(self, id):
        with self.pool.connect() as db_conn:
            return db_conn.execute(sqlalchemy.text(f"delete from users where id = {id}"))

    def delete_place(self, id):
        with self.pool.connect() as db_conn:
            return db_conn.execute(sqlalchemy.text(f"delete from places where id = {id}"))
