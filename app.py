from flask import Flask
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import time
from datetime import date
from templates.login.register import register_admin
from templates.login.login import check_user
app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'your secret key'

# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'admin'
app.config['MYSQL_DB'] = 'bloodbankvarshneyabindrap'

# Intialize MySQL
mysql = MySQL(app)


@app.route('/login', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        account = check_user(mysql)
        # If account exists in admin table in database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['id'] = account['v_id']
            session['username'] = account['user_name']
            print(session['id'])
            # Redirect to home page
            return redirect(url_for('profile'))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
    return render_template('login/login.html', msg=msg)

@app.route('/logout')
def logout():
   print("Logging out... ")
   print(session)
    # Remove session data, this will log the user out
   session.pop('loggedin', None)
   session.pop('id', None)
   session.pop('username', None)
   # Redirect to login page
   return redirect(url_for('login'))


@app.route('/register', methods=['GET', 'POST'])
def register():
    msg = register_admin(mysql)
    return render_template('login/register.html', msg=msg)


@app.route('/profile')
def profile():
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE v_id = %s', (session['id'],))
        user = cursor.fetchone()
        print(user)
        return redirect (url_for('user',user = session['id'])) 
    return redirect(url_for('login'))

@app.route('/profile/<user>', methods=['GET'])
def user(user):
    if 'loggedin' in session and (user ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE v_id = %s', (session['id'],))
        user = cursor.fetchone()
        print(user)
        print("Profile.." + user['v_id'])
        return render_template('dashboard/dashboard.html', user=user)
    return redirect(url_for('login'))


@app.route('/profile/<user>/addDonor', methods=['GET','POST'])
def addDonor(user,msg= ""):
    if 'loggedin' in session and (user[0] ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE user_name = %s', (user,))
        account = cursor.fetchone()
        print(account)
        print(msg)

        if request.method =='POST':
            fname = request.form['firstName']
            lname = request.form['lastName']
            streetAddress = request.form['streetAddress']
            state = request.form['state']
            city = request.form['city']
            pincode = request.form['pincode']
            phoneNumber = request.form['phoneNumber']
            age= request.form['age']
            gender = request.form['gender']
            medicalremarks = request.form['medicalRemarks'].strip("\r\n")
            bloodgroup = request.form['bloodGroup']
            dateOfRegistration = date.today().strftime('%Y-%m-%d %H:%M:%S')
            volunteer_id = session['id']
            if (fname and lname and streetAddress and state and city and pincode and phoneNumber and age and gender and bloodgroup and dateOfRegistration and volunteer_id):
                if not (re.match(r'[0-9]+', pincode) ):
                    msg = "Pincode can only contain numeric values"
                elif not (re.match(r'[0-9]+', phoneNumber) and len(phoneNumber) == 10):
                    msg = "Phone Number can only have numeric values and can be of only 10 digits"
                elif not(re.match(r'[0-9]+', age)):
                    msg = "Age can only be numeric value"
                else:
                    cursor.execute('INSERT INTO donor VALUES (NULL, %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s )',(fname,lname,streetAddress,state,int(pincode),phoneNumber,gender,int(age),medicalremarks,bloodgroup,dateOfRegistration,volunteer_id,))
                    mysql.connection.commit()
                    msg = "Donor Registered Successfully!"
            print(msg)
        return render_template('donor/addDonor.html', user=user,msg = msg)
    
    return redirect(url_for('login'))


@app.route('/profile/<user>/editDonor', methods=['GET','POST'])
def editDonor(user,msg = ""):
    if 'loggedin' in session and (user[0] ==session['id']):
        if request.method == 'POST':
            phoneToSearch = request.form['phoneNumber']
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('SELECT * FROM donor WHERE phone = %s', (phoneToSearch,))
            user = cursor.fetchall()
            print(user)
            if user:
                msg = "User Found"
            else: 
                msg = "No such user found"
        return render_template('donor/editDonor.html', user=user,msg = msg)
    return redirect(url_for('login'))

@app.route('/profile/<user>/inventory')
def inventory(user):

    if 'loggedin' in session and (user[0] ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE v_id = %s', (session['id'],))
        user = cursor.fetchone()
        return render_template('inventory/inventory.html')
    return redirect(url_for('login'))

@app.route('/profile/<user>/requestUnit', methods=['GET'])
def requestUnit(user):

    if 'loggedin' in session and (user[0] ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE v_id = %s', (session['id'],))
        user = cursor.fetchone()
        return render_template('hospital/requestUnit.html')
    return redirect(url_for('login'))

@app.route("/home")
@app.route("/")
def home():
    users = [
                {'name':'Aditya',
                 'age' : 23},
                 {'name':'ABC',
                 'age' : 24}
            ]
    
    return render_template('login/login.html',users= users)

if __name__ == "__main__":
    app.run(debug=True)
