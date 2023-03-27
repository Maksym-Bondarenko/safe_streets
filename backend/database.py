import sqlalchemy
import pg8000
from google.cloud.sql.connector import Connector
import sqlalchemy
import config
from db_strcuts import User, Place


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
                sqlalchemy.text("SELECT id, firebase_id, full_name, email,  created_at from users")).fetchall()

    def get_all_places(self, main_type, sub_type, firebase_user_id):
        q = "SELECT id, firebase_user_id, main_type, sub_type, n_likes, n_dislikes, comment, lat, long, created_at from places"
        if (main_type is not None) and (sub_type is not None):
            q += f" where main_type = '{main_type}' and sub_type='{sub_type}' "
        if (main_type is None) and (sub_type is not None):
            q += f" where sub_type='{sub_type}' "
        if (main_type is not None) and (sub_type is None):
            q += f" where main_type = '{main_type}' "

        if (main_type is None) and (sub_type is None) and (firebase_user_id is not None):
            q += f" where firebase_user_id='{firebase_user_id}' "
        elif firebase_user_id is not None:
            q += f" and firebase_user_id='{firebase_user_id}' "

        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(q)).fetchall()

    def add_user(self, user: User):
        query = f"""
        Insert into Users (firebase_id, full_name, email) values 
                             ('{user.firebase_id}', '{user.full_name}', '{user.email}')   
        """
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(query))

    def add_location(self, place: Place):
        query = f"""
        Insert into places (firebase_user_id, main_type, sub_type, comment, lat, long) values 
                             ('{place.firebase_user_id}', '{place.main_type}', '{place.sub_type}',
                             '{place.comment}', '{place.lat}', '{place.long}')   
        """
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(query))

    def update_like(self, id):
        query = f"""
        UPDATE places 
        SET n_likes = n_likes + 1
        WHERE id = {id};
        """
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(query))

    def udpate_dislike(self, id):
        query = f"""
        UPDATE places 
        SET n_dislikes = n_dislikes + 1
        WHERE id = {id};
        """
        with self.pool.connect() as db_conn:
            return db_conn.execute(
                sqlalchemy.text(query))

    def delete_user(self, id):
        with self.pool.connect() as db_conn:
            return db_conn.execute(sqlalchemy.text(f"delete from users where id = {id}"))

    def delete_firebase_user_id(self, id):
        with self.pool.connect() as db_conn:
            return db_conn.execute(sqlalchemy.text(f"delete from users where firebase_id = '{id}'"))

    def delete_place(self, id):
        with self.pool.connect() as db_conn:
            return db_conn.execute(sqlalchemy.text(f"delete from places where id = {id}"))
