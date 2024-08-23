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

import React, { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userName, setUserName] = useState('');

  useEffect(() => {
    console.log('AuthContext state updated:', { isAuthenticated, userName });
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