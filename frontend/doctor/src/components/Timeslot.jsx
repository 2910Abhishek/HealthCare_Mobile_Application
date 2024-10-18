// import React, { useState, useEffect } from 'react';
// import { useAuth } from './authcontext';
// import '../styles/timeslot.css';

// const TimeSlotManager = () => {
//   const { userName } = useAuth();
//   const [selectedDate, setSelectedDate] = useState(new Date());
//   const [availableSlots, setAvailableSlots] = useState({});
//   const [loading, setLoading] = useState(false);
//   const [error, setError] = useState(null);
//   const [successMessage, setSuccessMessage] = useState('');
  
//   const timeSlots = [
//     "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
//     "11:00 AM", "11:30 AM", "12:00 PM", "02:00 PM",
//     "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM",
//     "04:30 PM", "05:00 PM"
//   ];

//   const formatDate = (date) => {
//     return date.toISOString().split('T')[0];
//   };

//   useEffect(() => {
//     loadDoctorSlots();
//   }, []);

//   const loadDoctorSlots = async () => {
//     try {
//       setLoading(true);
//       const response = await fetch(
//         `http://localhost:5000/get-doctor-slots?doctorId=${localStorage.getItem('doctor_id')}`
//       );
//       if (response.ok) {
//         const data = await response.json();
//         setAvailableSlots(data);
//       } else {
//         throw new Error('Failed to load time slots');
//       }
//     } catch (error) {
//       setError('Failed to load time slots. Please try again.');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const handleDateSelect = (date) => {
//     setSelectedDate(date);
//     setSuccessMessage('');
//   };

//   const handleSlotToggle = (slot) => {
//     const dateKey = formatDate(selectedDate);
//     setAvailableSlots(prev => ({
//       ...prev,
//       [dateKey]: {
//         ...prev[dateKey],
//         [slot]: !prev[dateKey]?.[slot]
//       }
//     }));
//   };

//   const handleSaveSchedule = async () => {
//     try {
//       setLoading(true);
//       setError(null);
//       const dateKey = formatDate(selectedDate);
//       const selectedSlots = availableSlots[dateKey] || {};
      
//       const scheduleData = {
//         doctorId: localStorage.getItem('doctor_id'),
//         date: dateKey,
//         availableSlots: Object.entries(selectedSlots)
//           .filter(([_, isAvailable]) => isAvailable)
//           .map(([slot]) => slot)
//       };

//       const response = await fetch('http://localhost:5000/add-time-slots', {
//         method: 'POST',
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: JSON.stringify(scheduleData)
//       });

//       if (response.ok) {
//         const result = await response.json();
//         setSuccessMessage('Schedule saved successfully!');
//         await loadDoctorSlots();
//       } else {
//         throw new Error('Failed to save schedule');
//       }
//     } catch (error) {
//       setError('Failed to save schedule. Please try again.');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const currentDateSlots = availableSlots[formatDate(selectedDate)] || {};

//   return (
//     <div className="time-slot-manager">
//       {error && (
//         <div className="alert error">
//           <span className="alert-icon">⚠</span>
//           <p>{error}</p>
//         </div>
//       )}
      
//       {successMessage && (
//         <div className="alert success">
//           <p>{successMessage}</p>
//         </div>
//       )}

//       <div className="grid">
//         <div className="card">
//           <h2>Select Date</h2>
//           <input
//             type="date"
//             value={formatDate(selectedDate)}
//             onChange={(e) => handleDateSelect(new Date(e.target.value))}
//             min={formatDate(new Date())}
//           />
//         </div>

//         <div className="card">
//           <h2>Available Time Slots for {selectedDate.toLocaleDateString()}</h2>
//           <div className="time-slots">
//             {timeSlots.map(slot => (
//               <button
//                 key={slot}
//                 onClick={() => handleSlotToggle(slot)}
//                 disabled={loading}
//                 className={`time-slot ${currentDateSlots[slot] ? 'active' : ''} ${loading ? 'disabled' : ''}`}
//               >
//                 {slot}
//               </button>
//             ))}
//           </div>
          
//           <div className="save-button-container">
//             <button
//               onClick={handleSaveSchedule}
//               disabled={loading}
//               className={`save-button ${loading ? 'disabled' : ''}`}
//             >
//               {loading ? 'Saving...' : 'Save Available Slots'}
//             </button>
//           </div>
//         </div>
//       </div>

//       <div className="card summary">
//         <h2>Selected Time Slots Summary</h2>
//         <div className="summary-content">
//           {Object.entries(availableSlots).map(([date, slots]) => {
//             const selectedSlots = Object.entries(slots)
//               .filter(([_, isAvailable]) => isAvailable)
//               .map(([slot]) => slot);

//             if (selectedSlots.length === 0) return null;

