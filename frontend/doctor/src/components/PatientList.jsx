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


// import React, { useState, useEffect, useRef } from 'react';
// import { useAuth } from './authcontext';
// import { io } from 'socket.io-client';
// import DatePicker from 'react-datepicker';
// import 'react-datepicker/dist/react-datepicker.css';
// import "../styles/patientlist.css";

// const PatientList = () => {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [selectedDate, setSelectedDate] = useState(null);
//   const { userName } = useAuth();
//   const containerRef = useRef(null);
//   const socket = useRef(null);

//   useEffect(() => {
//     fetchPatients();

//     socket.current = io('http://localhost:5000');
    
//     socket.current.on('new_patient', (newPatient) => {
//       if (newPatient.assigned_doctor === userName) {
//         setPatientsByDate(prevPatients => {
//           const date = new Date(newPatient.reporting_time).toLocaleDateString();
//           const newPatients = { ...prevPatients };
//           if (!newPatients[date]) {
//             newPatients[date] = [];
//           }
//           newPatients[date].push({ ...newPatient, consulted: false });
//           return newPatients;
//         });
//       }
//     });

//     return () => {
//       if (socket.current) {
//         socket.current.disconnect();
//       }
//     };
//   }, [userName]);

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
//       if (newPatients[date] && newPatients[date][index]) {
//         newPatients[date] = newPatients[date].map((patient, i) => 
//           i === index ? {...patient, consulted: !patient.consulted} : patient
//         );
//       }
//       return newPatients;
//     });
//   };

//   if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
//   if (error) return <div className="patient-list-error">{error}</div>;

//   const today = new Date().toLocaleDateString();
//   const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(a) - new Date(b));
//   const futureDates = sortedDates.filter(date => new Date(date) > new Date(today));

//   const displayDate = selectedDate ? selectedDate.toLocaleDateString() : today;

//   return (
//     <div className="patient-list-container" ref={containerRef}>
//       <div className="patient-list-header">
//         <h1>Patient Appointments</h1>
//         <div className="date-picker-container">
//           <DatePicker
//             selected={selectedDate}
//             onChange={date => setSelectedDate(date)}
//             maxDate={new Date()}
//             placeholderText="Select past date"
//             className="date-picker"
//             isClearable
//           />
//         </div>
//       </div>
//       {sortedDates.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="date-sections">
//           <DateSection
//             dates={[displayDate]}
//             patientsByDate={patientsByDate}
//             handleConsultedChange={handleConsultedChange}
//             isToday={displayDate === today}
//             isSelected={selectedDate !== null}
//           />
//           {futureDates.length > 0 && (
//             <div className="future-appointments">
//               <h2>Future Appointments</h2>
//               <DateSection 
//                 dates={futureDates} 
//                 patientsByDate={patientsByDate} 
//                 handleConsultedChange={handleConsultedChange} 
//               />
//             </div>
//           )}
//         </div>
//       )}
//     </div>
//   );
// }

// const DateSection = ({ dates, patientsByDate, handleConsultedChange, isToday = false, isSelected = false }) => {
//   return dates.map(date => {
//     const patients = patientsByDate[date] || [];
//     return (
//       <div key={date} className={`date-section ${isToday ? 'today' : ''} ${isSelected ? 'selected' : ''}`}>
//         <h2 className="date-header">
//           {isToday ? 'Today' : isSelected ? 'Selected Date' : new Date(date).toLocaleDateString()}
//         </h2>
//         <div className="patient-grid">
//           {patients.length === 0 ? (
//             <p className="no-patients-for-date">No patients scheduled for this date.</p>
//           ) : (
//             patients.map((patient, index) => (
//               <div key={index} className={`patient-card ${patient.consulted ? 'consulted' : ''}`}>
//                 <div className="patient-info">
//                   <h3 className="patient-name">{patient.name}</h3>
//                   <div className="patient-details">
//                     <p>Gender: {patient.gender}</p>
//                     <p>Age: {patient.age}</p>
//                     <p>Reporting Time: {new Date(patient.reporting_time).toLocaleTimeString()}</p>
//                   </div>
//                 </div>
//                 <div className="patient-actions">
//                   {patient.patient_history_url && (
//                     <a href={patient.patient_history_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                       View Patient History
//                     </a>
//                   )}
//                   {patient.lab_report_url && (
//                     <a href={patient.lab_report_url} target="_blank" rel="noopener noreferrer" className="patient-link">
//                       View Lab Report
//                     </a>
//                   )}
//                   <div className="consulted-checkbox">
//                     <label>
//                       <input
//                         type="checkbox"
//                         checked={patient.consulted}
//                         onChange={() => handleConsultedChange(date, index)}
//                       />
//                       Consulted
//                     </label>
//                   </div>
//                 </div>
//               </div>
//             ))
//           )}
//         </div>
//       </div>
//     );
//   });
// };

