from flask import Flask, request, redirect, render_template, session, flash
from mysqlconnection import MySQLConnector
import re
app = Flask(__name__)
app.secret_key = 'MySuperSecretKey'
mysql = MySQLConnector(app,'friendsdb')
# Create the regex we will use to validate email
EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9\.\+_-]+@[a-zA-Z0-9\.]')

@app.route('/', methods=['GET'])
def index():
    friends = mysql.query_db("SELECT * FROM friends")
    print friends
    return render_template('index.html', all_friends=friends)

@app.route('/friends', methods=['POST'])
def create():
    formError = False
    thisFirstname = request.form['first_name'].strip()
    thisLastname = request.form['last_name'].strip()
    thisEmail = request.form['email'].strip()
    # Print out to console, for testing
    print thisFirstname
    print thisLastname
    print thisEmail
    # Basic field validation
    if len(request.form['first_name']) < 1 or len(request.form['last_name']) < 1:
        flash("Both name fields required")
        formError = True
    ## Email validation
    elif len(thisEmail) < 1:
        flash("Email cannot be empty")
        formError = True
    elif not EMAIL_REGEX.match(thisEmail):
        flash("Invalid Email address!")
        formError = True

    # Run query, with dictionary values injected into the query.
    if formError != True:
        # Write query as a string. Notice how we have multiple values
        # we want to insert into our query.
        query = "INSERT INTO friends (first_name, last_name, email, created_at, updated_at) VALUES (:first_name, :last_name, :email, NOW(), NOW())"
        # We'll then create a dictionary of data from the POST data received.
        data = {
                 'first_name': request.form['first_name'],
                 'last_name':  request.form['last_name'],
                 'email': request.form['email']
               }
        # Run query, with dictionary values injected into the query.
        mysql.query_db(query, data)
        flash("Success!")
        return redirect('/')
    else:
        return

@app.route('/friends/<id>/edit', methods=['GET'])
def edit(id):
    # Write query to select specific user by id. At every point where
    # we want to insert data, we write ":" and variable name.
    query = "SELECT * FROM friends WHERE id = :friend_id"
    # Then define a dictionary with key that matches :variable_name in query.
    data = {'friend_id': id}
    # Run query with inserted data.
    friends = mysql.query_db(query, data)
    # Friends should be a list with a single object,
    # so we pass the value at [0] to our template under alias one_friend.
    return render_template('edit.html', friend=friends[0])

@app.route('/friends/<friend_id>', methods=['POST'])
def update(friend_id):
    query = "UPDATE friends \
             SET first_name = :first_name, last_name = :last_name, email = :email, updated_at = NOW() \
             WHERE id = :id"
    data = {
             'first_name': request.form['first_name'],
             'last_name':  request.form['last_name'],
             'email': request.form['email'],
             'id': friend_id
           }
    mysql.query_db(query, data)
    return redirect('/')

##@app.route('/friends/<friend_id>/delete', methods=['GET','POST'])
@app.route('/friends/<friend_id>/delete', methods=['POST'])
def delete(friend_id):
    query = "DELETE FROM friends WHERE id = :id"
    data = {'id': friend_id}
    mysql.query_db(query, data)
    return redirect('/')

# @app.route('/friends/<friend_id>')
# def show(friend_id):
#     # Write query to select specific user by id. At every point where
#     # we want to insert data, we write ":" and variable name.
#     query = "SELECT * FROM friends WHERE id = :specific_id"
#     # Then define a dictionary with key that matches :variable_name in query.
#     data = {'specific_id': friend_id}
#     # Run query with inserted data.
#     friends = mysql.query_db(query, data)
#     # Friends should be a list with a single object,
#     # so we pass the value at [0] to our template under alias one_friend.
#     return render_template('index.html', one_friend=friends[0])

app.run(debug=True)
