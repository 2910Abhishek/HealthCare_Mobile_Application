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


# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy
# from werkzeug.security import check_password_hash
# from flask_cors import CORS  # Import CORS

# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)
# CORS(app)  # Enable CORS for the entire app

# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=True) 
#     email = db.Column(db.String(255), unique=True, nullable=False)
#     password = db.Column(db.String(255), nullable=False)

# @app.route('/login', methods=['POST'])
# def login():
#     data = request.json
#     email = data.get('email')
#     password = data.get('password')

#     user = User.query.filter_by(email=email).first()

#     if user and check_password_hash(user.password, password):
#         return jsonify({'message': 'Login successful','name':user.name, 'redirect': '/dashboard'})
#     else:
#         return jsonify({'message': 'Invalid email or password'}), 401

# if __name__ == '__main__':
#     with app.app_context():
#         db.create_all()
#     app.run(debug=True)


# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy
# from werkzeug.security import check_password_hash, generate_password_hash
# from flask_cors import CORS

# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)
# CORS(app)  # Enable CORS for the entire app

# # Define the User model (which represents doctors)
# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=True) 
#     email = db.Column(db.String(255), unique=True, nullable=False)
#     password = db.Column(db.String(255), nullable=False)

# # Define the Patient model
# class Patient(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=False)
#     gender = db.Column(db.String(50), nullable=False)
#     age = db.Column(db.Integer, nullable=False)
#     reporting_time = db.Column(db.String(50), nullable=False)
#     patient_history_url = db.Column(db.String(255), nullable=True)
#     lab_report_url = db.Column(db.String(255), nullable=True)
#     doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

# # Route to handle login
# @app.route('/login', methods=['POST'])
# def login():
#     data = request.json
#     email = data.get('email')
#     password = data.get('password')

#     user = User.query.filter_by(email=email).first()

#     if user and check_password_hash(user.password, password):
#         return jsonify({'message': 'Login successful', 'name': user.name, 'doctor_id': user.id, 'redirect': '/dashboard'})
#     else:
#         return jsonify({'message': 'Invalid email or password'}), 401

# # Endpoint to add a patient to the database
# @app.route('/add-patient', methods=['POST'])
# def add_patient():
#     data = request.json
#     name = data.get('name')
#     gender = data.get('gender')
#     age = data.get('age')
#     reporting_time = data.get('reporting_time')
#     patient_history_url = data.get('patient_history_url', None)
#     lab_report_url = data.get('lab_report_url', None)
#     doctor_id = data.get('doctor_id')

#     # Create a new Patient object
#     new_patient = Patient(
#         name=name,
#         gender=gender,
#         age=age,
#         reporting_time=reporting_time,
#         patient_history_url=patient_history_url,
#         lab_report_url=lab_report_url,
#         doctor_id=doctor_id
#     )

#     # Add to the database
#     db.session.add(new_patient)
#     db.session.commit()

#     return jsonify({'message': 'Patient added successfully'})

# # Endpoint to retrieve patient data
# @app.route('/get-patient-data', methods=['GET'])
# def get_patient_data():
#     patients = Patient.query.all()
#     patient_data = []

#     for patient in patients:
#         doctor = User.query.get(patient.doctor_id)
#         patient_data.append({
#             'name': patient.name,
#             'gender': patient.gender,
#             'age': patient.age,
#             'reporting_time': patient.reporting_time,
#             'patient_history_url': patient.patient_history_url,
#             'lab_report_url': patient.lab_report_url,
#             'assigned_doctor': doctor.name  # Fetch doctor name by ID
#         })

#     return jsonify(patient_data)

# if __name__ == '__main__':
#     with app.app_context():
#         db.create_all()
#     app.run(debug=True)


# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy
# from werkzeug.security import check_password_hash, generate_password_hash
# from flask_cors import CORS
# from flask_socketio import SocketIO, emit

# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)
# CORS(app)  # Enable CORS for the entire app

# # Initialize SocketIO
# socketio = SocketIO(app, cors_allowed_origins="*")

# # Define the User model (which represents doctors)
# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=True)
#     email = db.Column(db.String(255), unique=True, nullable=False)
#     password = db.Column(db.String(255), nullable=False)

# # Define the Patient model
# class Patient(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=False)
#     gender = db.Column(db.String(50), nullable=False)
#     age = db.Column(db.Integer, nullable=False)
#     reporting_time = db.Column(db.String(50), nullable=False)
#     patient_history_url = db.Column(db.String(255), nullable=True)
#     lab_report_url = db.Column(db.String(255), nullable=True)
#     doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

# # Route to handle login
# @app.route('/login', methods=['POST'])
# def login():
#     data = request.json
#     email = data.get('email')
#     password = data.get('password')

