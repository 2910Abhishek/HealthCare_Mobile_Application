


// import React from 'react';
// import { Route, Routes, Navigate } from 'react-router-dom';
// import Login from './components/login';
// import Dashboard from './components/dashboard';
// import { useAuth } from './components/authcontext'; // Adjust the path as needed

// function App() {
//   const { isAuthenticated } = useAuth();

//   return (
//     <Routes>
//       <Route path="/" element={<Login />} />
//       <Route 
//         path="/dashboard" 
//         element={isAuthenticated ? <Dashboard /> : <Navigate to="/" />} 
//       />
//     </Routes>
//   );
// }

// export default App;


// import React from 'react';
// import { Route, Routes, Navigate } from 'react-router-dom';
// import Login from './components/login';
// import Dashboard from './components/dashboard';
// import PatientDetail from './components/PatientDetail'; // Import the PatientDetail component
// import { useAuth } from './components/authcontext'; // Adjust the path as needed

// function App() {
//   const { isAuthenticated } = useAuth();

//   return (
//     <Routes>
//       <Route path="/" element={<Login />} />
//       <Route 
//         path="/dashboard" 
//         element={isAuthenticated ? <Dashboard /> : <Navigate to="/" />} 
//       />
//       <Route 
//         path="/patient/:patientId" 
//         element={isAuthenticated ? <PatientDetail /> : <Navigate to="/" />} 
//       />
//     </Routes>
//   );
// }

// export default App;



import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';
import Login from './components/login';
import Dashboard from './components/dashboard';
import PatientDetail from './components/PatientDetail';
import TimeSlotManager from './components/Timeslot';
import Navbar from './components/Navbar';
import { useAuth } from './components/authcontext';

function App() {
  const { isAuthenticated } = useAuth();

  return (
    <div className="app">
      {isAuthenticated && <Navbar />}
      <Routes>
        <Route path="/" element={<Login />} />
        <Route
          path="/dashboard"
          element={isAuthenticated ? <Dashboard /> : <Navigate to="/" />}
        />
        <Route
          path="/patient/:patientId"
          element={isAuthenticated ? <PatientDetail /> : <Navigate to="/" />}
        />
        <Route
          path="/manage-time-slots"
          element={isAuthenticated ? <TimeSlotManager /> : <Navigate to="/" />}
        />
      </Routes>
    </div>
  );
}

export default App;