<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.library.libman.model.User" %>

<html>

<head>
    <title>Return Document</title>
    <!-- <link rel="stylesheet" type="text/css" href="style.css"> -->
    <style>
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

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
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
            font-size: 14px;
            color: #1565c0;
            margin-bottom: 20px;
            margin-top: 32px;
            padding: 0 32px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        hr {
            border: none;
            border-top: 2px solid #e1f5fe;
            margin: 32px 0;
        }

        /* Form Styling */
        form {
            padding: 0 32px;
            margin-bottom: 24px;
        }

        label {
            display: inline-block;
            font-weight: 600;
            color: #1565c0;
            margin-right: 16px;
            margin-bottom: 12px;
            font-size: 14px;
        }

        input[type="text"],
        input[type="submit"],
        select {
            padding: 12px 16px;
            border: 2px solid #90caf9;
            border-radius: 4px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: all 0.3s ease;
            margin-right: 8px;
        }

        input[type="text"] {
            background-color: white;
            color: #1a3a52;
            width: 250px;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: #1565c0;
            box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.1);
        }

        input[type="submit"],
        button {
            background-color: #1976d2;
            color: white;
            border: none;
            font-weight: 600;
            cursor: pointer;
            padding: 12px 24px;
        }

        input[type="submit"]:hover,
        button:hover {
            background-color: #0d47a1;
            box-shadow: 0 4px 12px rgba(13, 71, 161, 0.2);
        }

        button.button.back {
            background-color: #757575;
            color: white;
            border-radius: 4px; 
            margin-right: 20px;
        }

        button.button.back:hover {
            background-color: #616161;
            box-shadow: 0 4px 8px rgba(97, 97, 97, 0.2);
        }

        .button-group {
            text-align: center; 
            padding: 20px 32px 0 32px; 
        }

        .info-section {
            background: white;
            padding: 24px 32px;
            border-left: 4px solid #1976d2;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(13, 71, 161, 0.08);
            margin-bottom: 32px;
        }

        .info-section p {
            margin-bottom: 12px;
            font-size: 15px;
            line-height: 1.8;
        }

        .info-section strong {
            color: #0d47a1;
            font-weight: 600;
        }

        /* Table Styling */
        table {
            width: calc(100% - 64px);
            margin: 24px 32px;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 8px rgba(13, 71, 161, 0.1);
            border-radius: 4px;
            overflow: hidden;
        }

        thead {
            background: linear-gradient(135deg, #0d47a1 0%, #1565c0 100%);
            color: white;
        }

        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #e3f2fd;
            font-size: 14px;
            color: #1a3a52;
        }

        tbody tr {
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f0f7ff;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #1976d2;
        }

        /* Empty State */
        p {
            padding: 0 32px;
            color: #666;
        }
    </style>
</head>

<body>

    <% User user=(User) session.getAttribute("user"); if (user==null) { response.sendRedirect("login.jsp");
        return; } %>
        <div class="header">
            <div>Hello, <strong>
                    <%= user.getName() %>
                </strong>!</div>
        </div>
        <h1>Return Document</h1>

            <%-- Search for a reader --%>
                <h3>Find Reader</h3>
                <form action="search-reader" method="get">
                    <label for="readerCode">Enter Reader Code:</label>
                    <input type="text" id="readerCode" name="readerCode" value="${param.readerCode}"
                        required>
                    <input type="submit" value="Search">
                    <button type="button" style="border-radius: 4px;">Scan Card</button>
                </form>

                <%-- Display borrowed list --%>
                    <c:if test="${not empty foundReader}">
                        <hr>
                        <h3>Reader Information</h3>
                        <div class="info-section">
                            <p><strong>Code:</strong> ${foundReader.readerCode}</p>
                            <p><strong>Name:</strong> ${foundReader.name}</p>
                            <p><strong>Birthday:</strong> ${foundReader.birthday}</p>
                            <p><strong>Phone Number:</strong> ${foundReader.phoneNumber}</p>
                        </div>

                        <h3>Borrowing Document List</h3>
                        <c:import url="/borrow-slip">
                            <c:param name="readerId" value="${foundReader.id}" />
                        </c:import>
                        <c:if test="${not empty borrowingList}">
                            <form action="SelectedDocumentFrm.jsp" method="post">
                                <table>
                                    <thead>
                                        <th>No</th>
                                        <th>Document ID</th>
                                        <th>Document Title</th>
                                        <th>Borrow Date</th>
                                        <th>Due Date</th>
                                        <th>Select</th>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="detail" items="${borrowingList}" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td>${detail.document.id}</td>
                                                <td>${detail.document.title}</td>
                                                <td>${detail.borrowSlip.borrowDate}</td>
                                                <td>${detail.borrowSlip.dueDate}</td>
                                                <td>
                                                    <input type="checkbox" name="selectedDetails"
                                                        value="${detail.id}">
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="button-group">
                                    <button type="button" class="button back" onclick="history.back()">Back</button>
                                    <input type="hidden" name="readerCode" value="${foundReader.readerCode}">
                                    <input type="submit" value="Next">
                                </div>
                            </form>
                        </c:if>
                        <c:if test="${empty borrowingList}">
                            <p>No documents currently borrowed by this reader.</p>
                        </c:if>
                    </c:if>

                    
      
</body>

</html>