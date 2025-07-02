from util.db_conn_util import DBConnUtil

try:
    conn = DBConnUtil.get_connection()
    print("Connection successful")
    conn.close()
except Exception as e:
    print("Connection failed:", e)
