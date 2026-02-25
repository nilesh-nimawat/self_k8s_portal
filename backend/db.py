import psycopg2

def get_connection():
    return psycopg2.connect(
        host="postgres-service",
        database="mydb",
        user="admin",
        password="admin123",
        port=5432
    )