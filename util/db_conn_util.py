import pyodbc
from util.db_property_util import DBPropertyUtil

class DBConnUtil:
    @staticmethod
    def get_connection():
        try:
            conn_str = DBPropertyUtil.get_property_string("../resources/db.properties")
            connection = pyodbc.connect(conn_str)
            return connection
        except pyodbc.Error as e:
            print(f"Database connection error: {e}")
            return None

