# config.py

class Config:
    SECRET_KEY = 'Mtp@2006'  # Replace with a strong secret key
    MYSQL_HOST = 'localhost'  # Replace with your MySQL server hostname if different
    MYSQL_USER = 'root'  # Replace with your MySQL username
    MYSQL_PASSWORD = 'Mtp@2006'  # Replace with your MySQL password
    MYSQL_DB = 'voting_system'  # The database you're using
    MYSQL_CURSORCLASS = 'DictCursor'  # Use DictCursor to return results as dictionaries