// export default PatientList;


// import React, { useState, useEffect, useRef } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { useAuth } from './authcontext';
// import { io } from 'socket.io-client';
// import DatePicker from 'react-datepicker';
// import 'react-datepicker/dist/react-datepicker.css';
// import "../styles/patientlist.css";

// const PatientList = () => {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [selectedDate, setSelectedDate] = useState(null);
//   const { userName } = useAuth();
//   const containerRef = useRef(null);
//   const socket = useRef(null);
//   const navigate = useNavigate();

//   useEffect(() => {
//     fetchPatients();

//     socket.current = io('http://localhost:5000', {
//       transports: ['websocket'],
//       upgrade: false
//     });
    
//     socket.current.on('new_patient', (newPatient) => {
//       if (newPatient.assigned_doctor === userName) {
//         setPatientsByDate(prevPatients => {
//           const date = new Date(newPatient.reporting_time).toLocaleDateString();
//           const newPatients = { ...prevPatients };

//           if (newPatients[date]?.some(patient => patient.id === newPatient.id)) {
//             return newPatients;
//           }

//           if (!newPatients[date]) {
//             newPatients[date] = [];
//           }
//           newPatients[date].push({ ...newPatient, consulted: false });
//           return newPatients;
//         });
//       }
//     });

//     return () => {
//       if (socket.current) {
//         socket.current.disconnect();
//       }
//     };
//   }, [userName]);

//   const fetchPatients = async () => {
//     try {
//       const response = await fetch('http://localhost:5000/get-patient-data');
//       if (!response.ok) {
//         throw new Error('Failed to fetch patient data');
//       }
//       const data = await response.json();
//       const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);

//       const storedConsultedStatus = JSON.parse(localStorage.getItem('consultedStatus') || '{}');

//       const groupedPatients = filteredPatients.reduce((acc, patient) => {
//         const date = new Date(patient.reporting_time).toLocaleDateString();
//         if (!acc[date]) {
//           acc[date] = [];
//         }
//         acc[date].push({
//           ...patient,
//           consulted: storedConsultedStatus[patient.id] || false
//         });
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

//   const handleConsultedChange = (event, date, index) => {
//     event.stopPropagation();
//     setPatientsByDate(prevPatients => {
//       const newPatients = JSON.parse(JSON.stringify(prevPatients));
//       if (newPatients[date] && newPatients[date][index]) {
//         const patient = newPatients[date][index];
//         patient.consulted = !patient.consulted;
        
//         const storedConsultedStatus = JSON.parse(localStorage.getItem('consultedStatus') || '{}');
//         storedConsultedStatus[patient.id] = patient.consulted;
//         localStorage.setItem('consultedStatus', JSON.stringify(storedConsultedStatus));
//       }
//       return newPatients;
//     });
//   };

//   const handlePatientClick = (patientId) => {
//     const selectedPatient = Object.values(patientsByDate)
//       .flat()
//       .find(patient => patient.id === patientId);
  
//     if (selectedPatient) {
//       navigate(`/patient/${patientId}`, { state: { patient: selectedPatient } });
//     } else {
//       console.error('Patient not found');
//     }
//   };

//   if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
//   if (error) return <div className="patient-list-error">{error}</div>;

//   const today = new Date().toLocaleDateString();
//   const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(a) - new Date(b));
//   const displayDate = selectedDate ? selectedDate.toLocaleDateString() : today;

