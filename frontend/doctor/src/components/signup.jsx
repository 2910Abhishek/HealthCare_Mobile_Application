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
  const [generalError, setGeneralError] = useState("");
  const [inputErrors, setInputErrors] = useState({
    fullName: "",
    userEmail: "",
    userPassword: "",
  });

  const { login } = useAuth();
  const navigate = useNavigate();

  // Initialize Socket.IO connection
  useEffect(() => {
    // Create socket connection
    const socket = io("http://localhost:5000", {
      transports: ["websocket"],
      autoConnect: true,
    });

    // Connection event handlers
    socket.on("connect", () => {
      console.log("Connected to Socket.IO server");
    });

    socket.on("disconnect", () => {
      console.log("Disconnected from Socket.IO server");
    });

    // Listen for new doctor registration events
    socket.on("new_doctor_registered", (doctorData) => {
      console.log("New doctor registered:", doctorData);
      // You can handle the received doctor data here if needed
      // For example, you might want to show a success message or
      // store the data in context/state
    });

    // Cleanup on component unmount
    return () => {
      socket.disconnect();
    };
  }, []);

  const handleSignUp = async () => {
    let isValid = true;
    const newInputErrors = { fullName: "", userEmail: "", userPassword: "" };

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

    setInputErrors(newInputErrors);

    if (!isValid) {
      setGeneralError("Please fill in all required fields.");
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
        // The Socket.IO server will automatically emit the doctor details after 2 seconds
        // We can navigate to dashboard immediately since the socket will handle the data
        navigate("/dashboard");
      } else {
        setGeneralError(data.error || "Registration failed");
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