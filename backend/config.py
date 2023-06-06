from google.cloud.sql.connector import IPTypes
import config_secret
instance_connection_name = config_secret.instance_connection_name
db_user = "postgres"
db_pass = config_secret.db_pass
db_name = "postgres"
ip_type = IPTypes.PUBLIC