//   return (
//     <div className="patient-list-container" ref={containerRef}>
//       <div className="patient-list-header">
//         <h1>Patient Appointments</h1>
//         <div className="date-picker-container">
//           <DatePicker
//             selected={selectedDate}
//             onChange={date => setSelectedDate(date)}
//             placeholderText="Select date"
//             className="date-picker"
//             isClearable
//           />
//         </div>
//       </div>
//       {sortedDates.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="date-sections">
//           <DateSection
//             dates={[displayDate]}
//             patientsByDate={patientsByDate}
//             handleConsultedChange={handleConsultedChange}
//             handlePatientClick={handlePatientClick}
//             isToday={displayDate === today}
//             isSelected={selectedDate !== null}
//           />
//         </div>
//       )}
//     </div>
//   );
// };

// const DateSection = ({ dates, patientsByDate, handleConsultedChange, handlePatientClick, isToday = false, isSelected = false }) => {
//   return dates.map(date => {
//     const patients = patientsByDate[date] || [];
//     const displayDate = new Date(date);
//     const isInFuture = displayDate > new Date();

//     return (
//       <div key={date} className={`date-section ${isToday ? 'today' : ''} ${isSelected ? 'selected' : ''} ${isInFuture ? 'future' : ''}`}>
//         <h2 className="date-header">
//           {isToday ? 'Today' : isSelected ? 'Selected Date' : displayDate.toLocaleDateString()}
//           {isInFuture && ' (Future Appointment)'}
//         </h2>
//         <div className="patient-grid">
//           {patients.length === 0 ? (
//             <p className="no-patients-for-date">No patients scheduled for this date.</p>
//           ) : (
//             patients.map((patient, index) => (
//               <div 
//                 key={patient.id} 
//                 className={`patient-card ${patient.consulted ? 'consulted' : ''}`}
//                 onClick={() => handlePatientClick(patient.id)}
//               >
//                 <div className="patient-info">
//                   <h3 className="patient-name">{patient.name}</h3>
//                   <div className="patient-details">
//                     <p>Gender: {patient.gender}</p>
//                     <p>Age: {patient.age}</p>
//                     <p>Reporting Time: {new Date(patient.reporting_time).toLocaleTimeString()}</p>
//                   </div>
//                 </div>
//                 <div className="patient-actions" onClick={(e) => e.stopPropagation()}>
//                   <div className="consulted-checkbox">
//                     <label>
//                       <input
//                         type="checkbox"
//                         checked={patient.consulted}
//                         onChange={(e) => handleConsultedChange(e, date, index)}
//                       />
//                       Consulted
//                     </label>
//                   </div>
//                 </div>
//               </div>
//             ))
//           )}
//         </div>
//       </div>
//     );
//   });
// };

// export default PatientList;

// import React, { useState, useEffect, useRef } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { useAuth } from './authcontext';
// import { io } from 'socket.io-client';
// import DatePicker from 'react-datepicker';
// import 'react-datepicker/dist/react-datepicker.css';
// import "../styles/patientlist.css";

// const PatientList = () => {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [selectedDate, setSelectedDate] = useState(null);
//   const { userName } = useAuth();
//   const containerRef = useRef(null);
//   const socketRef = useRef(null);
//   const navigate = useNavigate();

//   useEffect(() => {
//     // Initial data fetch
//     fetchPatients();

//     // Socket setup
//     socketRef.current = io('http://localhost:5000', {
//       transports: ['websocket', 'polling'],
//       cors: {
//         origin: "http://localhost:3000",
//         credentials: true
//       }
//     });

//     // Socket event listeners
//     socketRef.current.on('connect', () => {
//       console.log('Socket connected successfully');
//     });

//     socketRef.current.on('disconnect', () => {
//       console.log('Socket disconnected');
//     });

//     socketRef.current.on('connect_error', (error) => {
//       console.log('Socket connection error:', error);
//     });

//     socketRef.current.on('new_patient', (newPatient) => {
//       console.log('New patient received:', newPatient);
      
