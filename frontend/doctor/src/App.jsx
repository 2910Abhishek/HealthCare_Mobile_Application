// import { useState } from 'react'
// import Login from "./components/login"
// import { Route, Routes } from 'react-router-dom';
// import Dashboard from './components/dashboard';



// function App() {
  

//   return (
//     <Routes>
//       <Route path="/" element={<Login />} />
//       <Route path="/dashboard" element={<Dashboard />} />
//     </Routes>
   
//   )
// }

// export default App


import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';
import Login from './components/login';
import Dashboard from './components/dashboard';
import { useAuth } from './components/authcontext'; // Adjust the path as needed

function App() {
  const { isAuthenticated } = useAuth();

  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route 
        path="/dashboard" 
        element={isAuthenticated ? <Dashboard /> : <Navigate to="/" />} 
      />
    </Routes>
  );
}

export default App;

