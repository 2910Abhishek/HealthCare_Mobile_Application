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
    medicine: '',
    dosage: '',
    remarks: ''
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
    const { name, value } = e.target;
    setPrescription(prevState => ({ ...prevState, [name]: value }));
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
        <h2>Prescription Section</h2>
        <form onSubmit={handleSubmit}>
          <div>
            <label>Date:</label>
            <input 
              type="date" 
              name="date" 
              value={prescription.date} 
              onChange={handleInputChange} 
            />
          </div>
          <div>
            <label>Medicine:</label>
            <input 
              type="text" 
              name="medicine" 
              value={prescription.medicine} 
              onChange={handleInputChange} 
            />
          </div>
          <div>
            <label>Dosage:</label>
            <input 
              type="text" 
              name="dosage" 
              value={prescription.dosage} 
              onChange={handleInputChange} 
            />
          </div>
          <div>
            <label>Remarks:</label>
            <textarea 
              name="remarks" 
              value={prescription.remarks} 
              onChange={handleInputChange}
            />
          </div>
          <button type="submit">Submit Prescription</button>
        </form>
        </div>
        </div>
  )
}
export default PatientDetail;
        