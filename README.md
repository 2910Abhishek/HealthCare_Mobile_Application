
<h1 align="center">Smart Healthcare Appointment Application</h1>

<p align="center">
  <b>A comprehensive healthcare solution to streamline appointments, reduce waiting times, and enhance overall healthcare management.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Flutter-green">
  <img src="https://img.shields.io/badge/Backend-Flask-blue">
  <img src="https://img.shields.io/badge/Database-Firebase-orange">
  <img src="https://img.shields.io/badge/Database-PostgreSQL-blue">
  <img src="https://img.shields.io/badge/License-MIT-brightgreen">
</p>

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Installation and Setup](#installation-and-setup)
  - [Frontend (Doctor React App)](#frontend-doctor-react-app)
  - [Backend](#backend)
  - [Aarogya (Flutter App)](#aarogya-flutter-app)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## 🌐 Project Overview
The **Smart Healthcare Appointment Application** aims to revolutionize healthcare experiences by simplifying appointment bookings, minimizing patient wait times, and enhancing healthcare management. This application addresses the shortcomings of traditional healthcare systems by utilizing modern technologies to improve both patient and doctor experiences.

---

## ✨ Features
- **Streamlined Appointment Booking**: Effortlessly book doctor appointments through a user-friendly interface.
- **Real-time Notifications**: Receive alerts when it's time to leave for your appointment, reducing waiting times.
- **Lab Report Uploads**: Upload lab reports prior to appointments for doctors to review in advance.
- **Health Monitoring**: Track and analyze trends in diabetes and blood pressure over time.
- **User-friendly Design**: Simple, intuitive interface accessible to users of all ages.
- **Secure Data Handling**: Guarantees confidentiality and integrity of health records and personal data.
- **Timely Reminders**: Automated reminders for upcoming appointments and medication schedules.
- **Enhanced Patient Care**: Supports better health outcomes through proactive monitoring and timely interventions.

---

## 🛠️ Technology Stack


| **Component**       | **Technology**                                                                                 |
|---------------------|------------------------------------------------------------------------------------------------|
| **Frontend**        | <img src="https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB">  |
| **Backend**         | <img src="https://img.shields.io/badge/Python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54"> <img src="https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white"> |
| **Database**        | <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white"> <img src="https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white">  |
| **Mobile App**      | <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"> |
| **Authentication**  | Phone-based Authentication                                                                     |
| **Notifications**   | Firebase Cloud Messaging (FCM)                                                                 |
| **Version Control** | Git, GitHub                                                                                    |
| **Editors**         | Visual Studio Code, Android Studio                                                             |
| **Design**          | Figma, Adobe XD                                                                                |

---

## 🚀 Installation and Setup
### Frontend (Doctor React App)
```bash
# Navigate to the frontend folder
cd frontend

# Install dependencies
npm install

# Start the development server
npm run dev
```

### Backend
```bash
# Navigate to the backend folder
cd backend

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install required dependencies
pip install -r requirements.txt

# Run the backend server
python login.py
```

### Aarogya (Flutter App)
```bash
# Navigate to the aarogya folder
cd aarogya

# Install necessary packages
flutter pub get

# Update IP address in lib/screens/constants.dart
# Replace ipv4Address with your device's IPv4 address

# Start the Flutter app
flutter run
```

## 🤝 Contributing
Contributions to the Smart Healthcare Appointment Application are welcome! If you have suggestions, bug fixes, or improvements, please submit a pull request or open an issue.

## 📜 License
This project is licensed under the MIT License. See the LICENSE file for details.


