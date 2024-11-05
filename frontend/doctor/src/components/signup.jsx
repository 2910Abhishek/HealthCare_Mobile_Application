// import React, { useState } from "react";
// import { useAuth } from "./authcontext";
// import { useNavigate } from "react-router-dom";
// import "../styles/signup.css";

// function SignUpForm() {
//   const [fullName, setFullName] = useState("");
//   const [userEmail, setUserEmail] = useState("");
//   const [userPassword, setUserPassword] = useState("");
//   const [generalError, setGeneralError] = useState("");
//   const [inputErrors, setInputErrors] = useState({
//     fullName: "",
//     userEmail: "",
//     userPassword: "",
//   });

//   const { login } = useAuth();
//   const navigate = useNavigate();

//   const handleSignUp = async () => {
//     let isValid = true;
//     const newInputErrors = { fullName: "", userEmail: "", userPassword: "" };

//     if (!fullName) {
//       newInputErrors.fullName = "Full Name is required";
//       isValid = false;
//     }
//     if (!userEmail) {
//       newInputErrors.userEmail = "Email is required";
//       isValid = false;
//     }
//     if (!userPassword) {
//       newInputErrors.userPassword = "Password is required";
//       isValid = false;
//     }

//     setInputErrors(newInputErrors);

//     if (!isValid) {
//       setGeneralError("Please fill in all required fields.");
//       return;
//     }

//     try {
//       const response = await fetch("http://localhost:5000/register", {
//         method: "POST",
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: JSON.stringify({ name: fullName, email: userEmail, password: userPassword }),
//       });

//       const data = await response.json();

//       if (response.ok) {
//         login(data.user.name);
//         navigate("/dashboard");
//       } else {
//         setGeneralError(data.error || "Registration failed");
//       }
//     } catch (err) {
//       console.error("Error:", err);
//       setGeneralError("Something went wrong");
//     }
//   };

//   const handleInputChange = (e) => {
//     const { id, value } = e.target;
//     if (id === "fullNameInput") {
//       setFullName(value);
//       if (value) {
//         setInputErrors((prevErrors) => ({ ...prevErrors, fullName: "" }));
//       }
//     } else if (id === "userEmailInput") {
//       setUserEmail(value);
//       if (value) {
//         setInputErrors((prevErrors) => ({ ...prevErrors, userEmail: "" }));
//       }
//     } else if (id === "userPasswordInput") {
//       setUserPassword(value);
//       if (value) {
//         setInputErrors((prevErrors) => ({ ...prevErrors, userPassword: "" }));
//       }
//     }
//   };

//   return (
//     <div className="signup-container">
//       <div className="signup-form-container">
//         <div className="signup-form-box">
//           <h2>Create Account</h2>
//           <p className="signup-subtitle">Please enter your details to register</p>

//           <div className="signup-form-group">
//             <input
//               type="text"
//               id="fullNameInput"
//               placeholder="Full Name"
//               value={fullName}
//               onChange={handleInputChange}
//               className={inputErrors.fullName ? "signup-input-error" : ""}
//             />
//             {inputErrors.fullName && (
//               <span className="signup-error-text">{inputErrors.fullName}</span>
//             )}
//           </div>

//           <div className="signup-form-group">
//             <input
//               type="email"
//               id="userEmailInput"
//               placeholder="Email Address"
//               value={userEmail}
//               onChange={handleInputChange}
//               className={inputErrors.userEmail ? "signup-input-error" : ""}
//             />
//             {inputErrors.userEmail && (
//               <span className="signup-error-text">{inputErrors.userEmail}</span>
//             )}
//           </div>

//           <div className="signup-form-group">
//             <input
//               type="password"
//               id="userPasswordInput"
//               placeholder="Password"
//               value={userPassword}
//               onChange={handleInputChange}
//               className={inputErrors.userPassword ? "signup-input-error" : ""}
//             />
//             {inputErrors.userPassword && (
//               <span className="signup-error-text">{inputErrors.userPassword}</span>
//             )}
//           </div>

//           <button className="signup-btn" onClick={handleSignUp}>
//             Sign Up
//           </button>

//           {generalError && <p className="signup-error-message">{generalError}</p>}

//           <p className="signup-login-link">
//             Already have an account? <a href="/">Sign In</a>
//           </p>
//         </div>
//       </div>
//     </div>
//   );
// }

