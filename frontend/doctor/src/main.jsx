// import { StrictMode } from 'react'
// import { createRoot } from 'react-dom/client'
// import App from './App'
// createRoot(document.getElementById('root')).render(
//   <StrictMode>
//     <App />
//   </StrictMode>,
// )
// import React from 'react';
// import ReactDOM from 'react-dom/client';
// import App from './App';
// import { BrowserRouter as Router } from 'react-router-dom';
// import './styles/login.css';  // Import your CSS here

// const root = ReactDOM.createRoot(document.getElementById('root'));

// root.render(
//   <React.StrictMode>
//     <Router>
//       <App />
//     </Router>
//   </React.StrictMode>
// );

import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import { BrowserRouter as Router } from 'react-router-dom';
import { AuthProvider } from './components/authcontext'; // Import AuthProvider
import './styles/login.css';  // Import your CSS here

const root = ReactDOM.createRoot(document.getElementById('root'));

root.render(
  <React.StrictMode>
    <Router>
      <AuthProvider> {/* Wrap App with AuthProvider */}
        <App />
      </AuthProvider>
    </Router>
  </React.StrictMode>
);
