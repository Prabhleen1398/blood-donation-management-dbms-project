from flask import Flask
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import time
from datetime import date
from templates.login.register import register_admin
from templates.login.login import check_user
from templates.donor.addDonor import addADonor
from templates.donor.editDonor import validate
import argparse
import json

argParser = argparse.ArgumentParser()
argParser.add_argument("-u", "--username", help="your mysql username")
argParser.add_argument("-p", "--password", help="your mysql password")

args = argParser.parse_args()

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'your secret key'

# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = args.username
app.config['MYSQL_PASSWORD'] = args.password
app.config['MYSQL_DB'] = 'bloodbankvarshneyabindrap'

# Intialize MySQL
mysql = MySQL(app)

@app.route("/")
@app.route('/login', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        # # Check if account exists using MySQL
        # cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        # cursor.execute('SELECT * FROM administrator WHERE user_name = %s AND user_password = %s', (username, password,))
        # # Fetch one record and return result
        # account = cursor.fetchone()
        account = check_user(mysql,username,password)
        # If account exists in admin table in out database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['id'] = str(account['volunteer_id'])
            session['username'] = account['user_name']
            # Redirect to home page
            print("Redirecting....")
            return redirect(url_for('user',user = session['id']))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
    return render_template('login/login.html', msg=msg)




@app.route('/register', methods=['GET', 'POST'])
def register():
    msg = register_admin(mysql)
    return render_template('login/register.html', msg=msg)


@app.route('/profile/<user>/', methods=['GET'])
def user(user):
    print("Profile .. " , type(user))
    print("Session id : ",type(session['id']))
    if 'loggedin' in session and user == session['id']:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM administrator WHERE volunteer_id = %s', (session['id'],))
        user = cursor.fetchone()
        cursor.close()
        return render_template('dashboard/dashboard.html', user=user)
    return redirect(url_for('login'))


@app.route('/profile/<user>/addDonor', methods=['GET','POST'])
def addDonor(user,msg= ""):
    if 'loggedin' in session and (user ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.callproc('select_blood_group',[])
        bloodgroups = cursor.fetchall()
        cursor.nextset()
        cursor.close()
        if request.method =='POST':
            args,msg = addADonor(request,user)
            if(args != None or msg =="Donor Registration Successful"):
                try:
                    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                    cursor.callproc('create_donor',args)
                    mysql.connection.commit()
                    cursor.close()
                except Exception as e:
                    print(e)
                    msg = e.args[1]
            
        return render_template('donor/addDonor.html', user=user,msg = msg,bloodgroups = bloodgroups)
    
    return redirect(url_for('login'))


@app.route('/profile/<user>/editDonor', methods=['GET','POST'])
def editDonor(user,msg = ""):
    if 'loggedin' in session and (user[0] ==session['id']):
        if request.method == 'POST':
            if(request.form['formButton'] == "Search Donor"):
                phoneToSearch = request.form['phoneNumber']
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('SELECT * FROM donor WHERE phone = %s', (phoneToSearch,))
                user = cursor.fetchone()
                cursor.callproc('select_blood_group',[])
                bloodgroups = cursor.fetchall()
                print(user)
                cursor.close()
                if user:
                    msg = "User Found"
                else: 
                    msg = "No such user found"
                return render_template('donor/editDonor.html', user=user,msg = msg,bloodgroups= bloodgroups)    
            
            elif(request.form['formButton'] == "Update Donor"):
                args,msg = validate(request)
                print("Updating records...")
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.callproc('update_donor_details',args)
                mysql.connection.commit()
                cursor.close()
                msg = "User details updated successfully!"
                return render_template('donor/editDonor.html', user=user,msg = msg)    


        return render_template('donor/editDonor.html', user=user,msg = msg)
    return redirect(url_for('login'))


@app.route('/profile/<user>/deleteDonor', methods=['GET','POST'])
def deleteDonor(user):
    if 'loggedin' in session and (user[0] ==session['id']):
        msg = ""
        if request.method == 'POST':
            args= [request.form['phoneNumber'],]
            try:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.callproc('delete_donor',args)
                cursor.close()
                msg = "User deleted successfully!"
                mysql.connection.commit()            
            except Exception as e:
                msg = e.args[1]
        
        return render_template('donor/deleteDonor.html',msg = msg)
    return redirect(url_for('login'))


@app.route('/profile/<user>/donateBlood', methods=['GET','POST'])
def donateBlood(user,phoneNumber = ""):
    print("DonateBlood Function")
    if 'loggedin' in session and (user ==session['id']):
        msg = ""
        print("DonateBlood Function User Logged In")
        if request.method == 'POST':
            
            if(request.form['formButton'] == "Search Donor"):
                phoneNumber = request.form['phoneNumber']
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('SELECT * FROM donor WHERE phone = %s', (phoneNumber,))
                user = cursor.fetchone()
                cursor.close()
                if(user):
                    msg = "Donor Found !"
                    return render_template("inventory/issueUnit.html",user = user,msg = msg)
                else:
                    msg = "Donor Not Found!"
                
                
            elif(request.form['formButton'] == "Donate"):
                print("DONATE BLOOD BUTTON CLICKED")
                phoneNumber = request.form['donorPhoneNumber']
                print(phoneNumber)
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.callproc('add_blood_bag', (phoneNumber,))
                print("Blood donated" , phoneNumber)
                mysql.connection.commit()  
                cursor.close()
                msg = user + "Donated Blood!"
        return render_template("inventory/issueUnit.html",user = user,msg = msg)
        
    return redirect(url_for('login'))

                







@app.route('/profile/<user>/addHospital', methods=['GET','POST'])
def addHospital(user):
    if 'loggedin' in session and (user[0] ==session['id']):
        msg = ""
        if request.method == 'POST':
            args= [request.form['hospitalName'], request.form['streetAddress'],request.form['state'],request.form['pincode']]
            try:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.callproc('add_hospital',args)
                cursor.close()
                msg = "Hospital Added successfully!"
                mysql.connection.commit()            
            except Exception as e:
                msg = e.args[1]
        return render_template('hospital/addHospital.html',msg = msg)
    return redirect(url_for('login'))

@app.route('/profile/<user>/addPatient', methods=['GET','POST'])
def addPatient(user):
    # fk contraint fails when a new patient is added with a type of admission 
    # and severity not in admission table
    if 'loggedin' in session and (user[0] ==session['id']):
        msg = ""
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.callproc('get_hospitals')
        hospitals = cursor.fetchall()
        print(hospitals)
        cursor.nextset()
        cursor.callproc('select_blood_group')
        bloodgroups = cursor.fetchall()
        print(bloodgroups)
        cursor.nextset()
        cursor.callproc('get_reasonofadmission')
        reasonOfAdmission = cursor.fetchall()
        newROAset=set()
        for i in reasonOfAdmission:
            print(i['type_of_admission'])
            newROAset.add(i['type_of_admission'])
        print(newROAset)
        cursor.nextset()
        cursor.close()

        if request.method == 'POST':
            try:
                args = [request.form['firstName'],request.form['lastName'],
                        request.form['bloodGroup'],request.form['medicalRemarks'],
                        request.form['hospitalNames'],request.form['reasonOfAdmission'],int(request.form['severityValue'])]
                print(args)
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.callproc('add_patient_to_hospital',args)
                msg = "Patient Added successfully!"
                mysql.connection.commit()           
                cursor.close()
                print("Adding Patient..")

                
                
            except Exception as e:
                msg = e.args[1]
                print(e)
        return render_template('hospital/addPatient.html',msg = msg,hospitals = hospitals,bloodgroups= bloodgroups,reasonOfAdmission = newROAset)
    return redirect(url_for('login'))








@app.route('/profile/<user>/inventory')
def inventory(user):
    if 'loggedin' in session and (user ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.callproc('get_blood_by_group')
        bloodbagData = cursor.fetchall()
        print(bloodbagData)
        cursor.nextset()     
        cursor.execute('SELECT * from blood_bag')
        allBloodBags = cursor.fetchall()
        cursor.nextset()
        print(allBloodBags)
        cursor.close()
        
        labels=[]
        data = []
        for i in range(len(bloodbagData)):
            labels.append(bloodbagData[i]['blood_group_type'])
            data.append(bloodbagData[i]['available_count'])
   
        
        return render_template('inventory/inventory.html',bloodbagData = bloodbagData,data = data , labels = labels,allBloodBags = allBloodBags)
    return redirect(url_for('login'))

@app.route('/profile/<user>/approveRequest', methods=['GET','POST'])
def approveRequest(user):
    if 'loggedin' in session and (user ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.callproc('select_hospital_requests')
        pendingRequests = cursor.fetchall()
        cursor.nextset() 
        print(pendingRequests)
        mysql.connection.commit()
        cursor.close()
        table_columns = ["Request id","inventory_id","hospital_id","bag_id","requested","received"]
        msg = ""
        if(request.method == "POST"):
                print("Approving Request ID %s",request.form['requestID'])
                try:

                    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                    print(request.form['requestID'],user)
                    print(type(request.form['requestID']),type(user))
                    cursor.callproc('approve_hospital_request',[int(request.form['requestID']) , int(user),])
                    mysql.connection.commit() 
                    cursor.close()
                    msg = "Request Approved Successfully !"
                except Exception as e:
                    msg = e.args
        return render_template('hospital/approveRequest.html',msg=  msg,table_columns = table_columns,pendingRequests = pendingRequests)
    return redirect(url_for('login'))


@app.route('/profile/<user>/newRequest', methods=['GET','POST'])
def newRequest(user):
    if 'loggedin' in session and (user ==session['id']):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT * from patient")
        allPatients = cursor.fetchall()
        cursor.nextset()
        cursor.close()
        print(allPatients)
        msg = ""
        if request.method == "POST":
            try:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.callproc('add_additional_blood_bag',[int(request.form['patientID'])])
                mysql.connection.commit()
                cursor.close()
                msg = "New Request Initiated"
            except Exception as e:
                msg = e.args[1]
        return render_template('hospital/newRequest.html',msg = msg, allPatients = allPatients)
    
    return redirect(url_for('login'))
        

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

if __name__ == "__main__":
    app.run(debug=True)
