from flask import Flask, jsonify
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Flask app
app = Flask(__name__)

# Path to your Firebase service account JSON file
service_account_path = "aarogya-bf729-firebase-adminsdk-mmk2s-f64754ae83.json"

# Initialize Firebase Admin SDK
cred = credentials.Certificate(service_account_path)
firebase_admin.initialize_app(cred)

# Initialize Firestore (or use Firebase Realtime Database)
db = firestore.client()

@app.route('/users', methods=['GET'])
def get_users():
    try:
        users_ref = db.collection('users')  # Replace with your Firestore collection
        docs = users_ref.stream()
        
        users = []
        for doc in docs:
            users.append(doc.to_dict())
        
        return jsonify(users), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
