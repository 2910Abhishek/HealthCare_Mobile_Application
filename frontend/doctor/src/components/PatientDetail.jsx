// import React, { useState, useEffect } from 'react';
// import { useLocation, useNavigate } from 'react-router-dom';
// import "../styles/PatientDetail.css";

// const PatientDetail = () => {
//   const location = useLocation();
//   const navigate = useNavigate();
//   const [patient, setPatient] = useState(null);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);

//   const [prescription, setPrescription] = useState({
//     date: '',
//     medicine: '',
//     dosage: '',
//     remarks: ''
//   });

//   useEffect(() => {
//     if (location.state && location.state.patient) {
//       setPatient(location.state.patient);
//       setLoading(false);
//     } else {
//       setError('No patient data available');
//       setLoading(false);
//     }
//   }, [location.state]);

//   const handleInputChange = (e) => {
//     const { name, value } = e.target;
//     setPrescription(prevState => ({ ...prevState, [name]: value }));
//   };

//   const handleSubmit = (e) => {
//     e.preventDefault();
//     console.log('Prescription submitted:', prescription);
//     // Here you would typically send the prescription data to your backend
//   };

//   if (loading) return <div>Loading patient data...</div>;
//   if (error) return <div>{error}</div>;
//   if (!patient) return <div>No patient data available</div>;

//   return (
//     <div className="container">
//       <h1>Patient Details: {patient.name}</h1>
//       <div className="section-content">
//         <div className="patient-info">
//           <p><strong>Gender:</strong> {patient.gender}</p>
//           <p><strong>Age:</strong> {patient.age}</p>
//           <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleString()}</p>
//           <p><strong>Assigned Doctor:</strong> {patient.assigned_doctor}</p>
//         </div>
//       </div>

//       <div className="section-content prescription">
//         <h2>Prescription</h2>
//         <form onSubmit={handleSubmit}>
//           <div>
//             <label>Date:</label>
//             <input 
//               type="date" 
//               name="date" 
//               value={prescription.date} 
//               onChange={handleInputChange} 
//             />
//           </div>
//           <div>
//             <label>Medicine:</label>
//             <input 
//               type="text" 
//               name="medicine" 
//               value={prescription.medicine} 
//               onChange={handleInputChange} 
//             />
//           </div>
//           <div>
//             <label>Dosage:</label>
//             <input 
//               type="text" 
//               name="dosage" 
//               value={prescription.dosage} 
//               onChange={handleInputChange} 
//             />
//           </div>
//           <div>
//             <label>Remarks:</label>
//             <textarea 
//               name="remarks" 
//               value={prescription.remarks} 
//               onChange={handleInputChange}
//             />
//           </div>
//           <button type="submit">Submit Prescription</button>
//         </form>
//         </div>
//         </div>
//   )
// }
// export default PatientDetail;



// import React, { useState, useEffect } from 'react';
// import { useLocation, useNavigate } from 'react-router-dom';
// import DatePicker from 'react-datepicker';
// import "react-datepicker/dist/react-datepicker.css";
// import "../styles/PatientDetail.css";
// import { medicines } from '../constants'; // Import the medicines list

// const PatientDetail = () => {
//   const location = useLocation();
//   const navigate = useNavigate();
//   const [patient, setPatient] = useState(null);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [suggestions, setSuggestions] = useState([]);
//   const [activeSuggestionIndex, setActiveSuggestionIndex] = useState(null);
//   const [selectedMedicines, setSelectedMedicines] = useState({});

//   const [prescription, setPrescription] = useState({
//     date: '',
//     medications: [{
//       medicine: '',
//       dosage: '',
//       morning: false,
//       afternoon: false,
//       night: false,
//       duration: '',
//       timing: ''
//     }],
//     remarks: '',
//     nextAppointment: null,
//     nextAppointmentTime: null,
//     isNextAppointmentNeeded: true
//   });

//   useEffect(() => {
//     if (location.state && location.state.patient) {
//       setPatient(location.state.patient);
//       setLoading(false);
//     } else {
//       setError('No patient data available');
//       setLoading(false);
//     }
//   }, [location.state]);

//   const handleInputChange = (e, index) => {
//     const { name, value, type, checked } = e.target;
    
