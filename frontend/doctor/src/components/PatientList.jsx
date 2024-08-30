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

// import React, { useState, useEffect, useRef } from 'react';
// import { useAuth } from './authcontext';
// import "../styles/patientlist.css";

// function PatientList() {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const { userName } = useAuth();
//   const todaySectionRef = useRef(null);

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
      
//       // Group patients by date
//       const groupedPatients = filteredPatients.reduce((acc, patient) => {
//         const date = new Date(patient.reporting_time).toLocaleDateString();
//         if (!acc[date]) {
//           acc[date] = [];
//         }
//         acc[date].push({...patient, consulted: false});
//         return acc;
//       }, {});

//       setPatientsByDate(groupedPatients);
//       setLoading(false);
//     } catch (err) {
//       console.error('Error fetching patient data:', err);
//       setError('Failed to load patient data. Please try again later.');
//       setLoading(false);
//     }
//   };

//   const handleConsultedChange = (date, index) => {
//     if (window.confirm('Are you sure you want to mark this patient as consulted?')) {
//       setPatientsByDate(prevPatients => {
//         const newPatients = {...prevPatients};
//         newPatients[date][index].consulted = !newPatients[date][index].consulted;
//         return newPatients;
//       });
//     }
//   };

//   useEffect(() => {
//     if (todaySectionRef.current) {
//       todaySectionRef.current.scrollIntoView({ behavior: 'auto' });
//     }
//   }, [patientsByDate]);

//   if (loading) {
//     return <div className="patient-list-loading">Loading patient data...</div>;
//   }

//   if (error) {
//     return <div className="patient-list-error">{error}</div>;
//   }

//   const today = new Date().toLocaleDateString();
//   const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(b) - new Date(a));
//   const pastDates = sortedDates.filter(date => date !== today);
//   const hasToday = sortedDates.includes(today);

//   return (
//     <div className="patient-list-container">
//       <h2 className="patient-list-title">Your Patients</h2>
//       {sortedDates.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="date-sections">
//           <div className="past-dates">
//             {pastDates.map(date => (
//               <DateSection 
//                 key={date} 
//                 date={date} 
//                 patients={patientsByDate[date]} 
//                 handleConsultedChange={handleConsultedChange} 
//               />
//             ))}
//           </div>
//           {hasToday && (
//             <div ref={todaySectionRef}>
//               <DateSection 
//                 key={today} 
//                 date={today} 
//                 patients={patientsByDate[today]} 
//                 handleConsultedChange={handleConsultedChange} 
//                 isToday={true}
//               />
//             </div>
//           )}
//         </div>
//       )}
//     </div>
//   );
// }

// function DateSection({ date, patients, handleConsultedChange, isToday = false }) {
//   return (
//     <div className="date-section">
//       <h3 className="date-header">{isToday ? 'Today' : date}</h3>
//       <div className="patient-grid">
//         {patients.map((patient, index) => (
//           <div key={index} className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
//             <div className="patient-info">
//               <h3 className="patient-name">{patient.name}</h3>
//               <div className="patient-details">
//                 <p><strong>Age:</strong> {patient.age}</p>
//                 <p><strong>Gender:</strong> {patient.gender}</p>
//                 <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleTimeString()}</p>
//               </div>
//             </div>
//             <div className="patient-actions">
//               {patient.patient_history_url && (
//                 <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                   Patient History
//                 </a>
//               )}
//               {patient.lab_report_url && (
//                 <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                   Lab Report
//                 </a>
//               )}
//               <div className="consulted-checkbox">
//                 <label>
//                   <input 
//                     type="checkbox" 
//                     checked={patient.consulted} 
//                     onChange={() => handleConsultedChange(date, index)}
//                   />
//                   Consulted
//                 </label>
//               </div>
//             </div>
//           </div>
//         ))}
//       </div>
//     </div>
//   );
// }

// export default PatientList;

// import React, { useState, useEffect, useRef } from 'react';
// import { useAuth } from './authcontext';
// import "../styles/patientlist.css";