#     user = User.query.filter_by(email=email).first()

#     if user and check_password_hash(user.password, password):
#         return jsonify({'message': 'Login successful', 'name': user.name, 'doctor_id': user.id, 'redirect': '/dashboard'})
#     else:
#         return jsonify({'message': 'Invalid email or password'}), 401

# # Endpoint to add a patient to the database
# @app.route('/add-patient', methods=['POST'])
# def add_patient():
#     data = request.json
#     name = data.get('name')
#     gender = data.get('gender')
#     age = data.get('age')
#     reporting_time = data.get('reporting_time')
#     patient_history_url = data.get('patient_history_url', None)
#     lab_report_url = data.get('lab_report_url', None)
#     doctor_id = data.get('doctor_id')

#     # Create a new Patient object
#     new_patient = Patient(
#         name=name,
#         gender=gender,
#         age=age,
#         reporting_time=reporting_time,
#         patient_history_url=patient_history_url,
#         lab_report_url=lab_report_url,
#         doctor_id=doctor_id
#     )

#     # Add to the database
#     db.session.add(new_patient)
#     db.session.commit()

#     # Emit the new patient data to all connected clients
#     doctor = User.query.get(new_patient.doctor_id)
#     patient_data = {
#         'name': new_patient.name,
#         'gender': new_patient.gender,
#         'age': new_patient.age,
#         'reporting_time': new_patient.reporting_time,
#         'patient_history_url': new_patient.patient_history_url,
#         'lab_report_url': new_patient.lab_report_url,
#         'assigned_doctor': doctor.name
#     }
#     socketio.emit('new_patient', patient_data)

#     return jsonify({'message': 'Patient added successfully'})

# # Endpoint to retrieve patient data
# @app.route('/get-patient-data', methods=['GET'])
# def get_patient_data():
#     patients = Patient.query.all()
#     patient_data = []

#     for patient in patients:
#         doctor = User.query.get(patient.doctor_id)
#         patient_data.append({
#             'name': patient.name,
#             'gender': patient.gender,
#             'age': patient.age,
#             'reporting_time': patient.reporting_time,
#             'patient_history_url': patient.patient_history_url,
#             'lab_report_url': patient.lab_report_url,
#             'assigned_doctor': doctor.name  # Fetch doctor name by ID
#         })

#     return jsonify(patient_data)

# if __name__ == '__main__':
#     with app.app_context():
#         db.create_all()
#     socketio.run(app, debug=True)


from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import check_password_hash, generate_password_hash
from flask_cors import CORS
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
CORS(app)

socketio = SocketIO(app, cors_allowed_origins="*", transport='websocket')

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

class Patient(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    gender = db.Column(db.String(50), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    reporting_time = db.Column(db.String(50), nullable=False)
    patient_history_url = db.Column(db.String(255), nullable=True)
    lab_report_url = db.Column(db.String(255), nullable=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    if user and check_password_hash(user.password, password):
        return jsonify({'message': 'Login successful', 'name': user.name, 'doctor_id': user.id, 'redirect': '/dashboard'})
    else:
        return jsonify({'message': 'Invalid email or password'}), 401

@app.route('/add-patient', methods=['POST'])
def add_patient():
    data = request.json
    new_patient = Patient(
        name=data.get('name'),
        gender=data.get('gender'),
        age=data.get('age'),
        reporting_time=data.get('reporting_time'),
        patient_history_url=data.get('patient_history_url'),
        lab_report_url=data.get('lab_report_url'),
        doctor_id=data.get('doctor_id')
    )

    db.session.add(new_patient)
    db.session.commit()

    doctor = User.query.get(new_patient.doctor_id)
    patient_data = {
        'id': new_patient.id,
        'name': new_patient.name,  # This is now correctly the patient's name
        'gender': new_patient.gender,
        'age': new_patient.age,
        'reporting_time': new_patient.reporting_time,
        'patient_history_url': new_patient.patient_history_url,
        'lab_report_url': new_patient.lab_report_url,
        'assigned_doctor': doctor.name
    }
    socketio.emit('new_patient', patient_data)

    return jsonify({'message': 'Patient added successfully'})

@app.route('/get-patient-data', methods=['GET'])
def get_patient_data():
    patients = Patient.query.all()
    patient_data = []

    for patient in patients:
        doctor = User.query.get(patient.doctor_id)
        patient_data.append({
            'id': patient.id,
            'name': patient.name,  # This is now correctly the patient's name
            'gender': patient.gender,
            'age': patient.age,
            'reporting_time': patient.reporting_time,
            'patient_history_url': patient.patient_history_url,
            'lab_report_url': patient.lab_report_url,
            'assigned_doctor': doctor.name
        })

    return jsonify(patient_data)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    socketio.run(app, debug=True)
