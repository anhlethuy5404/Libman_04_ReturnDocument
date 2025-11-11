<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.libman.model.User" %>

<%-- Check if user is logged in --%>
<% 
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>

<html>
<head>
    <title>Library Management System</title>
    <style>
        /* Light Blue Theme - Library Management System */

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f0f7ff;
  color: #1a3a52;
  line-height: 1.6;
}

.header {
  background: linear-gradient(135deg, #0d47a1 0%, #1976d2 100%);
  color: white;
  padding: 24px 32px;
  border-bottom: 4px solid #0d3f8f;
  box-shadow: 0 2px 8px rgba(13, 71, 161, 0.1);
  margin-bottom: 40px;
}

.header div {
  font-size: 18px;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.header strong {
  font-weight: 700;
  color: #e3f2fd;
}

h1 {
  font-size: 36px;
  color: #0d47a1;
  margin-bottom: 32px;
  padding: 0 32px;
  font-weight: 700;
  letter-spacing: -0.5px;
}

h3 {
  font-size: 20px;
  color: #1565c0;
  margin-bottom: 20px;
  padding: 0 32px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-size: 14px;
}

ul {
  list-style: none;
  padding: 0 32px;
  margin-bottom: 40px;
}

li {
  background: white;
  margin-bottom: 12px;
  border-left: 4px solid #1976d2;
  padding: 16px 20px;
  border-radius: 4px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px rgba(13, 71, 161, 0.08);
}

li:hover {
  box-shadow: 0 4px 12px rgba(13, 71, 161, 0.15);
  transform: translateX(4px);
  border-left-color: #0d47a1;
}

a {
  color: #1565c0;
  text-decoration: none;
  font-weight: 600;
  font-size: 16px;
  transition: color 0.2s ease;
}

a:hover {
  color: #0d47a1;
  text-decoration: underline;
}

li a {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

li:hover a::after {
  opacity: 1;
}
    </style>
</head>
<body>
    <div class="header">
        <div>Hello, <strong><%= user.getName() %></strong>!</div>
    </div>

    <h1>Welcome to Library Management System</h1>

    <h3>Features</h3>
    <ul>
        <% if ("READER".equals(user.getRole())) { %>
            <li><a href="CardRegistration.jsp">Register Reader Card</a></li>
            <%-- Add other READER functions here --%>
        <% } else if ("LIBRARIAN".equals(user.getRole())) { %>
            <li><a href="DocumentReturnFrm.jsp">Return Book</a></li>
        <% } else if ("MANAGER".equals(user.getRole())) { %>

        <% } %>
    </ul>

</body>
</html>
