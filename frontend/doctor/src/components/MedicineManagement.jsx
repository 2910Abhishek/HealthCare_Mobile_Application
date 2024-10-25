import React, { useState, useEffect } from 'react';
import '../styles/Medicinemanagement.css';
import { useAuth } from './authcontext';  // Update path to match your project structure

const MedicineManagement = () => {
  const [newMedicine, setNewMedicine] = useState('');
  const [medicinesList, setMedicinesList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [successMessage, setSuccessMessage] = useState('');
  const { userName } = useAuth();
  
  // Get doctorId from localStorage consistently with TimeSlotManager
  const doctorId = localStorage.getItem('doctor_id');  // Note: using 'doctor_id' instead of 'doctorId'
  const API_BASE_URL = 'http://localhost:5000';

  useEffect(() => {
    fetchMedicines();
  }, []);

  const fetchMedicines = async () => {
    if (!doctorId) {
      setError('Doctor ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/api/medicines?doctorId=${doctorId}`);
      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.message || 'Failed to fetch medicines');
      }
      
      setMedicinesList(data.data || []);
      setError('');
    } catch (error) {
      setError('Failed to fetch medicines. Please try again.');
      console.error('Error fetching medicines:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleAddMedicine = async () => {
    if (!newMedicine.trim() || !doctorId) return;
    
    try {
      const response = await fetch(`${API_BASE_URL}/api/medicines`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          medicineName: newMedicine,
          doctorId: doctorId
        }),
      });
      
      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.message || 'Failed to add medicine');
      }
      
      setMedicinesList(prevList => [...prevList, data.data]);
      setNewMedicine('');
      setError('');
      setSuccessMessage('Medicine added successfully!');
      
      // Clear success message after 3 seconds
      setTimeout(() => {
        setSuccessMessage('');
      }, 3000);
    } catch (error) {
      setError(error.message || 'Error adding medicine. Please try again.');
      console.error('Error adding medicine:', error);
    }
  };

  return (
    <div className="medicine-container">
      <div className="medicine-card">
        <div className="medicine-header">
          <h2>Manage Medicines</h2>
          {userName && <p>Welcome, Dr. {userName}</p>}
        </div>
        <div className="medicine-content">
          {error && (
            <div className="alert error">
              <span className="alert-icon">⚠</span>
              <p>{error}</p>
            </div>
          )}
          
          {successMessage && (
            <div className="alert success">
              <p>{successMessage}</p>
            </div>
          )}
          
          <div className="input-group">
            <input
              type="text"
              value={newMedicine}
              onChange={(e) => setNewMedicine(e.target.value)}
              placeholder="Enter medicine name"
              className="medicine-input"
              disabled={!doctorId}
            />
            <button 
              onClick={handleAddMedicine}
              className="add-button"
              disabled={!newMedicine.trim() || !doctorId || loading}
            >
              {loading ? 'Adding...' : '+ Add Medicine'}
            </button>
          </div>

          {loading ? (
            <div className="loading-message">
              <p>Loading medicines...</p>
            </div>
          ) : (
            <div className="medicine-list-container">
              <h3>Your Medicine List</h3>
              <div className="medicine-list">
                {medicinesList.length === 0 ? (
                  <p>No medicines added yet</p>
                ) : (
                  medicinesList.map((medicine, index) => (
                    <div 
                      key={medicine.id || index}
                      className="medicine-item"
                    >
                      {medicine.name}
                    </div>
                  ))
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default MedicineManagement;