//       if (newPatient.assigned_doctor === userName) {
//         setPatientsByDate(prevPatients => {
//           const date = new Date(newPatient.reporting_time).toLocaleDateString();
//           const updatedPatients = { ...prevPatients };
          
//           if (!updatedPatients[date]) {
//             updatedPatients[date] = [];
//           }

//           // Check if patient already exists
//           const existingIndex = updatedPatients[date].findIndex(p => p.id === newPatient.id);
          
//           if (existingIndex === -1) {
//             // Add new patient
//             updatedPatients[date] = [
//               ...updatedPatients[date],
//               { ...newPatient, consulted: false }
//             ];
//           } else {
//             // Update existing patient
//             updatedPatients[date][existingIndex] = {
//               ...newPatient,
//               consulted: updatedPatients[date][existingIndex].consulted
//             };
//           }
          
//           return updatedPatients;
//         });
//       }
//     });

//     // Cleanup
//     return () => {
//       if (socketRef.current) {
//         socketRef.current.disconnect();
//       }
//     };
//   }, [userName]);

//   const fetchPatients = async () => {
//     try {
//       const response = await fetch('http://localhost:5000/get-patient-data');
//       if (!response.ok) {
//         throw new Error('Failed to fetch patient data');
//       }
//       const data = await response.json();
      
//       // Filter patients for current doctor
//       const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);
      
//       // Get stored consulted status
//       const storedConsultedStatus = JSON.parse(localStorage.getItem('consultedStatus') || '{}');

//       // Group patients by date
//       const groupedPatients = filteredPatients.reduce((acc, patient) => {
//         const date = new Date(patient.reporting_time).toLocaleDateString();
//         if (!acc[date]) {
//           acc[date] = [];
//         }
//         acc[date].push({
//           ...patient,
//           consulted: storedConsultedStatus[patient.id] || false
//         });
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

//   const handleConsultedChange = (event, date, index) => {
//     event.stopPropagation();
//     setPatientsByDate(prevPatients => {
//       const newPatients = JSON.parse(JSON.stringify(prevPatients));
//       if (newPatients[date] && newPatients[date][index]) {
//         const patient = newPatients[date][index];
//         patient.consulted = !patient.consulted;
        
//         const storedConsultedStatus = JSON.parse(localStorage.getItem('consultedStatus') || '{}');
//         storedConsultedStatus[patient.id] = patient.consulted;
//         localStorage.setItem('consultedStatus', JSON.stringify(storedConsultedStatus));
//       }
//       return newPatients;
//     });
//   };

//   const handlePatientClick = (patientId) => {
//     const selectedPatient = Object.values(patientsByDate)
//       .flat()
//       .find(patient => patient.id === patientId);
  
//     if (selectedPatient) {
//       navigate(`/patient/${patientId}`, { state: { patient: selectedPatient } });
//     } else {
//       console.error('Patient not found');
//     }
//   };

//   if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
//   if (error) return <div className="patient-list-error">{error}</div>;

//   const today = new Date().toLocaleDateString();
//   const sortedDates = Object.keys(patientsByDate).sort((a, b) => new Date(a) - new Date(b));
//   const displayDate = selectedDate ? selectedDate.toLocaleDateString() : today;

//   return (
//     <div className="patient-list-container" ref={containerRef}>
//       <div className="patient-list-header">
//         <h1>Patient Appointments</h1>
//         <div className="date-picker-container">
//           <DatePicker
//             selected={selectedDate}
//             onChange={date => setSelectedDate(date)}
//             placeholderText="Select date"
//             className="date-picker"
//             isClearable
//           />
//         </div>
//       </div>
//       {sortedDates.length === 0 ? (
//         <p className="no-patients">No patients scheduled for checkup.</p>
//       ) : (
//         <div className="date-sections">
//           <DateSection
//             dates={[displayDate]}
//             patientsByDate={patientsByDate}
//             handleConsultedChange={handleConsultedChange}
//             handlePatientClick={handlePatientClick}
//             isToday={displayDate === today}
//             isSelected={selectedDate !== null}
//           />
//         </div>
//       )}
//     </div>
//   );
// };

