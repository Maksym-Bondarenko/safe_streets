import sqlalchemy
import pg8000
from google.cloud.sql.connector import Connector
import sqlalchemy
import config
from db_strcuts import User, Place
import psycopg2


class DBConnector(object):
    def __init__(self, is_google_DB=False):
        # initialize Connector object
        self.is_google_DB = is_google_DB
        if self.is_google_DB:
            self.connector = Connector()

            self.pool = sqlalchemy.create_engine(
                "postgresql+pg8000://",
                creator=self.get_conn_google,
            )
            self.pool.dialect.description_encoding = None
        else:
            self.connector = self.get_conn_local()

    def __del__(self):
        self.connector.close()

    def get_conn_google(self) -> pg8000.dbapi.Connection:
        conn: pg8000.dbapi.Connection = self.connector.connect(
            config.instance_connection_name,
            "pg8000",
            user=config.db_user,
            password=config.db_pass,
            db=config.db_name,
            ip_type=config.ip_type,
        )
        return conn

    def get_conn_local(self):
        dbname = "safestreets"
        user = "admin"
        password = ""
        # host = "localhost"
        host = "host.docker.internal"
        port = "5432"  # Default PostgreSQL port

        # Establish a connection
        # try:
        connection = psycopg2.connect(
            dbname=dbname, user=user, password=password, host=host, port=port
        )
        return connection

    def execute_query(self, query):
        if self.is_google_DB:
            raise "Only for local connection now"
        else:
            try:
                cursor = self.connector.cursor()
                cursor.execute(query)

                # Fetch all the rows
                rows = cursor.fetchall()
                self.connector.commit()
            except Exception as e:
                self.connector.rollback()
                raise psycopg2.DatabaseError(str(e))
        return rows

    def get_all_users(self):
        q = "SELECT id, firebase_user_id, full_name, email from users"
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(q)).fetchall()
        else:
            return self.execute_query(q)

    def get_users(self, firebase_user_id):
        q = f"""
        SELECT id, firebase_user_id, full_name, email,  created_at from users where firebase_user_id = '{firebase_user_id}'
        """
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(q)).fetchall()
        else:
            self.execute_query(q)

    def get_places(self, main_type, sub_type, firebase_user_id):
        q = "SELECT id, firebase_user_id, title, main_type, sub_type, n_likes, n_dislikes, comment, lat, long, created_at from places"
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

        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(q)).fetchall()
        else:
            return self.execute_query(q)

    def add_user(self, user: User):
        query = f"""
        Insert into users (firebase_user_id, full_name, email) values 
                             ('{user.firebase_user_id}', '{user.full_name}', '{user.email}')  returning id 
        """
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(query))
        else:
            return self.execute_query(query)

    def add_location(self, place: Place):
        query = f"""
        Insert into places (firebase_user_id, title, main_type, sub_type, comment, lat, long) values 
                             ('{place.firebase_user_id}', '{place.title}','{place.main_type}', '{place.sub_type}',
                             '{place.comment}', '{place.lat}', '{place.long}') returning id   
        """
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(query))
        else:
            return self.execute_query(query)

    def update_like(self, id):
        q = f"""
        UPDATE places 
        SET n_likes = n_likes + 1
        WHERE id = {id};
        """
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(q))
        else:
            return self.execute_query(q)

    def udpate_dislike(self, id):
        q = f"""
        UPDATE places 
        SET n_dislikes = n_dislikes + 1
        WHERE id = {id};
        """
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(
                    sqlalchemy.text(q))
        else:
            return self.execute_query(q)

    def delete_user(self, firebase_user_id):
        q = f"delete from users where firebase_user_id = {firebase_user_id}"
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(sqlalchemy.text(q))
        else:
            return self.execute_query(q)

    def delete_firebase_user_id(self, id):
        q = f"delete from users where firebase_user_id = '{id}'"
        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(sqlalchemy.text(q))
        else:
            return self.execute_query(q)

    def delete_place(self, id):
        q = f"delete from places where id = {id}"

        if self.is_google_DB:
            with self.pool.connect() as db_conn:
                return db_conn.execute(sqlalchemy.text(q))
        else:
            return self.execute_query(q)
