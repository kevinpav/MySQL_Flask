from flask import Flask, request, redirect, render_template, session, flash
from mysqlconnection import MySQLConnector
from flask_bcrypt import Bcrypt
import re
app = Flask(__name__)
app.secret_key = 'MySuperSecretKey'
bcrypt = Bcrypt(app)
# Adjusted existing schema, added 'first_name, last_name, passwd' fields for this assignment
mysql = MySQLConnector(app,'emaildb')
# Create the regex we will use to validate email
EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9\.\+_-]+@[a-zA-Z0-9\.]')
###
# Env: MySQL>flaskMySQL\Scripts\activate
# Run: python server.py
###
@app.route('/', methods=['GET'])
def index_get():

    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login_post():
    formError = False
    thisEmail = request.form['email'].strip().lower()
    thisPasswd = request.form['passwd'].strip()
    if len(thisEmail) < 1:
        flash("Email cannot be empty")
        formError = True
    elif not EMAIL_REGEX.match(thisEmail):
        flash("Invalid Email address!")
        formError = True
    elif len(thisPasswd) < 8:
        flash("Password must be at least 8 characters")
        formError = True

    if formError != True:
        # Added plain-text password as well as pw_hash to DB table for debugging
        query = "SELECT * FROM emails WHERE email = :email"
        # We'll then create a dictionary of data from the POST data received.
        data = {
                 'email': thisEmail
               }

        # Run query, with dictionary values injected into the query.
        users = mysql.query_db(query, data)
        if len(users) == 1:
            if bcrypt.check_password_hash(users[0]['pw_hash'], thisPasswd):
                print users[0]
                flash("Login Success!")
                session['id'] = users[0]['id']
                #return redirect("/success/{}".format(users[0]['id']))
                return redirect("/success")
            else:
                flash("Password does not match!")
                return render_template('index.html')
        else:
            # Consider any <> 1 as an error. HaCkerZ..
            flash("User not found! Have you Registered?")
            return render_template('index.html')

    else:
        return render_template('index.html')

@app.route('/success', methods=['GET'])
def success_get():
    query = "SELECT * FROM emails WHERE id = :user_id"
    data = {'user_id': session['id']}
    users = mysql.query_db(query, data)
    if len(users) < 1:
        flash("There was an error finding your account")
        return redirect('/')

    return render_template('success.html', user=users[0])

@app.route('/register', methods=['GET'])
def register_get():
    # Display the registration form
    return render_template('register.html')

@app.route('/register', methods=['POST'])
def register_post():
    # print "Entering register_post()"
    formError = False
    thisFirstname = request.form['first_name'].strip()
    thisLastname = request.form['last_name'].strip()
    thisEmail = request.form['email'].strip().lower()
    thisPasswd = request.form['passwd'].strip()
    thisPasswd2 = request.form['passwd2'].strip()
    # Basic field validation
    if len(thisFirstname) < 2 or len(thisLastname) < 2:
        flash("First and Last Name fields must be at least 2 letters")
        formError = True
    ## Email validation
    elif len(thisEmail) < 1:
        flash("Email cannot be empty")
        formError = True
    elif not EMAIL_REGEX.match(thisEmail):
        flash("Invalid Email address!")
        formError = True
    elif len(thisPasswd) < 8:
        flash("Password must be at least 8 characters")
        formError = True
    elif thisPasswd != thisPasswd2:
        flash("Passwords do not match!")
        formError = True

    # Run query, with dictionary values injected into the query.
    if formError != True:
        # Create password hash
        pw_hash = bcrypt.generate_password_hash(thisPasswd)
        print "passwd [{}]".format(thisPasswd)
        print "pw_hash [{}]".format(pw_hash)
        # Write query as a string. Notice how we have multiple values
        # we want to insert into our query.
        # Added plain-text password as well as pw_hash for debugging
        query = "INSERT INTO emails (first_name, last_name, email, passwd, pw_hash, created_at, updated_at) \
                    VALUES (:first_name, :last_name, :email, :passwd, :pw_hash, NOW(), NOW())"
        # We'll then create a dictionary of data from the POST data received.
        data = {
                 'first_name': thisFirstname,
                 'last_name':  thisLastname,
                 'email': thisEmail,
                 'passwd': thisPasswd,
                 'pw_hash': pw_hash
               }
        # Run query, with dictionary values injected into the query.
        mysql.query_db(query, data)
        flash("Congratulations, you are registered!")
        flash("Please LOG IN to continue..")
        return redirect('/')
    else:
        #return render_template('register.html')
        return render_template("register.html")


app.run(debug=True)