// const DateSection = ({ dates, patientsByDate, handleConsultedChange, handlePatientClick, isToday = false, isSelected = false }) => {
//   return dates.map(date => {
//     const patients = patientsByDate[date] || [];
//     const displayDate = new Date(date);
//     const isInFuture = displayDate > new Date();

//     return (
//       <div key={date} className={`date-section ${isToday ? 'today' : ''} ${isSelected ? 'selected' : ''} ${isInFuture ? 'future' : ''}`}>
//         <h2 className="date-header">
//           {isToday ? 'Today' : isSelected ? 'Selected Date' : displayDate.toLocaleDateString()}
//           {isInFuture && ' (Future Appointment)'}
//         </h2>
//         <div className="patient-grid">
//           {patients.length === 0 ? (
//             <p className="no-patients-for-date">No patients scheduled for this date.</p>
//           ) : (
//             patients.map((patient, index) => (
//               <div 
//                 key={patient.id} 
//                 className={`patient-card ${patient.consulted ? 'consulted' : ''}`}
//                 onClick={() => handlePatientClick(patient.id)}
//               >
//                 <div className="patient-info">
//                   <h3 className="patient-name">{patient.name}</h3>
//                   <div className="patient-details">
//                     <p>Gender: {patient.gender}</p>
//                     <p>Age: {patient.age}</p>
//                     <p>Reporting Time: {new Date(patient.reporting_time).toLocaleTimeString()}</p>
//                   </div>
//                 </div>
//                 <div className="patient-actions" onClick={(e) => e.stopPropagation()}>
//                   <div className="consulted-checkbox">
//                     <label>
//                       <input
//                         type="checkbox"
//                         checked={patient.consulted}
//                         onChange={(e) => handleConsultedChange(e, date, index)}
//                       />
//                       Consulted
//                     </label>
//                   </div>
//                 </div>
//               </div>
//             ))
//           )}
//         </div>
//       </div>
//     );
//   });
// };

// export default PatientList;

// import React, { useState, useEffect, useRef } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { useAuth } from './authcontext';
// import { io } from 'socket.io-client';
// import DatePicker from 'react-datepicker';
// import 'react-datepicker/dist/react-datepicker.css';
// import "../styles/patientlist.css";

// const PatientList = () => {
//   const [patientsByDate, setPatientsByDate] = useState({});
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [selectedDate, setSelectedDate] = useState(new Date());
//   const { userName } = useAuth();
//   const containerRef = useRef(null);
//   const socketRef = useRef(null);
//   const navigate = useNavigate();

//   // Helper function to parse the date string from API
//   const parseApiDate = (dateString) => {
//     if (!dateString) return null;
//     return new Date(dateString.replace(' ', 'T'));  // Convert to ISO format for reliable parsing
//   };

//   // Helper function to format date for grouping patients
//   const formatDate = (date) => {
//     if (!date) return '';
//     const d = new Date(date);
//     return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
//   };

//   useEffect(() => {
//     fetchPatients();

//     socketRef.current = io('http://localhost:5000', {
//       transports: ['websocket', 'polling'],
//       cors: {
//         origin: "http://localhost:3000",
//         credentials: true
//       }
//     });

//     socketRef.current.on('connect', () => {
//       console.log('Socket connected successfully');
//     });

//     socketRef.current.on('new_patient', (newPatient) => {
//       if (newPatient.assigned_doctor === userName) {
//         setPatientsByDate(prevPatients => {
//           const parsedDate = parseApiDate(newPatient.reporting_time);
//           const date = formatDate(parsedDate);
//           const updatedPatients = { ...prevPatients };
          
//           if (!updatedPatients[date]) {
//             updatedPatients[date] = [];
//           }

//           const existingIndex = updatedPatients[date].findIndex(p => p.id === newPatient.id);
          
//           if (existingIndex === -1) {
//             updatedPatients[date] = [
//               ...updatedPatients[date],
//               { ...newPatient, consulted: false }
//             ];
//           } else {
//             updatedPatients[date][existingIndex] = {
//               ...newPatient,
//               consulted: updatedPatients[date][existingIndex].consulted
//             };
//           }
          
