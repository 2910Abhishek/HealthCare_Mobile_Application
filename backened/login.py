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


# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy
# from werkzeug.security import check_password_hash, generate_password_hash
# from flask_cors import CORS
# from flask_socketio import SocketIO, emit

# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5433/Doctor'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)
# CORS(app)

# socketio = SocketIO(app, cors_allowed_origins="*", transport='websocket')

# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=True)
#     email = db.Column(db.String(255), unique=True, nullable=False)
#     password = db.Column(db.String(255), nullable=False)

# class Patient(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(255), nullable=False)
#     gender = db.Column(db.String(50), nullable=False)
#     age = db.Column(db.Integer, nullable=False)
#     reporting_time = db.Column(db.String(50), nullable=False)
#     patient_history_url = db.Column(db.String(255), nullable=True)
#     lab_report_url = db.Column(db.String(255), nullable=True)
#     doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

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

# @app.route('/add-patient', methods=['POST'])
# def add_patient():
#     data = request.json
#     new_patient = Patient(
#         name=data.get('name'),
#         gender=data.get('gender'),
#         age=data.get('age'),
#         reporting_time=data.get('reporting_time'),
#         patient_history_url=data.get('patient_history_url'),
#         lab_report_url=data.get('lab_report_url'),
#         doctor_id=data.get('doctor_id')
#     )

#     db.session.add(new_patient)
#     db.session.commit()

#     doctor = User.query.get(new_patient.doctor_id)
#     patient_data = {
#         'id': new_patient.id,
#         'name': new_patient.name,  # This is now correctly the patient's name
#         'gender': new_patient.gender,
#         'age': new_patient.age,
#         'reporting_time': new_patient.reporting_time,
#         'patient_history_url': new_patient.patient_history_url,
#         'lab_report_url': new_patient.lab_report_url,
#         'assigned_doctor': doctor.name
#     }
#     socketio.emit('new_patient', patient_data)

#     return jsonify({'message': 'Patient added successfully'})

# @app.route('/get-patient-data', methods=['GET'])
# def get_patient_data():
#     patients = Patient.query.all()
#     patient_data = []

#     for patient in patients:
#         doctor = User.query.get(patient.doctor_id)
#         patient_data.append({
#             'id': patient.id,
#             'name': patient.name,  # This is now correctly the patient's name
#             'gender': patient.gender,
#             'age': patient.age,
#             'reporting_time': patient.reporting_time,
#             'patient_history_url': patient.patient_history_url,
#             'lab_report_url': patient.lab_report_url,
#             'assigned_doctor': doctor.name
#         })

#     return jsonify(patient_data)

# if __name__ == '__main__':
#     with app.app_context():
#         db.create_all()
#     socketio.run(app, debug=True)




from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import check_password_hash, generate_password_hash
from flask_cors import CORS
from flask_socketio import SocketIO, emit
from datetime import datetime
from sqlalchemy.dialects.postgresql import JSON
from sqlalchemy.orm import Session
import logging
import traceback
from io import BytesIO
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
import json


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5432/Doctor'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
CORS(app)

socketio = SocketIO(app, cors_allowed_origins="*", transport='websocket')

# Set up logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)


class Medicine(db.Model):
    __tablename__ = 'medicines'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now()) 

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

