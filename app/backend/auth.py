from db import get_connection
def authenticate_user(username, password, logger):
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:

                query = "SELECT username, role FROM users WHERE username = %s AND password = %s;"
                
                cur.execute(query, (username, password))
                user = cur.fetchone()
                logger.info(user)

      
        if user:
            return {
                "status": "success", 
                "username": user[0], 
                "role": user[1]
            }
        else:
            return {"status": "failed", "message": "Invalid username or password"}

    except Exception as e:
        print(f"Database Error: {e}") 
        return {"status": "error", "message": "Internal server error"}