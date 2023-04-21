from flask import request
import re
import MySQLdb.cursors


def register_admin (mysql):
    # Output message if something goes wrong...
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST':
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE user_name = %s', (username,))
        account = cursor.fetchone()
        # If account exists show error and validation checks
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password :
            msg = 'Please fill out the form!'
        else:
            # Account doesnt exists and the form data is valid, now insert new account into admin table
            # cursor.execute('add_admin(NULL, %s, %s)', (username, password,))

            args = [username, password]
            print(username,password)
            cursor.callproc('add_admin',args)
            mysql.connection.commit()
            msg = 'You have successfully registered!'

    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
    # Show registration form with message (if any)
    return msg