class DoctorTimeSlot(db.Model):
    __tablename__ = 'doctor_time_slots'
    
    id = db.Column(db.Integer, primary_key=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    doctor_name = db.Column(db.String(255), nullable=False)
    date = db.Column(db.Date, nullable=False)
    time_slots = db.Column(db.JSON, nullable=False, default=dict)
    created_at = db.Column(db.DateTime, server_default=db.func.now())

    __table_args__ = (
        db.UniqueConstraint('doctor_id', 'date', name='unique_doctor_date'),
    )
    
class Prescription(db.Model):
    __tablename__ = 'prescriptions'
    
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, nullable=False)
    medications = db.Column(JSON, nullable=False)
    remarks = db.Column(db.Text, nullable=True)
    next_appointment = db.Column(db.DateTime, nullable=True)
    next_appointment_time = db.Column(db.Time, nullable=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patient.id'), nullable=False)
    pdf_data = db.Column(db.LargeBinary, nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())

    # Relationships
    doctor = db.relationship('User', backref='prescriptions')
    patient = db.relationship('Patient', backref='prescriptions')

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
    try:
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
            'name': new_patient.name,
            'gender': new_patient.gender,
            'age': new_patient.age,
            'reporting_time': new_patient.reporting_time,
            'patient_history_url': new_patient.patient_history_url,
            'lab_report_url': new_patient.lab_report_url,
            'assigned_doctor': doctor.name
        }
        
        # Emit the socket event
        socketio.emit('new_patient', patient_data, namespace='/')
        
        return jsonify({'message': 'Patient added successfully', 'patient': patient_data})
    except Exception as e:
        print(f"Error adding patient: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get-patient-data', methods=['GET'])
def get_patient_data():
    try:
        patients = Patient.query.all()
        patient_data = []

        for patient in patients:
            doctor = User.query.get(patient.doctor_id)
            patient_data.append({
                'id': patient.id,
                'name': patient.name,
                'gender': patient.gender,
                'age': patient.age,
                'reporting_time': patient.reporting_time,
                'patient_history_url': patient.patient_history_url,
                'lab_report_url': patient.lab_report_url,
                'assigned_doctor': doctor.name
            })

        return jsonify(patient_data)
    except Exception as e:
        print(f"Error fetching patients: {str(e)}")
        return jsonify({'error': str(e)}), 500
    
    
@app.route('/add-time-slots', methods=['POST'])
def add_time_slots():
    try:
        data = request.json
        logger.debug(f"Received data: {data}")
        
        doctor_id = data.get('doctorId')
        date = data.get('date')
        slots = data.get('availableSlots', [])

        if not all([doctor_id, date, slots]):
            return jsonify({'message': 'Missing required fields'}), 400

        # Get doctor information
        doctor = db.session.get(User, doctor_id)
        if not doctor:
            return jsonify({'message': 'Doctor not found'}), 404

        try:
            slot_date = datetime.strptime(date, '%Y-%m-%d').date()
        except ValueError as e:
            return jsonify({'message': f'Invalid date format: {str(e)}'}), 400

        try:
            # Find existing slot record
            slot_record = DoctorTimeSlot.query.filter_by(
                doctor_id=doctor_id,
                date=slot_date
            ).first()

            slots_dict = {slot: True for slot in slots}
            logger.debug(f"Slots dict: {slots_dict}")

            if slot_record:
                logger.debug(f"Updating existing record for date {date}")
                slot_record.time_slots = slots_dict
            else:
                logger.debug(f"Creating new record for date {date}")
                slot_record = DoctorTimeSlot(
                    doctor_id=doctor_id,
                    doctor_name=doctor.name,
                    date=slot_date,
                    time_slots=slots_dict
                )
                db.session.add(slot_record)

            db.session.commit()
            logger.debug("Successfully committed to database")

            # Emit socket event for real-time updates
            socketio.emit('time_slots_updated', {
                'doctor_id': doctor_id,
                'date': date,
                'slots': slots_dict
            })

            return jsonify({
                'message': 'Time slots added successfully',
                'doctor_name': doctor.name,
                'date': date,
                'slots': slots
            })

        except Exception as e:
            db.session.rollback()
            logger.error(f"Database error: {str(e)}")
            logger.error(traceback.format_exc())
            return jsonify({'message': f'Database error: {str(e)}'}), 500

    except Exception as e:
        logger.error(f"General error: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({'message': f'Error adding time slots: {str(e)}'}), 500

@app.route('/get-doctor-slots', methods=['GET'])
def get_doctor_slots():
    try:
        doctor_id = request.args.get('doctorId')
        date = request.args.get('date')

        logger.debug(f"Getting slots for doctor {doctor_id}, date {date}")

        if not doctor_id:
            return jsonify({'message': 'Doctor ID is required'}), 400

        try:
            query = DoctorTimeSlot.query.filter_by(doctor_id=doctor_id)
            
            if date:
                slot_date = datetime.strptime(date, '%Y-%m-%d').date()
                query = query.filter_by(date=slot_date)

            slots = query.all()
            logger.debug(f"Found {len(slots)} slot records")
            
            slots_data = {}
            for slot in slots:
                date_str = slot.date.isoformat()
                slots_data[date_str] = slot.time_slots or {}

            return jsonify(slots_data)

        except Exception as e:
            logger.error(f"Database error: {str(e)}")
            logger.error(traceback.format_exc())
            return jsonify({'message': f'Database error: {str(e)}'}), 500

    except Exception as e:
        logger.error(f"General error: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({'message': f'Error fetching time slots: {str(e)}'}), 500
    
@app.route('/api/flutter/doctor-slots', methods=['POST'])
def add_doctor_slots_flutter():
    try:
        data = request.json
        logger.debug(f"Received data for Flutter: {data}")
        
        doctor_id = data.get('doctorId')
        date = data.get('date')
        slots = data.get('availableSlots', [])

        if not all([doctor_id, date, slots]):
            return jsonify({
                'success': False,
                'message': 'Missing required fields'
            }), 400

        # Get doctor information
        doctor = db.session.get(User, doctor_id)
        if not doctor:
            return jsonify({
                'success': False,
                'message': 'Doctor not found'
            }), 404

        try:
            slot_date = datetime.strptime(date, '%Y-%m-%d').date()
        except ValueError as e:
            return jsonify({
                'success': False,
                'message': f'Invalid date format: {str(e)}'
            }), 400

        try:
            # Find existing slot record
            slot_record = DoctorTimeSlot.query.filter_by(
                doctor_id=doctor_id,
                date=slot_date
            ).first()

            slots_dict = {slot: True for slot in slots}
            
            if slot_record:
                logger.debug(f"Updating existing record for date {date}")
                slot_record.time_slots = slots_dict
            else:
                logger.debug(f"Creating new record for date {date}")
                slot_record = DoctorTimeSlot(
                    doctor_id=doctor_id,
                    doctor_name=doctor.name,
                    date=slot_date,
                    time_slots=slots_dict
                )
                db.session.add(slot_record)

            db.session.commit()
            
            # Prepare Flutter response format
            flutter_data = {
                'date': date,
                'doctorName': doctor.name,
                'availableSlots': slots,
                'doctorId': doctor_id
            }
            print( flutter_data)

            return jsonify({
                'success': True,
                'message': 'Time slots added successfully',
                'data': flutter_data
            })

        except Exception as e:
            db.session.rollback()
            logger.error(f"Database error in Flutter endpoint: {str(e)}")
            logger.error(traceback.format_exc())
            return jsonify({
                'success': False,
                'message': f'Database error: {str(e)}'
            }), 500

    except Exception as e:
        logger.error(f"General error in Flutter endpoint: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'success': False,
            'message': f'Error adding time slots: {str(e)}'
        }), 500

@app.route('/api/flutter/book-slot', methods=['POST'])
def book_slot_flutter():
    try:
        data = request.json
        doctor_id = data.get('doctorId')
        date = data.get('date')
        slot_time = data.get('slotTime')

        if not all([doctor_id, date, slot_time]):
            return jsonify({
                'success': False,
                'message': 'Missing required fields'
            }), 400

        try:
            slot_date = datetime.strptime(date, '%Y-%m-%d').date()
            slot_record = DoctorTimeSlot.query.filter_by(
                doctor_id=doctor_id,
                date=slot_date
            ).first()

            if not slot_record:
                return jsonify({
                    'success': False,
                    'message': 'No slots available for this date'
                }), 404

            if not slot_record.time_slots.get(slot_time, False):
                return jsonify({
                    'success': False,
                    'message': 'Selected time slot is not available'
                }), 400

            # Mark the slot as booked (False)
            slot_record.time_slots[slot_time] = False
            db.session.commit()

            # Emit socket event for real-time updates
            socketio.emit('slot_booked', {
                'doctor_id': doctor_id,
                'date': date,
                'slot': slot_time
            })

            return jsonify({
                'success': True,
                'message': 'Slot booked successfully',
                'data': {
                    'doctorId': doctor_id,
                    'doctorName': slot_record.doctor_name,
                    'date': date,
                    'slot': slot_time
                }
            })

        except Exception as e:
            db.session.rollback()
            logger.error(f"Database error in Flutter booking: {str(e)}")
            logger.error(traceback.format_exc())
            return jsonify({
                'success': False,
                'message': f'Database error: {str(e)}'
            }), 500

    except Exception as e:
        logger.error(f"General error in Flutter booking: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'success': False,
            'message': f'Error booking slot: {str(e)}'
        }), 500

def init_db():
    with app.app_context():
        try:
            DoctorTimeSlot.__table__.drop(db.engine, checkfirst=True)
            logger.info("Dropped existing doctor_time_slots table")
        except Exception as e:
            logger.error(f"Error dropping table: {str(e)}")
        
        try:
            db.create_all()
            logger.info("Created all database tables")
        except Exception as e:
            logger.error(f"Error creating tables: {str(e)}")

@app.route('/api/medicines', methods=['GET'])
def get_medicines():
    try:
        doctor_id = request.args.get('doctorId')
        
        if not doctor_id or doctor_id == 'undefined' or doctor_id == 'null':
            return jsonify({
                'success': False,
                'message': 'Valid Doctor ID is required'
            }), 400

        try:
            doctor_id = int(doctor_id)
        except ValueError:
            return jsonify({
                'success': False,
                'message': 'Invalid doctor ID format'
            }), 400

        medicines = Medicine.query.filter_by(doctor_id=doctor_id).all()
        
        medicines_list = [{
            'id': medicine.id,
            'name': medicine.name,
            'doctorId': medicine.doctor_id
        } for medicine in medicines]

        return jsonify({
            'success': True,
            'data': medicines_list
        })

    except Exception as e:
        logger.error(f"Error fetching medicines: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error fetching medicines: {str(e)}'
        }), 500