//           return updatedPatients;
//         });
//       }
//     });

//     return () => {
//       if (socketRef.current) {
//         socketRef.current.disconnect();
//       }
//     };
//   }, [userName]);

//   const fetchPatients = async () => {
//     try {
//       const response = await fetch('http://localhost:5000/get-patient-data');
//       if (!response.ok) {
//         throw new Error('Failed to fetch patient data');
//       }
//       const data = await response.json();
      
//       // Filter patients for current doctor
//       const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);
      
//       // Get stored consulted status
//       const storedConsultedStatus = JSON.parse(localStorage.getItem('consultedStatus') || '{}');

//       // Group patients by date using the formatted date
//       const groupedPatients = filteredPatients.reduce((acc, patient) => {
//         const parsedDate = parseApiDate(patient.reporting_time);
//         const date = formatDate(parsedDate);
//         if (!acc[date]) {
//           acc[date] = [];
//         }
//         acc[date].push({
//           ...patient,
//           consulted: storedConsultedStatus[patient.id] || false
//         });
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

//   const handleConsultedChange = (event, date, index) => {
//     event.stopPropagation();
//     setPatientsByDate(prevPatients => {
//       const newPatients = JSON.parse(JSON.stringify(prevPatients));
//       if (newPatients[date] && newPatients[date][index]) {
//         const patient = newPatients[date][index];
//         patient.consulted = !patient.consulted;
        
//         const storedConsultedStatus = JSON.parse(localStorage.getItem('consultedStatus') || '{}');
//         storedConsultedStatus[patient.id] = patient.consulted;
//         localStorage.setItem('consultedStatus', JSON.stringify(storedConsultedStatus));
//       }
//       return newPatients;
//     });
//   };

//   const handlePatientClick = (patientId) => {
//     const selectedPatient = Object.values(patientsByDate)
//       .flat()
//       .find(patient => patient.id === patientId);
  
//     if (selectedPatient) {
//       navigate(`/patient/${patientId}`, { state: { patient: selectedPatient } });
//     } else {
//       console.error('Patient not found');
//     }
//   };

//   if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
//   if (error) return <div className="patient-list-error">{error}</div>;

//   const today = formatDate(new Date());
//   const selectedDateStr = formatDate(selectedDate);
  
//   // Get all dates that have patients
//   const availableDates = Object.keys(patientsByDate).sort();

//   return (
//     <div className="patient-list-container" ref={containerRef}>
//       <div className="patient-list-header">
//         <h1>Patient Appointments</h1>
//         <div className="date-picker-container">
//           <DatePicker
//             selected={selectedDate}
//             onChange={date => setSelectedDate(date)}
//             className="date-picker"
//             dateFormat="yyyy-MM-dd"
//           />
//         </div>
//       </div>
//       <div className="date-sections">
//         {availableDates.length === 0 ? (
//           <p className="no-patients">No patients scheduled for checkup.</p>
//         ) : (
//           <DateSection
//             dates={[selectedDateStr]}
//             patientsByDate={patientsByDate}
//             handleConsultedChange={handleConsultedChange}
//             handlePatientClick={handlePatientClick}
//             isToday={selectedDateStr === today}
//             isSelected={true}
//             formatTime={(timeStr) => {
//               const date = parseApiDate(timeStr);
//               return date ? date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '';
//             }}
//           />
//         )}
//       </div>
//     </div>
//   );
// };

// const DateSection = ({ dates, patientsByDate, handleConsultedChange, handlePatientClick, isToday = false, isSelected = false, formatTime }) => {
//   return dates.map(date => {
//     const patients = patientsByDate[date] || [];
//     const displayDate = new Date(date);
//     const isInFuture = displayDate > new Date();

