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
        
import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import "../styles/PatientDetail.css";

const PatientDetail = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [patient, setPatient] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

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
    nextAppointment: ''
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

  const handleInputChange = (e, index) => {
    const { name, value, type, checked } = e.target;
    if (name === 'date' || name === 'remarks' || name === 'nextAppointment') {
      setPrescription(prevState => ({ ...prevState, [name]: value }));
    } else {
      const newMedications = prescription.medications.map((medication, i) => {
        if (i === index) {
          return { 
            ...medication, 
            [name]: type === 'checkbox' ? checked : value 
          };
        }
        return medication;
      });
      setPrescription(prevState => ({ ...prevState, medications: newMedications }));
    }
  };

  const handleAddMedication = () => {
    setPrescription(prevState => ({
      ...prevState,
      medications: [...prevState.medications, {
        medicine: '',
        dosage: '',
        morning: false,
        afternoon: false,
        night: false,
        duration: '',
        timing: ''
      }]
    }));
  };

  const handleRemoveMedication = (index) => {
    setPrescription(prevState => ({
      ...prevState,
      medications: prevState.medications.filter((_, i) => i !== index)
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Prescription submitted:', prescription);
    // Here you would typically send the prescription data to your backend
  };

  if (loading) return <div>Loading patient data...</div>;
  if (error) return <div>{error}</div>;
  if (!patient) return <div>No patient data available</div>;

  return (
    <div className="container">
      <h1>Patient Details: {patient.name}</h1>
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

          <div className="table-responsive">
            <table className="medication-table">
              <thead>
                <tr>
                  <th>Medicine</th>
                  <th>Dosage</th>
                  <th>Morning</th>
                  <th>Afternoon</th>
                  <th>Night</th>
                  <th>Duration</th>
                  <th>Timing</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {prescription.medications.map((medication, index) => (
                  <tr key={index}>
                    <td>
                      <input
                        type="text"
                        name="medicine"
                        value={medication.medicine}
                        onChange={(e) => handleInputChange(e, index)}
                        placeholder="Medicine name"
                        className="form-control"
                      />
                    </td>
                    <td>
                      <input
                        type="text"
                        name="dosage"
                        value={medication.dosage}
                        onChange={(e) => handleInputChange(e, index)}
                        placeholder="e.g., 500mg"
                        className="form-control"
                      />
                    </td>
                    <td>
                      <input
                        type="checkbox"
                        name="morning"
                        checked={medication.morning}
                        onChange={(e) => handleInputChange(e, index)}
                        className="form-check-input"
                      />
                    </td>
                    <td>
                      <input
                        type="checkbox"
                        name="afternoon"
                        checked={medication.afternoon}
                        onChange={(e) => handleInputChange(e, index)}
                        className="form-check-input"
                      />
                    </td>
                    <td>
                      <input
                        type="checkbox"
                        name="night"
                        checked={medication.night}
                        onChange={(e) => handleInputChange(e, index)}
                        className="form-check-input"
                      />
                    </td>
                    <td>
                      <input
                        type="text"
                        name="duration"
                        value={medication.duration}
                        onChange={(e) => handleInputChange(e, index)}
                        placeholder="e.g., 7 days"
                        className="form-control"
                      />
                    </td>
                    <td>
                      <select
                        name="timing"
                        value={medication.timing}
                        onChange={(e) => handleInputChange(e, index)}
                        className="form-control"
                      >
                        <option value="">Select timing</option>
                        <option value="before_meals">Before meals</option>
                        <option value="after_meals">After meals</option>
                        <option value="with_meals">With meals</option>
                        <option value="bedtime">Bedtime</option>
                      </select>
                    </td>
                    <td>
                      <button type="button" onClick={() => handleRemoveMedication(index)} className="btn btn-danger btn-sm">
                        &times;
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <button type="button" onClick={handleAddMedication} className="btn btn-primary btn-add-medication mb-3">
            + Add Medication
          </button>

          {/* New Next Appointment Section */}
          <div className="form-group">
            <label>Next Appointment:</label>
            <input
              type="date"
              name="nextAppointment"
              value={prescription.nextAppointment}
              onChange={handleInputChange}
              className="form-control"
            />
          </div>

          <div className="form-group">
            <label>Remarks:</label>
            <textarea
              name="remarks"
              value={prescription.remarks}
              onChange={handleInputChange}
              className="form-control"
            />
          </div>

          <button type="submit" className="btn btn-success">Submit Prescription</button>
        </form>
      </div>
    </div>
  );
};

export default PatientDetail;