@app.route('/api/medicines', methods=['POST'])
def add_medicine():
    try:
        data = request.json
        doctor_id = data.get('doctorId')
        medicine_name = data.get('medicineName')

        if not all([doctor_id, medicine_name]) or doctor_id == 'undefined' or doctor_id == 'null':
            return jsonify({
                'success': False,
                'message': 'Valid doctor ID and medicine name are required'
            }), 400

        try:
            doctor_id = int(doctor_id)
        except ValueError:
            return jsonify({
                'success': False,
                'message': 'Invalid doctor ID format'
            }), 400

        # Check if medicine already exists for this doctor
        existing_medicine = Medicine.query.filter_by(
            name=medicine_name,
            doctor_id=doctor_id
        ).first()

        if existing_medicine:
            return jsonify({
                'success': False,
                'message': 'Medicine already exists'
            }), 403

        new_medicine = Medicine(
            name=medicine_name,
            doctor_id=doctor_id
        )
        
        db.session.add(new_medicine)
        db.session.commit()

        return jsonify({
            'success': True,
            'message': 'Medicine added successfully',
            'data': {
                'id': new_medicine.id,
                'name': new_medicine.name,
                'doctorId': new_medicine.doctor_id
            }
        })

    except Exception as e:
        db.session.rollback()
        logger.error(f"Error adding medicine: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error adding medicine: {str(e)}'
        }), 500