//     if (name === 'date' || name === 'remarks') {
//       setPrescription(prevState => ({ ...prevState, [name]: value }));
//     } else if (name === 'isNextAppointmentNeeded') {
//       setPrescription(prevState => ({ 
//         ...prevState, 
//         isNextAppointmentNeeded: checked,
//         nextAppointment: checked ? prevState.nextAppointment : null,
//         nextAppointmentTime: checked ? prevState.nextAppointmentTime : null
//       }));
//     } else if (name.startsWith('medication')) {
//       const newMedications = prescription.medications.map((medication, i) => {
//         if (i === index) {
//           return { 
//             ...medication, 
//             [name.split('.')[1]]: type === 'checkbox' ? checked : value 
//           };
//         }
//         return medication;
//       });
//       setPrescription(prevState => ({ ...prevState, medications: newMedications }));

//       if (name.endsWith('medicine')) {
//         if (value.length > 0) {
//           const filteredSuggestions = medicines.filter(med => 
//             med.toLowerCase().startsWith(value.toLowerCase())
//           );
//           setSuggestions(filteredSuggestions);
//           setActiveSuggestionIndex(index);
//         } else {
//           setSuggestions([]);
//           setActiveSuggestionIndex(null);
//         }
//       }
//     }
//   };

//   const handleSuggestionClick = (suggestion, index) => {
//     const newMedications = prescription.medications.map((medication, i) => {
//       if (i === index) {
//         return { ...medication, medicine: suggestion };
//       }
//       return medication;
//     });
//     setPrescription(prevState => ({ ...prevState, medications: newMedications }));
//     setSuggestions([]);
//     setActiveSuggestionIndex(null);
//   };

//   const handleNextAppointmentChange = (date) => {
//     setPrescription(prevState => ({ 
//       ...prevState, 
//       nextAppointment: date,
//       isNextAppointmentNeeded: date !== null
//     }));
//   };

//   const handleNextAppointmentTimeChange = (e) => {
//     setPrescription(prevState => ({
//       ...prevState,
//       nextAppointmentTime: e.target.value
//     }));
//   };

//   const handleAddMedication = () => {
//     setPrescription(prevState => ({
//       ...prevState,
//       medications: [...prevState.medications, {
//         medicine: '',
//         dosage: '',
//         morning: false,
//         afternoon: false,
//         night: false,
//         duration: '',
//         timing: ''
//       }]
//     }));
//   };

//   const handleRemoveMedication = (index) => {
//     setPrescription(prevState => ({
//       ...prevState,
//       medications: prevState.medications.filter((_, i) => i !== index)
//     }));
//   };

//   const handleSubmit = (e) => {
//     e.preventDefault();
//     console.log('Prescription submitted:', prescription);
//     // Here you would typically send the prescription data to your backend
//   };

//   if (loading) return <div>Loading patient data...</div>;
//   if (error) return <div>{error}</div>;
//   if (!patient) return <div>No patient data available</div>;

//   return (
//     <div className="container">
//       <h1>Patient Name: {patient.name}</h1>
//       <div className="section-content">
//         <div className="patient-info">
//           <p><strong>Gender:</strong> {patient.gender}</p>
//           <p><strong>Age:</strong> {patient.age}</p>
//           <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleString()}</p>
//           <p><strong>Assigned Doctor:</strong> {patient.assigned_doctor}</p>
//         </div>
//       </div>

//       <div className="section-content prescription">
//         <h2>Prescription</h2>
//         <form onSubmit={handleSubmit}>
//           <div className="form-group">
//             <label>Date:</label>
//             <input
//               type="date"
//               name="date"
//               value={prescription.date}
//               onChange={handleInputChange}
//               className="form-control"
//             />
//           </div>

