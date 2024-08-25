// import React, { useEffect, useState } from "react";
// import { FaBars, FaTimes } from 'react-icons/fa';
// import { navLinks } from "../constants";
// import "../styles/navbar.css";

// const Navbar = () => {
//   const [active, setActive] = useState("");
//   const [toggle, setToggle] = useState(false);
//   const [scrolled, setScrolled] = useState(false);

//   useEffect(() => {
//     const handleScroll = () => {
//       const scrollTop = window.scrollY;
//       setScrolled(scrollTop > 100);
//     };

//     window.addEventListener("scroll", handleScroll);

//     return () => window.removeEventListener("scroll", handleScroll);
//   }, []);

//   return (
//     <nav className={`navbar ${scrolled ? "navbar-scrolled" : ""}`}>
//       <div className="navbar-content">
//         <div className="navbar-logo">
//           <div>
//             <h1>Ronit Kothari</h1>
//           </div>
//         </div>

//         <div className="navbar-links">
//           <ul>
//             {navLinks.map((nav) => (
//               <li key={nav.id}>
//                 <a
//                   href={`#${nav.id}`}
//                   className={active === nav.title ? "active" : ""}
//                   onClick={() => setActive(nav.title)}
//                 >
//                   {nav.title}
//                 </a>
//               </li>
//             ))}
//           </ul>
//         </div>

//         <div className="navbar-menu">
//           {toggle ? (
//             <FaTimes
//               className="menu-icon"
//               onClick={() => setToggle(false)}
//             />
//           ) : (
//             <FaBars
//               className="menu-icon"
//               onClick={() => setToggle(true)}
//             />
//           )}
//         </div>
//       </div>

//       <div className={`navbar-mobile-menu ${toggle ? "active" : ""}`}>
//         <ul>
//           {navLinks.map((nav) => (
//             <li key={nav.id}>
//               <a
//                 href={`#${nav.id}`}
//                 className={active === nav.title ? "active" : ""}
//                 onClick={() => {
//                   setToggle(false);
//                   setActive(nav.title);
//                 }}
//               >
//                 {nav.title}
//               </a>
//             </li>
//           ))}
//         </ul>
//       </div>
//     </nav>
//   );
// };

// export default Navbar;

// import React, { useEffect, useState } from "react";
// import { FaBars, FaTimes } from 'react-icons/fa';
// import { navLinks } from "../constants";
// import "../styles/navbar.css";
// import { useAuth } from './authcontext';

// const Navbar = () => {
//   const [active, setActive] = useState("");
//   const [toggle, setToggle] = useState(false);
//   const [scrolled, setScrolled] = useState(false);
//   const { isAuthenticated, userName, logout } = useAuth();
  
//   console.log('Navbar rendered with:', { isAuthenticated, userName });

//   useEffect(() => {
//     const handleScroll = () => {
//       const scrollTop = window.scrollY;
//       setScrolled(scrollTop > 100);
//     };

//     window.addEventListener("scroll", handleScroll);

//     return () => window.removeEventListener("scroll", handleScroll);
//   }, []);
 

//   return (
//     <nav className={`navbar ${scrolled ? "navbar-scrolled" : ""}`}>
//       <div className="navbar-content">
//         <div className="navbar-logo">
//           <div>
//             <h1>{isAuthenticated ? `Welcome, ${userName}` : "Welcome"}</h1>
//           </div>
//         </div>

//         <div className="navbar-links">
//           <ul>
//             {navLinks.map((nav) => (
//               <li key={nav.id}>
//                 <a
//                   href={`#${nav.id}`}
//                   className={active === nav.title ? "active" : ""}
//                   onClick={() => setActive(nav.title)}
//                 >
//                   {nav.title}
//                 </a>
//               </li>
//             ))}
//             {isAuthenticated && (
//               <li>
//                 <a
//                   href="#"
//                   onClick={(e) => {
//                     e.preventDefault();
//                     logout();
//                   }}
//                 >
//                   Logout
//                 </a>
//               </li>
//             )}
//           </ul>
//         </div>

//         <div className="navbar-menu">
//           {toggle ? (
//             <FaTimes
//               className="menu-icon"
//               onClick={() => setToggle(false)}
//             />
//           ) : (
//             <FaBars
//               className="menu-icon"
//               onClick={() => setToggle(true)}
//             />
//           )}
//         </div>
//       </div>

//       <div className={`navbar-mobile-menu ${toggle ? "active" : ""}`}>
//         <ul>
//           {navLinks.map((nav) => (
//             <li key={nav.id}>
//               <a
//                 href={`#${nav.id}`}
//                 className={active === nav.title ? "active" : ""}
//                 onClick={() => {
//                   setToggle(false);
//                   setActive(nav.title);
//                 }}
//               >
//                 {nav.title}
//               </a>
//             </li>
//           ))}
//           {isAuthenticated && (
//             <li>
//               <a
//                 href="#"
//                 onClick={(e) => {
//                   e.preventDefault();
//                   logout();
//                   setToggle(false);
//                 }}
//               >
//                 Logout
//               </a>
//             </li>
//           )}
//         </ul>
//       </div>
//     </nav>
//   );
// };

// export default Navbar;

import React, { useEffect, useState } from "react";
import { FaBars, FaTimes } from 'react-icons/fa';
import { navLinks } from "../constants";
import "../styles/navbar.css";
import { useAuth } from './authcontext';

const Navbar = () => {
  const [active, setActive] = useState("");
  const [toggle, setToggle] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const { isAuthenticated, userName, logout } = useAuth();

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 100);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const handleNavLinkClick = (title) => {
    setActive(title);
    setToggle(false);
  };

  const handleLogout = (e) => {
    e.preventDefault();
    logout();
    setToggle(false);
  };

  return (
    <nav className={`navbar ${scrolled ? "navbar-scrolled" : ""}`}>
      <div className="navbar-content">
        <div className="navbar-logo">
          <h1>{isAuthenticated ? `Welcome, ${userName}` : "Welcome"}</h1>
        </div>

        <ul className={`navbar-links ${toggle ? "navbar-links-active" : ""}`}>
          {navLinks.map((nav) => (
            <li key={nav.id}>
              <a
                href={`#${nav.id}`}
                className={active === nav.title ? "active" : ""}
                onClick={() => handleNavLinkClick(nav.title)}
              >
                {nav.title}
              </a>
            </li>
          ))}
          {isAuthenticated && (
            <li>
              <a href="#" onClick={handleLogout}>Logout</a>
            </li>
          )}
        </ul>

        <div className="navbar-menu">
          {toggle ? (
            <FaTimes className="menu-icon" onClick={() => setToggle(false)} />
          ) : (
            <FaBars className="menu-icon" onClick={() => setToggle(true)} />
          )}
        </div>
      </div>

      {toggle && (
        <div className="navbar-mobile-menu">
          <ul>
            {navLinks.map((nav) => (
              <li key={nav.id}>
                <a
                  href={`#${nav.id}`}
                  className={active === nav.title ? "active" : ""}
                  onClick={() => handleNavLinkClick(nav.title)}
                >
                  {nav.title}
                </a>
              </li>
            ))}
            {isAuthenticated && (
              <li>
                <a href="#" onClick={handleLogout}>Logout</a>
              </li>
            )}
          </ul>
        </div>
      )}
    </nav>
  );
};

export default Navbar;