//             return (
//               <div key={date} className="summary-item">
//                 <p className="summary-date">{new Date(date).toLocaleDateString()}</p>
//                 <div className="summary-slots">
//                   {selectedSlots.map(slot => (
//                     <span key={slot} className="summary-slot">
//                       {slot}
//                     </span>
//                   ))}
//                 </div>
//               </div>
//             );
//           })}
//         </div>
//       </div>
//     </div>
//   );
// };

// export default TimeSlotManager;

import React, { useState, useEffect } from 'react';
import { useAuth } from './authcontext';
import '../styles/timeslot.css';

const TimeSlotManager = () => {
  const { userName } = useAuth();
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [availableSlots, setAvailableSlots] = useState({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState('');
  
  const timeSlots = [
    "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
    "11:00 AM", "11:30 AM", "12:00 PM", "02:00 PM",
    "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM",
    "04:30 PM", "05:00 PM"
  ];

  const formatDate = (date) => {
    return date.toISOString().split('T')[0];
  };

  const isPreviousDate = (date) => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return new Date(date) < today;
  };

  useEffect(() => {
    loadDoctorSlots();
  }, []);

  const loadDoctorSlots = async () => {
    try {
      setLoading(true);
      const response = await fetch(
        `http://localhost:5000/get-doctor-slots?doctorId=${localStorage.getItem('doctor_id')}`
      );
      if (response.ok) {
        const data = await response.json();
        setAvailableSlots(data);
      } else {
        throw new Error('Failed to load time slots');
      }
    } catch (error) {
      setError('Failed to load time slots. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleDateSelect = (date) => {
    setSelectedDate(new Date(date));
    setSuccessMessage('');
    setError(null);
  };

  const handleSlotToggle = (slot) => {
    if (isPreviousDate(selectedDate)) {
      setError('Cannot modify slots for previous dates. Please select today or a future date.');
      return;
    }
    
    const dateKey = formatDate(selectedDate);
    setAvailableSlots(prev => ({
      ...prev,
      [dateKey]: {
        ...prev[dateKey],
        [slot]: !prev[dateKey]?.[slot]
      }
    }));
  };

  const handleSaveSchedule = async () => {
    if (isPreviousDate(selectedDate)) {
      setError('Cannot save slots for previous dates. Please select today or a future date.');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      const dateKey = formatDate(selectedDate);
      const selectedSlots = availableSlots[dateKey] || {};
      
      const scheduleData = {
        doctorId: localStorage.getItem('doctor_id'),
        date: dateKey,
        availableSlots: Object.entries(selectedSlots)
          .filter(([_, isAvailable]) => isAvailable)
          .map(([slot]) => slot)
      };

      const response = await fetch('http://localhost:5000/add-time-slots', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(scheduleData)
      });

      if (response.ok) {
        const result = await response.json();
        setSuccessMessage('Schedule saved successfully!');
        await loadDoctorSlots();
      } else {
        throw new Error('Failed to save schedule');
      }
    } catch (error) {
      setError('Failed to save schedule. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const currentDateSlots = availableSlots[formatDate(selectedDate)] || {};
  const isDatePrevious = isPreviousDate(selectedDate);

  return (
    <div className="page-container">
      <div className="time-slot-manager">
        <h1 className="page-title">Manage Time Slots</h1>
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

        <div className="grid">
          <div className="card">
            <h2>Select Date</h2>
            <input
              type="date"
              value={formatDate(selectedDate)}
              onChange={(e) => handleDateSelect(e.target.value)}
            />
          </div>

          <div className="card">
            <h2>Available Time Slots for {selectedDate.toLocaleDateString()}</h2>
            {isDatePrevious && (
              <div className="view-only-notice">
                Viewing previous date - modifications disabled
              </div>
            )}
            <div className="time-slots">
              {timeSlots.map(slot => (
                <button
                  key={slot}
                  onClick={() => handleSlotToggle(slot)}
                  disabled={loading || isDatePrevious}
                  className={`time-slot ${currentDateSlots[slot] ? 'active' : ''} ${(loading || isDatePrevious) ? 'disabled' : ''}`}
                >
                  {slot}
                </button>
              ))}
            </div>
            
            <div className="save-button-container">
              <button
                onClick={handleSaveSchedule}
                disabled={loading || isDatePrevious}
                className={`save-button ${(loading || isDatePrevious) ? 'disabled' : ''}`}
              >
                {loading ? 'Saving...' : 'Save Available Slots'}
              </button>
            </div>
          </div>
        </div>

        <div className="card summary">
          <h2>Selected Time Slots Summary</h2>
          <div className="summary-content">
            {Object.entries(availableSlots).map(([date, slots]) => {
              const selectedSlots = Object.entries(slots)
                .filter(([_, isAvailable]) => isAvailable)
                .map(([slot]) => slot);

              if (selectedSlots.length === 0) return null;

              return (
                <div key={date} className="summary-item">
                  <p className="summary-date">{new Date(date).toLocaleDateString()}</p>
                  <div className="summary-slots">
                    {selectedSlots.map(slot => (
                      <span key={slot} className="summary-slot">
                        {slot}
                      </span>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
};

export default TimeSlotManager;