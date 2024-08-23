// // PatientList.jsx
// import React, { useState, useEffect } from 'react';
// import { useAuth } from './authcontext';
// import "../styles/patientlist.css";

// function PatientList() {
//   const [patients, setPatients] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const { userName } = useAuth();

//   useEffect(() => {
//     fetchPatients();
//   }, []);

//   const fetchPatients = async () => {
//     try {
//       const response = await fetch('http://localhost:5000/get-patient-data');
//       if (!response.ok) {
//         throw new Error('Failed to fetch patient data');
//       }
//       const data = await response.json();
//       const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);
//       setPatients(filteredPatients.map(patient => ({...patient, consulted: false})));
//       setLoading(false);
//     } catch (err) {
//       console.error('Error fetching patient data:', err);
//       setError('Failed to load patient data. Please try again later.');
//       setLoading(false);
//     }
//   };

//   const handleConsultedChange = (index) => {
//     if (window.confirm('Are you sure you want to mark this patient as consulted?')) {
//       setPatients(prevPatients => {
//         const newPatients = [...prevPatients];
//         newPatients[index] = {...newPatients[index], consulted: !newPatients[index].consulted};
//         return newPatients;
//       });
//     }
//   };

//   if (loading) {
//     return <div className="patient-list-loading">Loading patient data...</div>;
//   }

//   if (error) {
//     return <div className="patient-list-error">{error}</div>;
//   }

//   return (
//     <div className="patient-list-container">
//       <h2 className="patient-list-title">Your Patients</h2>
//       {patients.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="patient-grid">
//           {patients.map((patient, index) => (
//             <div key={index} className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
//               <div className="patient-info">
//                 <h3 className="patient-name">{patient.name}</h3>
//                 <div className="patient-details">
//                   <p><strong>Age:</strong> {patient.age}</p>
//                   <p><strong>Gender:</strong> {patient.gender}</p>
//                   <p><strong>Reporting Time:</strong> {patient.reporting_time}</p>
//                 </div>
//               </div>
//               <div className="patient-actions">
//                 {patient.patient_history_url && (
//                   <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                     Patient History
//                   </a>
//                 )}
//                 {patient.lab_report_url && (
//                   <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                     Lab Report
//                   </a>
//                 )}
//                 <div className="consulted-checkbox">
//                   <label>
//                     <input 
//                       type="checkbox" 
//                       checked={patient.consulted} 
//                       onChange={() => handleConsultedChange(index)}
//                     />
//                     Consulted
//                   </label>
//                 </div>
//               </div>
//             </div>
//           ))}
//         </div>
//       )}
//     </div>
//   );
// }
import React, { useState, useEffect, useRef } from 'react';
import { useAuth } from './authcontext';
import "../styles/patientlist.css";

function PatientList() {
  const [patientsByDate, setPatientsByDate] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { userName } = useAuth();
  const todaySectionRef = useRef(null);

  useEffect(() => {
    fetchPatients();
  }, []);

  const fetchPatients = async () => {
    try {
      const response = await fetch('http://localhost:5000/get-patient-data');
      if (!response.ok) {
        throw new Error('Failed to fetch patient data');
      }
      const data = await response.json();
      const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);
      
      // Group patients by date
      const groupedPatients = filteredPatients.reduce((acc, patient) => {
        const date = new Date(patient.reporting_time).toLocaleDateString();
        if (!acc[date]) {
          acc[date] = [];
        }
        acc[date].push({...patient, consulted: false});
        return acc;
      }, {});

      setPatientsByDate(groupedPatients);
      setLoading(false);
    } catch (err) {
      console.error('Error fetching patient data:', err);
      setError('Failed to load patient data. Please try again later.');
      setLoading(false);
    }
  };

  const handleConsultedChange = (date, index) => {
    if (window.confirm('Are you sure you want to mark this patient as consulted?')) {
      setPatientsByDate(prevPatients => {
        const newPatients = {...prevPatients};
        newPatients[date][index].consulted = !newPatients[date][index].consulted;
        return newPatients;
      });
    }
  };

  useEffect(() => {
    if (todaySectionRef.current) {
      todaySectionRef.current.scrollIntoView({ behavior: 'auto' });
    }
  }, [patientsByDate]);

  if (loading) {
    return <div className="patient-list-loading">Loading patient data...</div>;
  }

  if (error) {
    return <div className="patient-list-error">{error}</div>;
  }

  const today = new Date().toLocaleDateString();
  const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(b) - new Date(a));
  const pastDates = sortedDates.filter(date => date !== today);
  const hasToday = sortedDates.includes(today);

  return (
    <div className="patient-list-container">
      <h2 className="patient-list-title">Your Patients</h2>
      {sortedDates.length === 0 ? (
        <p className="no-patients">No patients scheduled for checkup.</p>
      ) : (
        <div className="date-sections">
          <div className="past-dates">
            {pastDates.map(date => (
              <DateSection 
                key={date} 
                date={date} 
                patients={patientsByDate[date]} 
                handleConsultedChange={handleConsultedChange} 
              />
            ))}
          </div>
          {hasToday && (
            <div ref={todaySectionRef}>
              <DateSection 
                key={today} 
                date={today} 
                patients={patientsByDate[today]} 
                handleConsultedChange={handleConsultedChange} 
                isToday={true}
              />
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function DateSection({ date, patients, handleConsultedChange, isToday = false }) {
  return (
    <div className="date-section">
      <h3 className="date-header">{isToday ? 'Today' : date}</h3>
      <div className="patient-grid">
        {patients.map((patient, index) => (
          <div key={index} className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
            <div className="patient-info">
              <h3 className="patient-name">{patient.name}</h3>
              <div className="patient-details">
                <p><strong>Age:</strong> {patient.age}</p>
                <p><strong>Gender:</strong> {patient.gender}</p>
                <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleTimeString()}</p>
              </div>
            </div>
            <div className="patient-actions">
              {patient.patient_history_url && (
                <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
                  Patient History
                </a>
              )}
              {patient.lab_report_url && (
                <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
                  Lab Report
                </a>
              )}
              <div className="consulted-checkbox">
                <label>
                  <input 
                    type="checkbox" 
                    checked={patient.consulted} 
                    onChange={() => handleConsultedChange(date, index)}
                  />
                  Consulted
                </label>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default PatientList;