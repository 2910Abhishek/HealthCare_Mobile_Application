import React, { useState, useEffect } from 'react';
import "../styles/pastprescription.css";

const PastPrescriptions = ({ patientId }) => {
  const [pastPrescriptions, setPastPrescriptions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchPastPrescriptions();
  }, [patientId]);

  const fetchPastPrescriptions = async () => {
    try {
      setLoading(true);
      const response = await fetch(`http://localhost:5000/api/prescriptions/patient/${patientId}`);
      const data = await response.json();
      
      if (data.success) {
        setPastPrescriptions(data.prescriptions);
      } else {
        setError(data.message);
      }
    } catch (error) {
      setError('Failed to fetch past prescriptions');
      console.error('Error fetching past prescriptions:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleViewPrescription = (prescriptionId) => {
    window.open(`http://localhost:5000/api/prescriptions/${prescriptionId}/pdf`, '_blank');
  };

  if (loading) return <div>Loading past prescriptions...</div>;
  if (error) return <div className="error-message">{error}</div>;

  return (
    <div className="section-content past-prescriptions">
      <h2>Past Prescriptions</h2>
      {pastPrescriptions.length > 0 ? (
        <div className="prescription-list">
          <table className="table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Doctor</th>
                <th>Medications</th>
                <th>Next Appointment</th>
                <th>Remarks</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {pastPrescriptions.map((presc) => (
                <tr key={presc.id}>
                  <td>{new Date(presc.date).toLocaleDateString()}</td>
                  <td>{presc.doctor_name}</td>
                  <td>
                    <ul className="medications-list">
                      {presc.medications.map((med, index) => (
                        <li key={index}>
                          {med.medicine} - {med.dosage}
                          {(med.morning || med.afternoon || med.night) && (
                            <span className="timing">
                              {[
                                med.morning && 'Morning',
                                med.afternoon && 'Afternoon',
                                med.night && 'Night'
                              ].filter(Boolean).join(', ')}
                            </span>
                          )}
                        </li>
                      ))}
                    </ul>
                  </td>
                  <td>
                    {presc.next_appointment 
                      ? new Date(presc.next_appointment).toLocaleString()
                      : 'No appointment scheduled'}
                  </td>
                  <td>{presc.remarks || '-'}</td>
                  <td>
                    <button
                      className="btn btn-primary view-btn"
                      onClick={() => handleViewPrescription(presc.id)}
                    >
                      View
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <p className="no-prescriptions">No past prescriptions found.</p>
      )}
    </div>
  );
};

export default PastPrescriptions;