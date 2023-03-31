from google.cloud.sql.connector import IPTypes
import os
instance_connection_name = os.environ["INSTANCE_CONNECTION_NAME"]
db_user = os.environ["DB_USER"]
db_pass = os.environ["DB_PASS"]
db_name = os.environ["DB_NAME"]
ip_type = IPTypes.PUBLIC