@app.route('/api/medicines/search', methods=['GET'])
def search_medicines():
    try:
        query = request.args.get('query', '').lower()
        doctor_id = request.args.get('doctorId')

        if not doctor_id:
            return jsonify({
                'success': False,
                'message': 'Doctor ID is required'
            }), 400

        medicines = Medicine.query.filter(
            db.and_(
                Medicine.doctor_id == doctor_id,
                Medicine.name.ilike(f'%{query}%')
            )
        ).all()

        medicines_list = [medicine.name for medicine in medicines]

        return jsonify({
            'success': True,
            'data': medicines_list
        })

    except Exception as e:
        logger.error(f"Error searching medicines: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error searching medicines: {str(e)}'
        }), 500
        

@app.route('/api/prescriptions', methods=['POST'])
def create_prescription():
    try:
        data = request.json
        
        # Generate PDF
        pdf_buffer = BytesIO()
        generate_prescription_pdf(pdf_buffer, data)
        pdf_data = pdf_buffer.getvalue()
        
        # Create prescription record
        new_prescription = Prescription(
            date=datetime.strptime(data['date'], '%Y-%m-%d').date(),
            medications=data['medications'],
            remarks=data.get('remarks'),
            next_appointment=datetime.strptime(data['nextAppointment'], '%Y-%m-%dT%H:%M:%S.%fZ') if data.get('nextAppointment') else None,
            next_appointment_time=datetime.strptime(data['nextAppointmentTime'], '%H:%M').time() if data.get('nextAppointmentTime') else None,
            doctor_id=data['doctorId'],
            patient_id=data['patientId'],
            pdf_data=pdf_data
        )
        
        db.session.add(new_prescription)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Prescription created successfully',
            'data': {
                'prescriptionId': new_prescription.id,
                'pdfUrl': f'/api/prescriptions/{new_prescription.id}/pdf'
            }
        }), 201
        
    except Exception as e:
        print(f"Error creating prescription: {str(e)}")
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': 'Failed to create prescription',
            'error': str(e)
        }), 500

