// import React, { createContext, useContext, useState, useEffect } from 'react';

// const AuthContext = createContext();

// export const AuthProvider = ({ children }) => {
//   const [isAuthenticated, setIsAuthenticated] = useState(() => {
//     return localStorage.getItem('isAuthenticated') === 'true';
//   });

//   useEffect(() => {
//     localStorage.setItem('isAuthenticated', isAuthenticated.toString());
//   }, [isAuthenticated]);

//   const login = () => setIsAuthenticated(true);
//   const logout = () => setIsAuthenticated(false);

//   return (
//     <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
//       {children}
//     </AuthContext.Provider>
//   );
// };

// export const useAuth = () => useContext(AuthContext);

// import React, { createContext, useContext, useState, useEffect } from 'react';

// const AuthContext = createContext();

// export const AuthProvider = ({ children }) => {
//   const [isAuthenticated, setIsAuthenticated] = useState(false);
//   const [userName, setUserName] = useState('');

//   useEffect(() => {
//     console.log('AuthContext state updated:', { isAuthenticated, userName });
//   }, [isAuthenticated, userName]);

//   const login = (name) => {
//     console.log('Login function called with name:', name);
//     setIsAuthenticated(true);
//     setUserName(name);
//   };

//   const logout = () => {
//     console.log('Logout function called');
//     setIsAuthenticated(false);
//     setUserName('');
//   };

//   return (
//     <AuthContext.Provider value={{ isAuthenticated, userName, login, logout }}>
//       {children}
//     </AuthContext.Provider>
//   );
// };

// export const useAuth = () => {
//   const context = useContext(AuthContext);
//   console.log('useAuth hook called, returning:', context);
//   return context;
// };

import React, { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    // Load initial authentication state from localStorage
    const storedAuth = localStorage.getItem('isAuthenticated');
    return storedAuth === 'true'; // Convert string to boolean
  });
  
  const [userName, setUserName] = useState(() => {
    // Load initial user name from localStorage
    return localStorage.getItem('userName') || '';
  });

  useEffect(() => {
    // Store authentication state and username in localStorage whenever they change
    localStorage.setItem('isAuthenticated', isAuthenticated);
    localStorage.setItem('userName', userName);
  }, [isAuthenticated, userName]);

  const login = (name) => {
    console.log('Login function called with name:', name);
    setIsAuthenticated(true);
    setUserName(name);
  };

  const logout = () => {
    console.log('Logout function called');
    setIsAuthenticated(false);
    setUserName('');
    // Clear localStorage on logout
    localStorage.removeItem('isAuthenticated');
    localStorage.removeItem('userName');
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, userName, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  console.log('useAuth hook called, returning:', context);
  return context;
};