// function PatientList() {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const { userName } = useAuth();
//   const todaySectionRef = useRef(null);
//   const containerRef = useRef(null);

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
      
//       const groupedPatients = filteredPatients.reduce((acc, patient) => {
//         const date = new Date(patient.reporting_time).toLocaleDateString();
//         if (!acc[date]) {
//           acc[date] = [];
//         }
//         acc[date].push({...patient, consulted: false});
//         return acc;
//       }, {});

//       setPatientsByDate(groupedPatients);
//       setLoading(false);
//     } catch (err) {
//       console.error('Error fetching patient data:', err);
//       setError('Failed to load patient data. Please try again later.');
//       setLoading(false);
//     }
//   };

//   const handleConsultedChange = (date, index) => {
//     setPatientsByDate(prevPatients => {
//       const newPatients = {...prevPatients};
//       newPatients[date] = newPatients[date].map((patient, i) => 
//         i === index ? {...patient, consulted: !patient.consulted} : patient
//       );
//       return newPatients;
//     });
//   };

//   useEffect(() => {
//     if (todaySectionRef.current) {
//       todaySectionRef.current.scrollIntoView({ behavior: 'auto', block: 'start' });
//     }
//   }, [patientsByDate]);

//   if (loading) {
//     return <div className="patient-list-loading">Loading patient data...</div>;
//   }

//   if (error) {
//     return <div className="patient-list-error">{error}</div>;
//   }

//   const today = new Date().toLocaleDateString();
//   const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(a) - new Date(b));
//   const pastDates = sortedDates.filter(date => new Date(date) < new Date(today));
//   const futureDates = sortedDates.filter(date => new Date(date) > new Date(today));

//   return (
//     <div className="patient-list-container" ref={containerRef}>
//       {sortedDates.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="date-sections">
//           <div className="past-dates">
//             {pastDates.map(date => (
//               <DateSection 
//                 key={date} 
//                 date={date} 
//                 patients={patientsByDate[date]} 
//                 handleConsultedChange={handleConsultedChange} 
//               />
//             ))}
//           </div>
//           <div ref={todaySectionRef}>
//             <DateSection 
//               key={today} 
//               date={today} 
//               patients={patientsByDate[today] || []} 
//               handleConsultedChange={handleConsultedChange} 
//               isToday={true}
//             />
//           </div>
//           <div className="future-dates">
//             {futureDates.map(date => (
//               <DateSection 
//                 key={date} 
//                 date={date} 
//                 patients={patientsByDate[date]} 
//                 handleConsultedChange={handleConsultedChange} 
//               />
//             ))}
//           </div>
//         </div>
//       )}
//     </div>
//   );
// }

// function DateSection({ date, patients, handleConsultedChange, isToday = false }) {
//   if (!patients || patients.length === 0) return null;

//   return (
//     <div className={`date-section ${isToday ? 'today' : ''}`}>
//       <h3 className="date-header">{isToday ? 'Today' : date}</h3>
//       <div className="patient-grid">
//         {patients.map((patient, index) => (
//           <div key={index} className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
//             <div className="patient-info">
//               <h3 className="patient-name">{patient.name}</h3>
//               <div className="patient-details">
//                 <p><strong>Age:</strong> {patient.age}</p>
//                 <p><strong>Gender:</strong> {patient.gender}</p>
//                 <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleTimeString()}</p>
//               </div>
//             </div>
//             <div className="patient-actions">
//               {patient.patient_history_url && (
//                 <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                   Patient History
//                 </a>
//               )}
//               {patient.lab_report_url && (
//                 <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                   Lab Report
//                 </a>
//               )}
//               <div className="consulted-checkbox">
//                 <label>
//                   <input 
//                     type="checkbox" 
//                     checked={patient.consulted} 
//                     onChange={() => handleConsultedChange(date, index)}
//                   />
//                   Consulted
//                 </label>
//               </div>
//             </div>
//           </div>
//         ))}
//       </div>
//     </div>
//   );
// }

// export default PatientList;


// import React, { useState, useEffect, useRef } from 'react';
// import { useAuth } from './authcontext';
// import "../styles/patientlist.css";

