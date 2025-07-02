import configparser
import os

class DBPropertyUtil:
    @staticmethod
    def get_property_string(filename: str) -> str:
        config = configparser.ConfigParser()
        if not os.path.exists(filename):
            raise FileNotFoundError(f"Property file not found: {filename}")
        config.read(filename)

        section = config['database']
        driver = section['driver']
        server = section['server']
        database = section['database']
        trusted_connection = section.get('trusted_connection', 'no')

        if trusted_connection.lower() == 'yes':
            conn_str = (
                f"DRIVER={{{driver}}};"
                f"SERVER={server};"
                f"DATABASE={database};"
                f"Trusted_Connection=yes;"
            )
        else:
            username = section['username']
            password = section['password']
            conn_str = (
                f"DRIVER={{{driver}}};"
                f"SERVER={server};"
                f"DATABASE={database};"
                f"UID={username};"
                f"PWD={password}"
            )

        return conn_str
