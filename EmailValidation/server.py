from flask import Flask, request, redirect, render_template, session, flash
from mysqlconnection import MySQLConnector
import re
app = Flask(__name__)
app.secret_key = 'MySuperSecretKey'
mysql = MySQLConnector(app,'emaildb')

# Create the regex we will use to validate email
EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9\.\+_-]+@[a-zA-Z0-9\.]')

@app.route('/')
def index():
    emails = mysql.query_db("SELECT * FROM emails")
    print emails
    return render_template('index.html', all_emails=emails)

@app.route('/add_email', methods=['POST'])
def add():
    formError = False
    thisEmail = request.form['email'].strip()

    ## Email validation
    if len(thisEmail) < 1:
        flash("Email cannot be empty")
        formError = True
    elif not EMAIL_REGEX.match(thisEmail):
        flash("Invalid Email address!")
        formError = True

    # Run query, with dictionary values injected into the query.
    if formError != True:
        # we want to insert into our query.
        query = "INSERT INTO emails (email, created_at, updated_at) \
                    VALUES (:email, NOW(), NOW())"
        # We'll then create a dictionary of data from the POST data received.
        data = {
                 'email': thisEmail
               }
        mysql.query_db(query, data)
        flash("Success!")
        # all_emails = mysql.query_db("SELECT * FROM emails")
        # return(render_template("success.html",
        #             email=thisEmail,
        #             all_emails = all_emails)
        #     )

    flash("Email is not valid!")

    return redirect('/')

@app.route('/update/<email_id>', methods=['POST'])
def update(email_id):
    query = "UPDATE emails \
             SET email = :email, updated_at = NOW() \
             WHERE id = :id"
    data = {
             'email': request.form['email'],
             'id': friend_id
           }
    mysql.query_db(query, data)
    return redirect('/')

@app.route('/delete/<email_id>', methods=['POST'])
def delete(email_id):
    query = "DELETE FROM emails WHERE id = :id"
    data = {'id': email_id}
    mysql.query_db(query, data)
    return redirect('/')

# @app.route('/emails/<email_id>')
# def show(email_id):
#     # Write query to select specific user by id. At every point where
#     # we want to insert data, we write ":" and variable name.
#     query = "SELECT * FROM emails WHERE id = :specific_id"
#     # Then define a dictionary with key that matches :variable_name in query.
#     data = {'specific_id': email_id}
#     # Run query with inserted data.
#     emails = mysql.query_db(query, data)
#     # Friends should be a list with a single object,
#     # so we pass the value at [0] to our template under alias one_friend.
#     return render_template('index.html', one_email=emails[0])

app.run(debug=True)