// const PatientList = () => {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const { userName } = useAuth();
//   const todaySectionRef = useRef(null);
//   const containerRef = useRef(null);

//   useEffect(() => {
//     fetchPatients();
//   }, []);

//   useEffect(() => {
//     if (todaySectionRef.current) {
//       todaySectionRef.current.scrollIntoView({ behavior: 'auto', block: 'start' });
//     }
//   }, [patientsByDate]);

//   const fetchPatients = async () => {
//     try {
//       const response = await fetch('http://localhost:5000/get-patient-data');
//       if (!response.ok) {
//         throw new Error('Failed to fetch patient data');
//       }
//       const data = await response.json();
//       const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);
      
//       const groupedPatients = filteredPatients.reduce((acc, patient) => {
//         const date = new Date(patient.reporting_time).toLocaleDateString();
//         if (!acc[date]) {
//           acc[date] = [];
//         }
//         acc[date].push({...patient, consulted: false});
//         return acc;
//       }, {});

//       setPatientsByDate(groupedPatients);
//       setLoading(false);
//     } catch (err) {
//       console.error('Error fetching patient data:', err);
//       setError('Failed to load patient data. Please try again later.');
//       setLoading(false);
//     }
//   };

//   const handleConsultedChange = (date, index) => {
//     setPatientsByDate(prevPatients => {
//       const newPatients = {...prevPatients};
//       newPatients[date] = newPatients[date].map((patient, i) => 
//         i === index ? {...patient, consulted: !patient.consulted} : patient
//       );
//       return newPatients;
//     });
//   };

//   if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
//   if (error) return <div className="patient-list-error">{error}</div>;

//   const today = new Date().toLocaleDateString();
//   const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(a) - new Date(b));
//   const pastDates = sortedDates.filter(date => new Date(date) < new Date(today));
//   const futureDates = sortedDates.filter(date => new Date(date) > new Date(today));

//   return (
//     <div className="patient-list-container" ref={containerRef}>
//       {sortedDates.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="date-sections">
//           <DateSection dates={pastDates} patientsByDate={patientsByDate} handleConsultedChange={handleConsultedChange} />
//           <div ref={todaySectionRef}>
//             <DateSection 
//               dates={[today]} 
//               patientsByDate={patientsByDate} 
//               handleConsultedChange={handleConsultedChange} 
//               isToday={true}
//             />
//           </div>
//           <DateSection dates={futureDates} patientsByDate={patientsByDate} handleConsultedChange={handleConsultedChange} />
//         </div>
//       )}
//     </div>
//   );
// }

// const DateSection = ({ dates, patientsByDate, handleConsultedChange, isToday = false }) => {
//   return dates.map(date => {
//     const patients = patientsByDate[date];
//     if (!patients || patients.length === 0) return null;

//     return (
//       <div key={date} className={`date-section ${isToday ? 'today' : ''}`}>
//         <h3 className="date-header">{isToday ? 'Today' : date}</h3>
//         <div className="patient-grid">
//           {patients.map((patient, index) => (
//             <PatientCard 
//               key={index} 
//               patient={patient} 
//               handleConsultedChange={() => handleConsultedChange(date, index)} 
//             />
//           ))}
//         </div>
//       </div>
//     );
//   });
// }

// const PatientCard = ({ patient, handleConsultedChange }) => (
//   <div className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
//     <div className="patient-info">
//       <h3 className="patient-name">{patient.name}</h3>
//       <div className="patient-details">
//         <p><strong>Age:</strong> {patient.age}</p>
//         <p><strong>Gender:</strong> {patient.gender}</p>
//         <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleTimeString()}</p>
//       </div>
//     </div>
//     <div className="patient-actions">
//       {patient.patient_history_url && (
//         <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//           Patient History
//         </a>
//       )}
//       {patient.lab_report_url && (
//         <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//           Lab Report
//         </a>
//       )}
      
//       <div className="consulted-checkbox">
//         <label>
//           <input 
//             type="checkbox" 
//             checked={patient.consulted} 
//             onChange={handleConsultedChange}
//           />
//           Consulted
//         </label>
//       </div>
//     </div>
//   </div>
// );