//           <div className="table-responsive">
//             <table className="medication-table">
//               <thead>
//                 <tr>
//                   <th>Medicine</th>
//                   <th>Dosage</th>
//                   <th>Morning</th>
//                   <th>Afternoon</th>
//                   <th>Night</th>
//                   <th>Duration</th>
//                   <th>Timing</th>
//                   <th></th>
//                 </tr>
//               </thead>
//               <tbody>
//                 {prescription.medications.map((medication, index) => (
//                   <tr key={index}>
//                     <td>
//                       <div className="autocomplete">
//                         <input
//                           type="text"
//                           name={`medication.medicine`}
//                           value={medication.medicine}
//                           onChange={(e) => handleInputChange(e, index)}
//                           placeholder="Medicine name"
//                           className="form-control"
//                           onBlur={() => setTimeout(() => setActiveSuggestionIndex(null), 200)}
//                         />
//                         {activeSuggestionIndex === index && suggestions.length > 0 && (
//                           <ul className="suggestions">
//                             {suggestions.map((suggestion, i) => (
//                               <li key={i} onClick={() => handleSuggestionClick(suggestion, index)}>
//                                 {suggestion}
//                               </li>
//                             ))}
//                           </ul>
//                         )}
//                       </div>
//                     </td>
//                     <td>
//                       <input
//                         type="text"
//                         name={`medication.dosage`}
//                         value={medication.dosage}
//                         onChange={(e) => handleInputChange(e, index)}
//                         placeholder="e.g., 500mg"
//                         className="form-control"
//                       />
//                     </td>
//                     <td>
//                       <input
//                         type="checkbox"
//                         name={`medication.morning`}
//                         checked={medication.morning}
//                         onChange={(e) => handleInputChange(e, index)}
//                         className="form-check-input"
//                       />
//                     </td>
//                     <td>
//                       <input
//                         type="checkbox"
//                         name={`medication.afternoon`}
//                         checked={medication.afternoon}
//                         onChange={(e) => handleInputChange(e, index)}
//                         className="form-check-input"
//                       />
//                     </td>
//                     <td>
//                       <input
//                         type="checkbox"
//                         name={`medication.night`}
//                         checked={medication.night}
//                         onChange={(e) => handleInputChange(e, index)}
//                         className="form-check-input"
//                       />
//                     </td>
//                     <td>
//                       <input
//                         type="text"
//                         name={`medication.duration`}
//                         value={medication.duration}
//                         onChange={(e) => handleInputChange(e, index)}
//                         placeholder="e.g., 7 days"
//                         className="form-control"
//                       />
//                     </td>
//                     <td>
//                       <select
//                         name={`medication.timing`}
//                         value={medication.timing}
//                         onChange={(e) => handleInputChange(e, index)}
//                         className="form-control"
//                       >
//                         <option value="">Select timing</option>
//                         <option value="Before Meal">Before Meal</option>
//                         <option value="After Meal">After Meal</option>
//                       </select>
//                     </td>
//                     <td>
//                       <button
//                         type="button"
//                         onClick={() => handleRemoveMedication(index)}
//                         className="btn btn-danger btn-sm"
//                       >Remove</button>
//                     </td>
//                   </tr>
//                 ))}
//               </tbody>
//             </table>

//             <button type="button" onClick={handleAddMedication} className="btn btn-primary btn-sm">Add Medication</button>
//           </div>

//           <div className="form-group">
//             <label>
//               <input
//                 type="checkbox"
//                 name="isNextAppointmentNeeded"
//                 checked={prescription.isNextAppointmentNeeded}
//                 onChange={handleInputChange}
//               /> Next Appointment Needed
//             </label>
//           </div>

//           {prescription.isNextAppointmentNeeded && (
//   <div className="form-group next-appointment-row">
//     <div>
//       <label>Next Appointment Date and Time:</label>
//       <DatePicker
//         selected={prescription.nextAppointment}
//         onChange={handleNextAppointmentChange}
//         className="form-control"
//         showTimeSelect
//         timeFormat="HH:mm"
//         timeIntervals={15}  // You can adjust the time intervals if needed
//         dateFormat="dd/MM/yyyy h:mm aa"
//         placeholderText="Select date and time"
//       />
//     </div>
//   </div>
// )}

        

//           <div className="form-group">
//             <label>Remarks:</label>
//             <textarea
//               name="remarks"
//               value={prescription.remarks}
//               onChange={handleInputChange}
//               className="form-control"
//               rows="3"
//             />
//           </div>

//           <button type="submit" className="btn btn-success">Submit</button>
//         </form>
//       </div>
//     </div>
//   );
// };

// export default PatientDetail;





import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import DatePicker from 'react-datepicker';
import "react-datepicker/dist/react-datepicker.css";
import "../styles/PatientDetail.css";
import Medication from './Medication';
import PastPrescriptions from './PastPrescriptions'; // Import the new component