@app.route('/api/prescriptions/<int:prescription_id>/pdf', methods=['GET'])
def get_prescription_pdf(prescription_id):
    try:
        prescription = Prescription.query.get_or_404(prescription_id)
        
        return send_file(
            BytesIO(prescription.pdf_data),
            mimetype='application/pdf',
            as_attachment=False,
            download_name=f'prescription_{prescription_id}.pdf'
        )
        
    except Exception as e:
        print(f"Error serving PDF: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'Error serving PDF',
            'error': str(e)
        }), 500

def generate_prescription_pdf(buffer, data):
    c = canvas.Canvas(buffer, pagesize=letter)
    width, height = letter
    
    # Header
    c.setFont('Helvetica-Bold', 20)
    c.drawString(width/2 - 100, height - 50, 'Medical Prescription')
    
    # Patient Details
    c.setFont('Helvetica', 12)
    c.drawString(50, height - 100, f"Patient Name: {data['patientName']}")
    c.drawString(50, height - 120, f"Age: {data['patientAge']}")
    c.drawString(50, height - 140, f"Gender: {data['patientGender']}")
    c.drawString(50, height - 160, f"Date: {data['date']}")
    
    # Medications
    y_position = height - 200
    c.setFont('Helvetica-Bold', 14)
    c.drawString(50, y_position, 'Medications:')
    c.setFont('Helvetica', 12)
    
    for i, med in enumerate(data['medications'], 1):
        y_position -= 20
        c.drawString(70, y_position, f"{i}. {med['medicine']}")
        y_position -= 15
        c.drawString(90, y_position, f"Dosage: {med['dosage']}")
        y_position -= 15
        timing = []
        if med['morning']: timing.append('Morning')
        if med['afternoon']: timing.append('Afternoon')
        if med['night']: timing.append('Night')
        c.drawString(90, y_position, f"Timing: {', '.join(timing)}")
        y_position -= 15
        c.drawString(90, y_position, f"Duration: {med['duration']}")
        y_position -= 15
        c.drawString(90, y_position, f"Instructions: {med['timing']}")
        y_position -= 20
    
    # Remarks
    if data.get('remarks'):
        y_position -= 20
        c.setFont('Helvetica-Bold', 14)
        c.drawString(50, y_position, 'Remarks:')
        c.setFont('Helvetica', 12)
        y_position -= 20
        c.drawString(70, y_position, data['remarks'])
    
    # Next Appointment
    if data.get('nextAppointment'):
        y_position -= 40
        c.drawString(50, y_position, f"Next Appointment: {data['nextAppointment']}")
    
    # Doctor's signature
    c.drawString(width - 200, 100, f"Dr. {data['doctorName']}")
    
    c.save()


@app.route('/api/prescriptions/patient/<int:patient_id>', methods=['GET'])
def get_patient_prescriptions(patient_id):
    try:
        prescriptions = Prescription.query.filter_by(patient_id=patient_id)\
            .order_by(Prescription.date.desc())\
            .all()
        
        prescription_list = [{
            'id': p.id,
            'date': p.date.isoformat(),
            'medications': p.medications,
            'remarks': p.remarks,
            'next_appointment': p.next_appointment.isoformat() if p.next_appointment else None,
            'doctor_name': User.query.get(p.doctor_id).name  # Assuming you have a User model for doctors
        } for p in prescriptions]
        
        return jsonify({
            'success': True,
            'prescriptions': prescription_list
        })
        
    except Exception as e:
        print(f"Error fetching prescriptions: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'Failed to fetch prescriptions',
            'error': str(e)
        }), 500
        
@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.json
        hashed_password = generate_password_hash(data['password'], method='pbkdf2:sha256')
        
        new_user = User(
            name=data.get('name'),
            email=data.get('email'),
            password=hashed_password
        )
        
        db.session.add(new_user)
        db.session.commit()
        
        return jsonify({
            'message': 'User registered successfully',
            'user': {
                'id': new_user.id,
                'name': new_user.name,
                'email': new_user.email
            }
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
    


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)
