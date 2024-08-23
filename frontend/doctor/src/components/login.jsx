

// import React, { useState } from 'react';
// import "../styles/login.css";
// import {
//   MDBBtn,
//   MDBContainer,
//   MDBRow,
//   MDBCol,
//   MDBCard,
//   MDBCardBody,
//   MDBInput,
// } from 'mdb-react-ui-kit';

// function Login() {
//   const [email, setEmail] = useState('');
//   const [password, setPassword] = useState('');
//   const [error, setError] = useState('');
//   const [fieldErrors, setFieldErrors] = useState({
//     email: '',
//     password: '',
//   });

//   const handleLogin = async () => {
//     let isValid = true;
//     const newFieldErrors = { email: '', password: '' };

//     if (!email) {
//       newFieldErrors.email = 'Email is required';
//       isValid = false;
//     }
//     if (!password) {
//       newFieldErrors.password = 'Password is required';
//       isValid = false;
//     }

//     setFieldErrors(newFieldErrors);

//     if (!isValid) {
//       setError('Please fill in all required fields.');
//       return;
//     }

//     try {
//       const response = await fetch('http://localhost:5000/login', {
//         method: 'POST',
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: JSON.stringify({ email, password }),
//       });

//       const data = await response.json();

//       if (response.ok) {
//         window.location.href = data.redirect;  // Redirect to the dashboard
//       } else {
//         setError(data.message);
//       }
//     } catch (err) {
//       console.error('Error:', err);
//       setError('Something went wrong');
//     }
//   };

//   const handleInputChange = (e) => {
//     const { id, value } = e.target;
//     if (id === 'emailInput') {
//       setEmail(value);
//       if (value) {
//         setFieldErrors((prevErrors) => ({ ...prevErrors, email: '' }));
//       }
//     } else if (id === 'passwordInput') {
//       setPassword(value);
//       if (value) {
//         setFieldErrors((prevErrors) => ({ ...prevErrors, password: '' }));
//       }
//     }
//   };

//   return (
//     <MDBContainer fluid className="login-container">
//       <MDBRow className='w-100'>
//         <MDBCol className="d-flex justify-content-center align-items-center">
//           <MDBCard className='login-card'>
//             <MDBCardBody className='p-5'>
//               <h2 className="fw-bold mb-5 text-center">Welcome Back</h2>
//               <p className="text-muted mb-4 text-center">Please enter your login details</p>
              
//               <MDBInput 
//                 wrapperClass='mb-4' 
//                 placeholder='Email Address' 
//                 id='emailInput' 
//                 type='email' 
//                 size='lg'
//                 value={email}
//                 onChange={handleInputChange}
//                 className={fieldErrors.email ? 'is-invalid' : ''}
//               />
//               {fieldErrors.email && <p className="text-danger">{fieldErrors.email}</p>}
              
//               <MDBInput 
//                 wrapperClass='mb-4' 
//                 placeholder='Password' 
//                 id='passwordInput' 
//                 type='password' 
//                 size='lg'
//                 value={password}
//                 onChange={handleInputChange}
//                 className={fieldErrors.password ? 'is-invalid' : ''}
//               />
//               {fieldErrors.password && <p className="text-danger">{fieldErrors.password}</p>}
              
//               <div className="d-flex justify-content-between mb-4">
//                 <a href="#!" className="text-primary">Forgot password?</a>
//               </div>
//               <button 
//                 className="w-2500 mb-4 btn-primary" 
//                 size='lg'
//                 onClick={handleLogin}
//               >
//                 Sign In
//               </button>

//               {error && <p className="text-danger text-center">{error}</p>}
//             </MDBCardBody>
//           </MDBCard>
//         </MDBCol>
//       </MDBRow>
//     </MDBContainer>
//   );
// }

// export default Login;


import React, { useState } from 'react';
import { useAuth } from './authcontext';
import { useNavigate } from 'react-router-dom';
import {
  MDBContainer,
  MDBRow,
  MDBCol,
  MDBCard,
  MDBCardBody,
  MDBInput,
} from 'mdb-react-ui-kit';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [fieldErrors, setFieldErrors] = useState({
    email: '',
    password: '',
  });

  const { login } = useAuth();
  const navigate = useNavigate();

  const handleLogin = async () => {
    let isValid = true;
    const newFieldErrors = { email: '', password: '' };

    if (!email) {
      newFieldErrors.email = 'Email is required';
      isValid = false;
    }
    if (!password) {
      newFieldErrors.password = 'Password is required';
      isValid = false;
    }

    setFieldErrors(newFieldErrors);

    if (!isValid) {
      setError('Please fill in all required fields.');
      return;
    }

    try {
      const response = await fetch('http://localhost:5000/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();

      if (response.ok) {
        login();
        navigate('/dashboard');
      } else {
        setError(data.message);
      }
    } catch (err) {
      console.error('Error:', err);
      setError('Something went wrong');
    }
  };

  const handleInputChange = (e) => {
    const { id, value } = e.target;
    if (id === 'emailInput') {
      setEmail(value);
      if (value) {
        setFieldErrors((prevErrors) => ({ ...prevErrors, email: '' }));
      }
    } else if (id === 'passwordInput') {
      setPassword(value);
      if (value) {
        setFieldErrors((prevErrors) => ({ ...prevErrors, password: '' }));
      }
    }
  };

  return (
    <MDBContainer fluid className="login-container">
      <MDBRow className='w-100'>
        <MDBCol className="d-flex justify-content-center align-items-center">
          <MDBCard className='login-card'>
            <MDBCardBody className='p-5'>
              <h2 className="fw-bold mb-5 text-center">Welcome Back</h2>
              <p className="text-muted mb-4 text-center">Please enter your login details</p>
              
              <MDBInput 
                wrapperClass='mb-4' 
                placeholder='Email Address' 
                id='emailInput' 
                type='email' 
                size='lg'
                value={email}
                onChange={handleInputChange}
                className={fieldErrors.email ? 'is-invalid' : ''}
              />
              {fieldErrors.email && <p className="text-danger">{fieldErrors.email}</p>}
              
              <MDBInput 
                wrapperClass='mb-4' 
                placeholder='Password' 
                id='passwordInput' 
                type='password' 
                size='lg'
                value={password}
                onChange={handleInputChange}
                className={fieldErrors.password ? 'is-invalid' : ''}
              />
              {fieldErrors.password && <p className="text-danger">{fieldErrors.password}</p>}
              
              <div className="d-flex justify-content-between mb-4">
                <a href="#!" className="text-primary">Forgot password?</a>
              </div>
              <button 
                className="w-100 mb-4 btn btn-primary" 
                size='lg'
                onClick={handleLogin}
              >
                Sign In
              </button>

              {error && <p className="text-danger text-center">{error}</p>}
            </MDBCardBody>
          </MDBCard>
        </MDBCol>
      </MDBRow>
    </MDBContainer>
  );
}

export default Login;