const PatientDetail = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [patient, setPatient] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [suggestions, setSuggestions] = useState([]);
  const [activeSuggestionIndex, setActiveSuggestionIndex] = useState(null);
  const [selectedMedicines, setSelectedMedicines] = useState({});

  const [prescription, setPrescription] = useState({
    date: '',
    medications: [{
      medicine: '',
      dosage: '',
      morning: false,
      afternoon: false,
      night: false,
      duration: '',
      timing: ''
    }],
    remarks: '',
    nextAppointment: null,
    nextAppointmentTime: null,
    isNextAppointmentNeeded: true
  });

  useEffect(() => {
    if (location.state && location.state.patient) {
      setPatient(location.state.patient);
      setLoading(false);
    } else {
      setError('No patient data available');
      setLoading(false);
    }
  }, [location.state]);


  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    
    if (name === 'date' || name === 'remarks') {
      setPrescription(prevState => ({ ...prevState, [name]: value }));
    } else if (name === 'isNextAppointmentNeeded') {
      setPrescription(prevState => ({ 
        ...prevState, 
        isNextAppointmentNeeded: checked,
        nextAppointment: checked ? prevState.nextAppointment : null,
        nextAppointmentTime: checked ? prevState.nextAppointmentTime : null
      }));
    }
  };

  const handleNextAppointmentChange = (date) => {
    setPrescription(prevState => ({ 
      ...prevState, 
      nextAppointment: date,
      isNextAppointmentNeeded: date !== null
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    try {
      // Show loading state
      setLoading(true);
  
      const doctorId = localStorage.getItem('doctor_id');
      const formattedData = {
        ...prescription,
        doctorId,
        patientId: patient.id,
        patientName: patient.name,
        patientAge: patient.age,
        patientGender: patient.gender,
        doctorName: patient.assigned_doctor
      };
  
      const response = await fetch('http://localhost:5000/api/prescriptions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formattedData)
      });
  
      const data = await response.json();
  
      if (data.success) {
        // Hide loading state
        setLoading(false);
        
        // Show success message
        alert('Prescription saved successfully!');
        
        // Open PDF in new tab
        window.open(`http://localhost:5000${data.data.pdfUrl}`, '_blank');
        
        // Navigate back to patient list
        navigate('/dashboard');
      } else {
        throw new Error(data.message);
      }
    } catch (error) {
      // Hide loading state
      setLoading(false);
      
      console.error('Error submitting prescription:', error);
      alert('Failed to save prescription. Please try again.');
    }
  };

  if (loading) return <div>Loading patient data...</div>;
  if (error) return <div>{error}</div>;
  if (!patient) return <div>No patient data available</div>;

  return (
    <div className="container">
      <h1>Patient Name: {patient.name}</h1>
      <div className="section-content">
        <div className="patient-info">
          <p><strong>Gender:</strong> {patient.gender}</p>
          <p><strong>Age:</strong> {patient.age}</p>
          <p><strong>Reporting Time:</strong> {new Date(patient.reporting_time).toLocaleString()}</p>
          <p><strong>Assigned Doctor:</strong> {patient.assigned_doctor}</p>
        </div>
      </div>

      <div className="section-content prescription">
        <h2>Prescription</h2>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Date:</label>
            <input
              type="date"
              name="date"
              value={prescription.date}
              onChange={handleInputChange}
              className="form-control"
            />
          </div>

          <Medication
            prescription={prescription}
            setPrescription={setPrescription}
            suggestions={suggestions}
            setSuggestions={setSuggestions}
            activeSuggestionIndex={activeSuggestionIndex}
            setActiveSuggestionIndex={setActiveSuggestionIndex}
          />

          <div className="form-group">
            <label>
              <input
                type="checkbox"
                name="isNextAppointmentNeeded"
                checked={prescription.isNextAppointmentNeeded}
                onChange={handleInputChange}
              /> Next Appointment Needed
            </label>
          </div>

          {prescription.isNextAppointmentNeeded && (
            <div className="form-group next-appointment-row">
              <div>
                <label>Next Appointment Date and Time:</label>
                <DatePicker
                  selected={prescription.nextAppointment}
                  onChange={handleNextAppointmentChange}
                  className="form-control"
                  showTimeSelect
                  timeFormat="HH:mm"
                  timeIntervals={15}
                  dateFormat="dd/MM/yyyy h:mm aa"
                  placeholderText="Select date and time"
                />
              </div>
            </div>
          )}

          <div className="form-group">
            <label>Remarks:</label>
            <textarea
              name="remarks"
              value={prescription.remarks}
              onChange={handleInputChange}
              className="form-control"
              rows="3"
            />
          </div>

          <button type="submit" className="btn btn-success">Submit</button>
        </form>
      </div>
           {/* Add the PastPrescriptions component */}
           <PastPrescriptions patientId={patient.id} />
    </div>
  );
};

export default PatientDetail;