// export default PatientList;

import React, { useState, useEffect, useRef } from 'react';
import { useAuth } from './authcontext';
import { io } from 'socket.io-client';
import "../styles/patientlist.css";

const PatientList = () => {
  const [patientsByDate, setPatientsByDate] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { userName } = useAuth();
  const todaySectionRef = useRef(null);
  const containerRef = useRef(null);
  const socket = useRef(null);

  useEffect(() => {
    fetchPatients();

    socket.current = io('http://localhost:5000');
    
    socket.current.on('new_patient', (newPatient) => {
      if (newPatient.assigned_doctor === userName) {
        setPatientsByDate(prevPatients => {
          const date = new Date(newPatient.reporting_time).toLocaleDateString();
          const newPatients = { ...prevPatients };
          if (!newPatients[date]) {
            newPatients[date] = [];
          }
          newPatients[date].push({ ...newPatient, consulted: false });
          return newPatients;
        });
      }
    });

    return () => {
      if (socket.current) {
        socket.current.disconnect();
      }
    };
  }, [userName]);

  useEffect(() => {
    if (todaySectionRef.current) {
      todaySectionRef.current.scrollIntoView({ behavior: 'auto', block: 'start' });
    }
  }, [patientsByDate]);

  const fetchPatients = async () => {
    try {
      const response = await fetch('http://localhost:5000/get-patient-data');
      if (!response.ok) {
        throw new Error('Failed to fetch patient data');
      }
      const data = await response.json();
      const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);

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
    setPatientsByDate(prevPatients => {
      const newPatients = {...prevPatients};
      if (newPatients[date] && newPatients[date][index]) {
        newPatients[date] = newPatients[date].map((patient, i) => 
          i === index ? {...patient, consulted: !patient.consulted} : patient
        );
      }
      return newPatients;
    });
  };

  if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
  if (error) return <div className="patient-list-error">{error}</div>;

  const today = new Date().toLocaleDateString();
  const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(a) - new Date(b));
  const pastDates = sortedDates.filter(date => new Date(date) < new Date(today));
  const futureDates = sortedDates.filter(date => new Date(date) > new Date(today));

  return (
    <div className="patient-list-container" ref={containerRef}>
      {sortedDates.length === 0 ? (
        <p className="no-patients">No patients scheduled for checkup.</p>
      ) : (
        <div className="date-sections">
          <DateSection dates={pastDates} patientsByDate={patientsByDate} handleConsultedChange={handleConsultedChange} />
          <div ref={todaySectionRef}>
            <DateSection 
              dates={[today]} 
              patientsByDate={patientsByDate} 
              handleConsultedChange={handleConsultedChange} 
              isToday={true}
            />
          </div>
          <DateSection dates={futureDates} patientsByDate={patientsByDate} handleConsultedChange={handleConsultedChange} />
        </div>
      )}
    </div>
  );
}

const DateSection = ({ dates, patientsByDate, handleConsultedChange, isToday = false }) => {
  return dates.map(date => {
    const patients = patientsByDate[date] || [];
    return (
      <div key={date} className={`date-section ${isToday ? 'today' : ''}`}>
        <h2 className="date-header">{isToday ? 'Today' : date}</h2>
        <div className="patient-grid">
          {patients.length === 0 ? (
            <p>No patients scheduled for this date.</p>
          ) : (
            patients.map((patient, index) => (
              <div key={index} className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
                <div className="patient-info">
                  <h3 className="patient-name">{patient.name}</h3>
                  <div className="patient-details">
                    <p>Gender: {patient.gender}</p>
                    <p>Age: {patient.age}</p>
                    <p>Reporting Time: {patient.reporting_time}</p>
                  </div>
                </div>
                <div className="patient-actions">
                  {patient.patient_history_url && (
                    <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
                      View Patient History
                    </a>
                  )}
                  {patient.lab_report_url && (
                    <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
                      View Lab Report
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
            ))
          )}
        </div>
      </div>
    );
  });
};

export default PatientList;