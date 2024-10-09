from flask import Flask, jsonify, request
import firebase_admin
from firebase_admin import credentials, firestore
import requests

app = Flask(__name__)

# Initialize Firebase
cred = credentials.Certificate('aarogya-bf729-firebase-adminsdk-mmk2s-37dc4ac1c9.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

# Function to calculate travel time using OpenStreetMap API
def calculate_travel_time(origin, destination):
    open_street_map_url = f"https://api.openrouteservice.org/v2/directions/driving-car"
    api_key = 'apikey'
    headers = {'Authorization': api_key, 'Content-Type': 'application/json'}
    
    data = {
        "coordinates": [origin, destination],
        "instructions": "false"
    }
    
    response = requests.post(open_street_map_url, json=data, headers=headers)
    
    if response.status_code == 200:
        route_info = response.json()
        # Extract duration in minutes from the response
        duration = route_info['routes'][0]['summary']['duration'] / 60
        return int(duration)
    else:
        return None

# Endpoint to update current appointment and notify the next set of patients
@app.route('/update_appointment', methods=['POST'])
def update_appointment():
    data = request.json
    current_appointment_id = data.get('current_appointment_id')
    
    # Update the current appointment's status
    appointment_ref = db.collection('appointments').document(current_appointment_id)
    appointment_ref.update({'status': 'checked_in'})

    # Query upcoming appointments to notify patients
    upcoming_appointments = db.collection('appointments').where('status', '==', 'upcoming').get()
    notifications_sent = []
    
    for appointment in upcoming_appointments:
        appointment_data = appointment.to_dict()
        user_id = appointment_data['userId']
        
        # Assuming the origin (patient's location) and destination (hospital) are provided
        travel_time = calculate_travel_time(origin=[8.5241, 76.9366], destination=[8.4867, 76.9487])  # Example coordinates
        
        # Update the travel time in the appointment document
        db.collection('appointments').document(appointment.id).update({'travelTimeToHospital': travel_time})
        
        # Notify patient to leave home if travel time is within 15 minutes
        if travel_time <= 15:
            # Logic to send notification (e.g., using Firebase Cloud Messaging)
            notifications_sent.append(user_id)
    
    return jsonify({'message': 'Appointment updated and notifications sent', 'notifications': notifications_sent})

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
