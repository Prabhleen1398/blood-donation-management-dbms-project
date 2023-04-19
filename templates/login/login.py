from flask import request
import MySQLdb.cursors

def check_user(mysql,username,password):
    # Check if account exists using MySQL
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM administrator WHERE user_name = %s AND user_password = %s', (username, password,))
    # Fetch one record and return result
    
    account = cursor.fetchone()
    return account