// import React from 'react';
// import { medicines } from '../constants'; // Import the medicines list

// const Medication = ({ 
//   prescription, 
//   setPrescription, 
//   suggestions, 
//   setSuggestions, 
//   activeSuggestionIndex, 
//   setActiveSuggestionIndex 
// }) => {
//   const handleInputChange = (e, index) => {
//     const { name, value, type, checked } = e.target;
    
//     const newMedications = prescription.medications.map((medication, i) => {
//       if (i === index) {
//         return { 
//           ...medication, 
//           [name.split('.')[1]]: type === 'checkbox' ? checked : value 
//         };
//       }
//       return medication;
//     });
//     setPrescription(prevState => ({ ...prevState, medications: newMedications }));

//     if (name.endsWith('medicine')) {
//       if (value.length > 0) {
//         const filteredSuggestions = medicines.filter(med => 
//           med.toLowerCase().startsWith(value.toLowerCase())
//         );
//         setSuggestions(filteredSuggestions);
//         setActiveSuggestionIndex(index);
//       } else {
//         setSuggestions([]);
//         setActiveSuggestionIndex(null);
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

//   return (
//     <div className="table-responsive">
//       <table className="medication-table">
//         <thead>
//           <tr>
//             <th>Medicine</th>
//             <th>Dosage</th>
//             <th>Morning</th>
//             <th>Afternoon</th>
//             <th>Night</th>
//             <th>Duration</th>
//             <th>Timing</th>
//             <th></th>
//           </tr>
//         </thead>
//         <tbody>
//           {prescription.medications.map((medication, index) => (
//             <tr key={index}>
//               <td>
//                 <div className="autocomplete">
//                   <input
//                     type="text"
//                     name={`medication.medicine`}
//                     value={medication.medicine}
//                     onChange={(e) => handleInputChange(e, index)}
//                     placeholder="Medicine name"
//                     className="form-control"
//                     onBlur={() => setTimeout(() => setActiveSuggestionIndex(null), 200)}
//                   />
//                   {activeSuggestionIndex === index && suggestions.length > 0 && (
//                     <ul className="suggestions">
//                       {suggestions.map((suggestion, i) => (
//                         <li key={i} onClick={() => handleSuggestionClick(suggestion, index)}>
//                           {suggestion}
//                         </li>
//                       ))}
//                     </ul>
//                   )}
//                 </div>
//               </td>
//               <td>
//                 <input
//                   type="text"
//                   name={`medication.dosage`}
//                   value={medication.dosage}
//                   onChange={(e) => handleInputChange(e, index)}
//                   placeholder="e.g., 500mg"
//                   className="form-control"
//                 />
//               </td>
//               <td>
//                 <input
//                   type="checkbox"
//                   name={`medication.morning`}
//                   checked={medication.morning}
//                   onChange={(e) => handleInputChange(e, index)}
//                   className="form-check-input"
//                 />
//               </td>
//               <td>
//                 <input
//                   type="checkbox"
//                   name={`medication.afternoon`}
//                   checked={medication.afternoon}
//                   onChange={(e) => handleInputChange(e, index)}
//                   className="form-check-input"
//                 />
//               </td>
//               <td>
//                 <input
//                   type="checkbox"
//                   name={`medication.night`}
//                   checked={medication.night}
//                   onChange={(e) => handleInputChange(e, index)}
//                   className="form-check-input"
//                 />
//               </td>
//               <td>
//                 <input
//                   type="text"
//                   name={`medication.duration`}
//                   value={medication.duration}
//                   onChange={(e) => handleInputChange(e, index)}
//                   placeholder="e.g., 7 days"
//                   className="form-control"
//                 />
//               </td>
//               <td>
//                 <select
//                   name={`medication.timing`}
//                   value={medication.timing}
//                   onChange={(e) => handleInputChange(e, index)}
//                   className="form-control"
//                 >
//                   <option value="">Select timing</option>
//                   <option value="Before Meal">Before Meal</option>
//                   <option value="After Meal">After Meal</option>
//                 </select>
//               </td>
//               <td>
//                 <button
//                   type="button"
//                   onClick={() => handleRemoveMedication(index)}
//                   className="btn btn-danger btn-sm"
//                 >Remove</button>
//               </td>
//             </tr>
//           ))}
//         </tbody>
//       </table>

