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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            padding: 20px;
        }

        .header {
            background-color: #2c3e50;
            color: white;
            padding: 15px 20px;
            border-radius: 5px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header a {
            color: #3498db;
            text-decoration: none;
            font-weight: bold;
        }

        .header a:hover {
            color: #2980b9;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
        }

        h3 {
            color: #3498db;
            margin-top: 20px;
            margin-bottom: 15px;
        }

        ul {
            list-style: none;
            padding-left: 0;
        }

        li {
            background-color: white;
            padding: 12px 15px;
            margin-bottom: 10px;
            border-left: 4px solid #3498db;
            border-radius: 3px;
        }

        li a {
            color: #3498db;
            text-decoration: none;
            font-weight: bold;
        }

        li a:hover {
            color: #2980b9;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Translated header with greeting and username -->
    <div class="header">
        <div>Hello, <strong><%= user.getName() %></strong>!</div>
        <a href="logout">Logout</a>
    </div>

    <!-- Translated title -->
    <h1>Welcome to Library Management System</h1>

    <!-- Translated section heading -->
    <h3>Features</h3>
    <ul>
        <% if ("READER".equals(user.getRole())) { %>
            <!-- Translated reader features -->
            <li><a href="CardRegistration.jsp">Register Reader Card</a></li>
            <%-- Add other READER functions here --%>
        <% } else if ("LIBRARIAN".equals(user.getRole())) { %>
            <!-- Translated librarian features -->
            <li><a href="DocumentReturnFrm.jsp">Return Book</a></li>
        <% } else if ("MANAGER".equals(user.getRole())) { %>

        <% } %>
    </ul>

</body>
</html>
