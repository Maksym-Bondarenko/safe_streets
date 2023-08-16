import psycopg2

# Database connection parameters
dbname = "safestreets"
user = "chernovandrey"
password = ""
host = "localhost"
port = "5432"  # Default PostgreSQL port

# Establish a connection
# try:
connection = psycopg2.connect(
    dbname=dbname, user=user, password=password, host=host, port=port
)
print("Connected to the database")
cursor = connection.cursor()

# Execute a SELECT query
query = "SELECT * FROM users;"
cursor.execute(query)
# You can perform database operations here
rows = cursor.fetchall()

# Print the fetched rows
for row in rows:
    print(row)
connection.close()

# except psycopg2.Error as e:
#     print("Error while connecting to the database:", e)
# finally:
#     if connection:
#         connection.close()
#         print("Connection closed")