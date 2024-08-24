import React from 'react';
import Navbar from './Navbar';
import { useAuth } from './authcontext';
import PatientList from './PatientList';
 // Adjust the path as needed


function Dashboard() {
  const { isAuthenticated, userName } = useAuth();
  console.log('Dashboard rendered with:', { isAuthenticated, userName });
  if (!isAuthenticated) {
    // If the user is not authenticated, redirect to the login page
    return <Navigate to="/login" />;
  }
  return (
    <div className="dashboard-container">
      <Navbar/>
      <PatientList/>
      {/* Add more content here */}
    </div>
  );
}

export default Dashboard;
