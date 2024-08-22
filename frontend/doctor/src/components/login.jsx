// App.js
import React from 'react';
import "../styles/login.css";
import {
  MDBBtn,
  MDBContainer,
  MDBRow,
  MDBCol,
  MDBCard,
  MDBCardBody,
  MDBInput,
} from 'mdb-react-ui-kit';

function App() {
  return (
    <MDBContainer fluid className="login-container">
      <MDBRow className='w-100'>
        <MDBCol className="d-flex justify-content-center align-items-center">
          <MDBCard className='login-card'>
            <MDBCardBody className='p-5'>
              <h2 className="fw-bold mb-5 text-center">Welcome Back</h2>
              <p className="text-muted mb-4 text-center">Please enter your login details</p>
              
              <MDBInput wrapperClass='mb-4' placeholder='Email Address' id='emailInput' type='email' size='lg'/>
              <MDBInput wrapperClass='mb-4' placeholder='Password' id='passwordInput' type='password' size='lg'/>
              
              <div className="d-flex justify-content-between mb-4">
                <a href="#!" className="text-primary">Forgot password?</a>
              </div>
              <button className="w-2500 mb-4 btn-primary" size='lg'>Sign In</button>

              {/* <MDBBtn className="w-100 mb-4 btn-primary" size='lg'>
                Sign in
              </MDBBtn> */}

             
            </MDBCardBody>
          </MDBCard>
        </MDBCol>
      </MDBRow>
    </MDBContainer>
  );
}

export default App;