// export default SignUpForm;

import React, { useState, useEffect } from "react";
import { useAuth } from "./authcontext";
import { useNavigate } from "react-router-dom";
import { io } from "socket.io-client";
import "../styles/signup.css";

function SignUpForm() {
  const [fullName, setFullName] = useState("");
  const [userEmail, setUserEmail] = useState("");
  const [userPassword, setUserPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [generalError, setGeneralError] = useState("");
  const [inputErrors, setInputErrors] = useState({
    fullName: "",
    userEmail: "",
    userPassword: "",
    confirmPassword: "",
  });
  
  const [passwordRequirements, setPasswordRequirements] = useState({
    length: false,
    number: false,
    uppercase: false,
    lowercase: false,
    special: false
  });

  const { login } = useAuth();
  const navigate = useNavigate();

  // Initialize Socket.IO connection
  useEffect(() => {
    const socket = io("http://localhost:5000", {
      transports: ["websocket"],
      autoConnect: true,
    });

    socket.on("connect", () => {
      console.log("Connected to Socket.IO server");
    });

    socket.on("disconnect", () => {
      console.log("Disconnected from Socket.IO server");
    });

    socket.on("new_doctor_registered", (doctorData) => {
      console.log("New doctor registered:", doctorData);
    });

    return () => {
      socket.disconnect();
    };
  }, []);

  // Password validation
  useEffect(() => {
    const requirements = {
      length: userPassword.length >= 8,
      number: /\d/.test(userPassword),
      uppercase: /[A-Z]/.test(userPassword),
      lowercase: /[a-z]/.test(userPassword),
      special: /[!@#$%^&*(),.?":{}|<>]/.test(userPassword)
    };
    
    setPasswordRequirements(requirements);
  }, [userPassword]);

  const getPasswordStrength = () => {
    const metRequirements = Object.values(passwordRequirements).filter(Boolean).length;
    if (metRequirements <= 2) return { text: "Weak", color: "#ff4d4f" };
    if (metRequirements <= 4) return { text: "Medium", color: "#faad14" };
    return { text: "Strong", color: "#52c41a" };
  };

  const handleSignUp = async () => {
    let isValid = true;
    const newInputErrors = {
      fullName: "",
      userEmail: "",
      userPassword: "",
      confirmPassword: ""
    };

    if (!fullName) {
      newInputErrors.fullName = "Full Name is required";
      isValid = false;
    }
    if (!userEmail) {
      newInputErrors.userEmail = "Email is required";
      isValid = false;
    }
    if (!userPassword) {
      newInputErrors.userPassword = "Password is required";
      isValid = false;
    }
    if (!confirmPassword) {
      newInputErrors.confirmPassword = "Please confirm your password";
      isValid = false;
    }
    if (userPassword !== confirmPassword) {
      newInputErrors.confirmPassword = "Passwords do not match";
      isValid = false;
    }

    // Check password requirements
    const metRequirements = Object.values(passwordRequirements).filter(Boolean).length;
    if (metRequirements < 5) {
      newInputErrors.userPassword = "Password does not meet all requirements";
      isValid = false;
    }

    setInputErrors(newInputErrors);

    if (!isValid) {
      setGeneralError("Please fill in all required fields correctly.");
      return;
    }

    try {
      const response = await fetch("http://localhost:5000/register", {
          method: "POST",
          headers: {
              "Content-Type": "application/json",
          },
          body: JSON.stringify({ 
              name: fullName, 
              email: userEmail, 
              password: userPassword 
          }),
      });
  
      const data = await response.json();
  
      if (response.ok) {
          login(data.user.name);
          navigate("/dashboard");
      } else {
          // Check specifically for email already exists error
          if (response.status === 400 && data.error === 'Email address already registered') {
              setInputErrors(prev => ({
                  ...prev,
                  userEmail: "This email is already registered"
              }));
          } else {
              setGeneralError(data.error || "Registration failed");
          }
      }
  } catch (err) {
      console.error("Error:", err);
      setGeneralError("Something went wrong");
  }
  };

  const handleInputChange = (e) => {
    const { id, value } = e.target;
    if (id === "fullNameInput") {
      setFullName(value);
      if (value) {
        setInputErrors((prevErrors) => ({ ...prevErrors, fullName: "" }));
      }
    } else if (id === "userEmailInput") {
      setUserEmail(value);
      if (value) {
        setInputErrors((prevErrors) => ({ ...prevErrors, userEmail: "" }));
      }
    } else if (id === "userPasswordInput") {
      setUserPassword(value);
      if (value) {
        setInputErrors((prevErrors) => ({ ...prevErrors, userPassword: "" }));
      }
    } else if (id === "confirmPasswordInput") {
      setConfirmPassword(value);
      if (value) {
        setInputErrors((prevErrors) => ({ ...prevErrors, confirmPassword: "" }));
      }
    }
  };

  return (
    <div className="signup-container">
      <div className="signup-form-container">
        <div className="signup-form-box">
          <h2>Create Account</h2>
          <p className="signup-subtitle">Please enter your details to register</p>

          <div className="signup-form-group">
            <input
              type="text"
              id="fullNameInput"
              placeholder="Full Name"
              value={fullName}
              onChange={handleInputChange}
              className={inputErrors.fullName ? "signup-input-error" : ""}
            />
            {inputErrors.fullName && (
              <span className="signup-error-text">{inputErrors.fullName}</span>
            )}
          </div>

          <div className="signup-form-group">
            <input
              type="email"
              id="userEmailInput"
              placeholder="Email Address"
              value={userEmail}
              onChange={handleInputChange}
              className={inputErrors.userEmail ? "signup-input-error" : ""}
            />
            {inputErrors.userEmail && (
              <span className="signup-error-text">{inputErrors.userEmail}</span>
            )}
          </div>

          <div className="signup-form-group">
            <input
              type="password"
              id="userPasswordInput"
              placeholder="Password"
              value={userPassword}
              onChange={handleInputChange}
              className={inputErrors.userPassword ? "signup-input-error" : ""}
            />
            {inputErrors.userPassword && (
              <span className="signup-error-text">{inputErrors.userPassword}</span>
            )}
            
            {userPassword && (
              <div className="password-requirements" style={{ marginTop: "10px", padding: "10px", backgroundColor: "#f5f5f5", borderRadius: "5px" }}>
                <div style={{ 
                  marginBottom: "8px", 
                  color: getPasswordStrength().color, 
                  fontWeight: "500" 
                }}>
                  Password Strength: {getPasswordStrength().text}
                </div>
                <div style={{ fontSize: "12px" }}>
                  <div style={{ 
                    color: passwordRequirements.length ? "#52c41a" : "#ff4d4f",
                    marginBottom: "4px"
                  }}>
                    • Minimum 8 characters {passwordRequirements.length ? "✓" : "✗"}
                  </div>
                  <div style={{ 
                    color: passwordRequirements.number ? "#52c41a" : "#ff4d4f",
                    marginBottom: "4px"
                  }}>
                    • Contains a number {passwordRequirements.number ? "✓" : "✗"}
                  </div>
                  <div style={{ 
                    color: passwordRequirements.uppercase ? "#52c41a" : "#ff4d4f",
                    marginBottom: "4px"
                  }}>
                    • Contains uppercase letter {passwordRequirements.uppercase ? "✓" : "✗"}
                  </div>
                  <div style={{ 
                    color: passwordRequirements.lowercase ? "#52c41a" : "#ff4d4f",
                    marginBottom: "4px"
                  }}>
                    • Contains lowercase letter {passwordRequirements.lowercase ? "✓" : "✗"}
                  </div>
                  <div style={{ 
                    color: passwordRequirements.special ? "#52c41a" : "#ff4d4f"
                  }}>
                    • Contains special character {passwordRequirements.special ? "✓" : "✗"}
                  </div>
                </div>
              </div>
            )}
          </div>

          <div className="signup-form-group">
            <input
              type="password"
              id="confirmPasswordInput"
              placeholder="Confirm Password"
              value={confirmPassword}
              onChange={handleInputChange}
              className={inputErrors.confirmPassword ? "signup-input-error" : ""}
            />
            {inputErrors.confirmPassword && (
              <span className="signup-error-text">{inputErrors.confirmPassword}</span>
            )}
          </div>

          <button className="signup-btn" onClick={handleSignUp}>
            Sign Up
          </button>

          {generalError && <p className="signup-error-message">{generalError}</p>}

          <p className="signup-login-link">
            Already have an account? <a href="/">Sign In</a>
          </p>
        </div>
      </div>
    </div>
  );
}

export default SignUpForm;