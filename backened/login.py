# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy
# from werkzeug.security import generate_password_hash, check_password_hash

# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)

# # Define the User model
# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     email = db.Column(db.String(255), unique=True, nullable=False)
#     password = db.Column(db.String(255), nullable=False)

# # Route to handle login
# @app.route('/login', methods=['POST'])
# def login():
#     data = request.json
#     email = data.get('email')
#     password = data.get('password')

#     # Debugging output
#     print(f"Received email: {email}")
#     print(f"Received password: {password}")

#     # Query the user by email
#     user = User.query.filter_by(email=email).first()

#     # Debugging output
#     if user:
#         print(f"User found: {user.email}")

#     # Check password and respond
#     if user and check_password_hash(user.password, password):
#         return jsonify({'message': 'Login successful', 'redirect': '/dashboard'})
#     else:
#         return jsonify({'message': 'Invalid email or password'}), 401

# # Create tables and start the app
# if __name__ == '__main__':
#     with app.app_context():
#         db.create_all()  # Create tables if they don't exist
#     app.run(debug=True)


from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import check_password_hash
from flask_cors import CORS  # Import CORS

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
CORS(app)  # Enable CORS for the entire app

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=True) 
    email = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    if user and check_password_hash(user.password, password):
        return jsonify({'message': 'Login successful','name':user.name, 'redirect': '/dashboard'})
    else:
        return jsonify({'message': 'Invalid email or password'}), 401

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