//       <button type="button" onClick={handleAddMedication} className="btn btn-primary btn-sm">Add Medication</button>
//     </div>
//   );
// };

// export default Medication;

import React from 'react';

const Medication = ({ 
  prescription, 
  setPrescription, 
  suggestions, 
  setSuggestions, 
  activeSuggestionIndex, 
  setActiveSuggestionIndex 
}) => {
  const handleInputChange = async (e, index) => {
    const { name, value, type, checked } = e.target;
    
    const newMedications = prescription.medications.map((medication, i) => {
      if (i === index) {
        return { 
          ...medication, 
          [name.split('.')[1]]: type === 'checkbox' ? checked : value 
        };
      }
      return medication;
    });
    setPrescription(prevState => ({ ...prevState, medications: newMedications }));

    if (name.endsWith('medicine')) {
      if (value.length > 0) {
        try {
          const doctorId = localStorage.getItem('doctor_id');
          const response = await fetch(`http://localhost:5000/api/medicines/search?query=${value}&doctorId=${doctorId}`);
          const data = await response.json();
          
          if (data.success) {
            setSuggestions(data.data);
            setActiveSuggestionIndex(index);
          } else {
            setSuggestions([]);
            console.error('Failed to fetch suggestions:', data.message);
          }
        } catch (error) {
          console.error('Error fetching suggestions:', error);
          setSuggestions([]);
        }
      } else {
        setSuggestions([]);
        setActiveSuggestionIndex(null);
      }
    }
  };

  const handleSuggestionClick = (suggestion, index) => {
    const newMedications = prescription.medications.map((medication, i) => {
      if (i === index) {
        return { ...medication, medicine: suggestion };
      }
      return medication;
    });
    setPrescription(prevState => ({ ...prevState, medications: newMedications }));
    setSuggestions([]);
    setActiveSuggestionIndex(null);
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

  return (
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
                <div className="autocomplete">
                  <input
                    type="text"
                    name={`medication.medicine`}
                    value={medication.medicine}
                    onChange={(e) => handleInputChange(e, index)}
                    placeholder="Medicine name"
                    className="form-control"
                    onBlur={() => setTimeout(() => setActiveSuggestionIndex(null), 200)}
                  />
                  {activeSuggestionIndex === index && suggestions.length > 0 && (
                    <ul className="suggestions">
                      {suggestions.map((suggestion, i) => (
                        <li key={i} onClick={() => handleSuggestionClick(suggestion, index)}>
                          {suggestion}
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              </td>
              <td>
                <input
                  type="text"
                  name={`medication.dosage`}
                  value={medication.dosage}
                  onChange={(e) => handleInputChange(e, index)}
                  placeholder="e.g., 500mg"
                  className="form-control"
                />
              </td>
              <td>
                <input
                  type="checkbox"
                  name={`medication.morning`}
                  checked={medication.morning}
                  onChange={(e) => handleInputChange(e, index)}
                  className="form-check-input"
                />
              </td>
              <td>
                <input
                  type="checkbox"
                  name={`medication.afternoon`}
                  checked={medication.afternoon}
                  onChange={(e) => handleInputChange(e, index)}
                  className="form-check-input"
                />
              </td>
              <td>
                <input
                  type="checkbox"
                  name={`medication.night`}
                  checked={medication.night}
                  onChange={(e) => handleInputChange(e, index)}
                  className="form-check-input"
                />
              </td>
              <td>
                <input
                  type="text"
                  name={`medication.duration`}
                  value={medication.duration}
                  onChange={(e) => handleInputChange(e, index)}
                  placeholder="e.g., 7 days"
                  className="form-control"
                />
              </td>
              <td>
                <select
                  name={`medication.timing`}
                  value={medication.timing}
                  onChange={(e) => handleInputChange(e, index)}
                  className="form-control"
                >
                  <option value="">Select timing</option>
                  <option value="Before Meal">Before Meal</option>
                  <option value="After Meal">After Meal</option>
                </select>
              </td>
              <td>
                <button
                  type="button"
                  onClick={() => handleRemoveMedication(index)}
                  className="btn btn-danger btn-sm"
                >Remove</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <button type="button" onClick={handleAddMedication} className="btn btn-primary btn-sm">Add Medication</button>
    </div>
  );
};

export default Medication;