//     return (
//       <div key={date} className={`date-section ${isToday ? 'today' : ''} ${isSelected ? 'selected' : ''} ${isInFuture ? 'future' : ''}`}>
//         <h2 className="date-header">
//           {isToday ? 'Today' : isSelected ? 'Selected Date' : date}
//           {isInFuture && ' (Future Appointment)'}
//         </h2>
//         <div className="patient-grid">
//           {patients.length === 0 ? (
//             <p className="no-patients-for-date">No patients scheduled for this date.</p>
//           ) : (
//             patients.map((patient, index) => (
//               <div 
//                 key={patient.id} 
//                 className={`patient-card ${patient.consulted ? 'consulted' : ''}`}
//                 onClick={() => handlePatientClick(patient.id)}
//               >
//                 <div className="patient-info">
//                   <h3 className="patient-name">{patient.name}</h3>
//                   <div className="patient-details">
//                     <p>Gender: {patient.gender}</p>
//                     <p>Age: {patient.age}</p>
//                     <p>Reporting Time: {formatTime(patient.reporting_time)}</p>
//                   </div>
//                 </div>
//                 <div className="patient-actions" onClick={(e) => e.stopPropagation()}>
//                   <div className="consulted-checkbox">
//                     <label>
//                       <input
//                         type="checkbox"
//                         checked={patient.consulted}
//                         onChange={(e) => handleConsultedChange(e, date, index)}
//                       />
//                       Consulted
//                     </label>
//                   </div>
//                 </div>
//               </div>
//             ))
//           )}
//         </div>
//       </div>
//     );
//   });
// };

// export default PatientList;


import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from './authcontext';
import { io } from 'socket.io-client';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import "../styles/patientlist.css";

