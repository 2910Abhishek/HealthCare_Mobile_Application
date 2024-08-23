import React from 'react';
import Navbar from './Navbar';
import { useAuth } from './authcontext'; // Adjust the path as needed


function Dashboard() {
  const { isAuthenticated, userName } = useAuth();
  console.log('Dashboard rendered with:', { isAuthenticated, userName });
  return (
    <div className="dashboard-container">
      <Navbar/>
      {/* Add more content here */}
    </div>
  );
}

export default Dashboard;
