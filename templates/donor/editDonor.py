from flask import request
import re
from datetime import date
# DONOR table does not have city column
# bloodgroup cannot be changed.

def validate(request):
    fname = request.form['firstName']
    lname = request.form['lastName']
    streetAddress = request.form['streetAddress']
    state = request.form['state']
    city = request.form['city']
    pincode = request.form['pincode']
    phoneNumber = request.form['phoneNumber']
    age= request.form['age']
    gender = request.form['gender']
    medicalRemarks = request.form['medicalRemarks'].strip("\r\n")
    bloodgroup = request.form['bloodGroup']
    dateOfRegistration = date.today().strftime('%Y-%m-%d %H:%M:%S')
    msg = ""
    if (fname and lname and streetAddress and state and city and pincode and phoneNumber and age and gender and bloodgroup and dateOfRegistration and volunteer_id):
      if not (re.match(r'[0-9]+', pincode) ):
        msg = "Pincode can only contain numeric values"
      elif not (re.match(r'[0-9]+', phoneNumber) and len(phoneNumber) == 10):
        msg = "Phone Number can only have numeric values and can be of only 10 digits"
      elif not(re.match(r'[0-9]+', age)):
        msg = "Age can only be numeric value"
      else:
        msg = "Donor Registration Successful"
      
    args = [phoneNumber,fname,lname,streetAddress,state,pincode,gender,age,medicalRemarks,]
    
    return args,msg