const PatientList = () => {
  const [patientsByDate, setPatientsByDate] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const { userName } = useAuth();
  const containerRef = useRef(null);
  const socketRef = useRef(null);
  const navigate = useNavigate();

  // Helper function to parse the date string from API
  const parseApiDate = (dateString) => {
    if (!dateString) return null;
    return new Date(dateString.replace(' ', 'T'));  // Convert to ISO format for reliable parsing
  };

  // Helper function to format date for grouping patients
  const formatDate = (date) => {
    if (!date) return '';
    const d = new Date(date);
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
  };

  useEffect(() => {
    fetchPatients();

    socketRef.current = io('http://localhost:5000', {
      transports: ['websocket', 'polling'],
      cors: {
        origin: "http://localhost:3000",
        credentials: true
      }
    });

    socketRef.current.on('connect', () => {
      console.log('Socket connected successfully');
    });

    socketRef.current.on('new_patient', (newPatient) => {
      if (newPatient.assigned_doctor === userName) {
        setPatientsByDate(prevPatients => {
          const parsedDate = parseApiDate(newPatient.reporting_time);
          const date = formatDate(parsedDate);
          const updatedPatients = { ...prevPatients };
          
          if (!updatedPatients[date]) {
            updatedPatients[date] = [];
          }

          const existingIndex = updatedPatients[date].findIndex(p => p.id === newPatient.id);
          
          if (existingIndex === -1) {
            updatedPatients[date] = [
              ...updatedPatients[date],
              { ...newPatient, consulted: false }
            ];
          } else {
            updatedPatients[date][existingIndex] = {
              ...newPatient,
              consulted: updatedPatients[date][existingIndex].consulted
            };
          }
          
          return updatedPatients;
        });
      }
    });

    socketRef.current.on('consulted_patient', (data) => {
      setPatientsByDate(prevPatients => {
        const newPatients = JSON.parse(JSON.stringify(prevPatients));
        Object.values(newPatients).forEach(patients => {
          const patient = patients.find(p => p.name === data.name);
          if (patient) {
            patient.consulted = true;
            // Update the consulted status in local storage
            localStorage.setItem(`consulted-${patient.id}`, true);
          }
        });
        return newPatients;
      });
    });

    return () => {
      if (socketRef.current) {
        socketRef.current.disconnect();
      }
    };
  }, [userName]);

  const fetchPatients = async () => {
    try {
      const response = await fetch('http://localhost:5000/get-patient-data');
      if (!response.ok) {
        throw new Error('Failed to fetch patient data');
      }
      const data = await response.json();
      
      // Filter patients for current doctor
      const filteredPatients = data.filter(patient => patient.assigned_doctor === userName);
      
      // Get stored consulted status
      const storedConsultedStatus = {};
      filteredPatients.forEach(patient => {
        const consultedStatus = localStorage.getItem(`consulted-${patient.id}`);
        storedConsultedStatus[patient.id] = consultedStatus ? JSON.parse(consultedStatus) : false;
      });

      // Group patients by date using the formatted date
      const groupedPatients = filteredPatients.reduce((acc, patient) => {
        const parsedDate = parseApiDate(patient.reporting_time);
        const date = formatDate(parsedDate);
        if (!acc[date]) {
          acc[date] = [];
        }
        acc[date].push({
          ...patient,
          consulted: storedConsultedStatus[patient.id] || false
        });
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

  const handleConsultedChange = (event, date, index) => {
    event.stopPropagation();
    const patient = patientsByDate[date][index];
    socketRef.current.emit('update_consulted', { patient_id: patient.id });
    // Update the consulted status in local storage
    localStorage.setItem(`consulted-${patient.id}`, true);
  };

  const handlePatientClick = (patientId) => {
    const selectedPatient = Object.values(patientsByDate)
      .flat()
      .find(patient => patient.id === patientId);
  
    if (selectedPatient) {
      navigate(`/patient/${patientId}`, { state: { patient: selectedPatient } });
    } else {
      console.error('Patient not found');
    }
  };

  if (loading) return <div className="patient-list-loading">Loading patient data...</div>;
  if (error) return <div className="patient-list-error">{error}</div>;

  const today = formatDate(new Date());
  const selectedDateStr = formatDate(selectedDate);
  
  // Get all dates that have patients
  const availableDates = Object.keys(patientsByDate).sort();

  return (
    <div className="patient-list-container" ref={containerRef}>
      <div className="patient-list-header">
        <h1>Patient Appointments</h1>
        <div className="date-picker-container">
          <DatePicker
            selected={selectedDate}
            onChange={date => setSelectedDate(date)}
            className="date-picker"
            dateFormat="yyyy-MM-dd"
          />
        </div>
      </div>
      <div className="date-sections">
        {availableDates.length === 0 ? (
          <p className="no-patients">No patients scheduled for checkup.</p>
        ) : (
          <DateSection
            dates={[selectedDateStr]}
            patientsByDate={patientsByDate}
            handleConsultedChange={handleConsultedChange}
            handlePatientClick={handlePatientClick}
            isToday={selectedDateStr === today}
            isSelected={true}
            formatTime={(timeStr) => {
              const date = parseApiDate(timeStr);
              return date ? date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '';
            }}
          />
        )}
      </div>
    </div>
  );
};

const DateSection = ({ dates, patientsByDate, handleConsultedChange, handlePatientClick, isToday = false, isSelected = false, formatTime }) => {
  return dates.map(date => {
    const patients = patientsByDate[date] || [];
    const displayDate = new Date(date);
    const isInFuture = displayDate > new Date();

    return (
      <div key={date} className={`date-section ${isToday ? 'today' : ''} ${isSelected ? 'selected' : ''} ${isInFuture ? 'future' : ''}`}>
        <h2 className="date-header">
          {isToday ? 'Today' : isSelected ? 'Selected Date' : date}
          {isInFuture && ' (Future Appointment)'}
        </h2>
        <div className="patient-grid">
          {patients.length === 0 ? (
            <p className="no-patients-for-date">No patients scheduled for this date.</p>
          ) : (
            patients.map((patient, index) => (
              <div 
                key={patient.id} 
                className={`patient-card ${patient.consulted ? 'consulted' : ''}`}
                onClick={() => handlePatientClick(patient.id)}
              >
                <div className="patient-info">
                  <h3 className="patient-name">{patient.name}</h3>
                  <div className="patient-details">
                    <p>Gender: {patient.gender}</p>
                    <p>Age: {patient.age}</p>
                    <p>Reporting Time: {formatTime(patient.reporting_time)}</p>
                  </div>
                </div>
                <div className="patient-actions" onClick={(e) => e.stopPropagation()}>
                  <div className="consulted-checkbox">
                    <label>
                      <input
                        type="checkbox"
                        checked={patient.consulted}
                        onChange={(e) => handleConsultedChange(e, date, index)}
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